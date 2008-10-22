/*

Copyright © 2007 Jens Ayton

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/


#import "JAImageIOExportPlugin.h"
#import "JAACPluginFramework.h"
#import "JAImageIOExportAccessoryView.h"
#import <WebKit/CarbonUtils.h>	// Only NSImage -> CGImageRef converter in the system. WTF?

/*	Set to non-zero to use an Action menu item registered the proper way,
	instead of messing with the File menu. The problem with this is that it
	causes the current layer to be rasterized if it's a shape layer.
*/
#define USE_ACTION_ITEM		0


@interface NSObject (PrivateAcornMethods)

- (NSImage *) imageUsingVisibleLayers;

@end


@implementation JAImageIOExportPlugin

+ (id) plugin
{
    return [[[self alloc] init] autorelease];
}


- (void) willRegister:(id<ACPluginManager>)pluginManager
{
#if USE_ACTION_ITEM
	[pluginManager addActionMenuTitle:JAPlugLocalizedString(@"Export...", @"Command name.")
                   withSuperMenuTitle:nil
                               target:self
                               action:@selector(export:userObject:)
                        keyEquivalent:@"e"
            keyEquivalentModifierMask:NSCommandKeyMask | NSAlternateKeyMask
                           userObject:nil];
#endif
}


- (void) didRegister
{
#if !USE_ACTION_ITEM
	NSMenu					*fileMenu = nil;
	int						i, count, saveAsIndex, insertIndex = -1;
	NSMenuItem				*item = nil;
	
	fileMenu = [[[NSApp mainMenu] itemAtIndex:1] submenu];
	
	// Find "Save As..." menu item
	saveAsIndex = [fileMenu indexOfItemWithTarget:nil andAction:@selector(saveDocumentAs:)];
	if (saveAsIndex < 0)
	{
		[self reportCompatibilityError];
		return;
	}
	
	// Find next menu separator
	count = [fileMenu numberOfItems];
	for (i = saveAsIndex + 1; i < count; i++)
	{
		item = [fileMenu itemAtIndex:i];
		if ([item isSeparatorItem])
		{
			insertIndex = i;
			break;
		}
	}
	
	if (insertIndex == -1)
	{
		[self reportCompatibilityError];
		return;
	}
	
	// Insert separator and Export menu item
	[fileMenu insertItem:[NSMenuItem separatorItem] atIndex:insertIndex];
	item = [[NSMenuItem alloc] initWithTitle:JAPlugLocalizedString(@"Export...", @"Command name.")
									  action:@selector(exportDocument:)
							   keyEquivalent:@"e"];
	[item setKeyEquivalentModifierMask:NSCommandKeyMask | NSAlternateKeyMask];
	[item setTarget:self];
	[fileMenu insertItem:item atIndex:insertIndex + 1];
	[item release];
#endif
}


#if USE_ACTION_ITEM
- (CIImage*) export:(CIImage*)inImage userObject:(id)uo
{
#pragma unused (inImage, ui)
	[self exportDocument:sender];
}
#endif


- (void) exportDocument:(id)sender
{
#pragma unused (sender)
	/*	This is naughty and undocumented. No documented and non-naughty method
		of getting the full image exists. Thank goodness for class-dump.
		
		Because of the undocumentedness, this is very careful to validate
		everything. If one of the methods it uses starts returning a
		non-object, there will be a problem. Otherwise, it should be OK.
	*/
	id						document = nil;
	NSImage					*image = nil;
	NSString				*name = nil;
	
	// Get current document.
	document = [[NSDocumentController sharedDocumentController] currentDocument];
	if (document == nil)
	{
		NSLog(@"ImageIO Export failure: document is nil.");
		[self reportCompatibilityError];
		return;
	}
	
	// Get composite image and verify that it's an NSImage.
	if (![document respondsToSelector:@selector(imageUsingVisibleLayers)])
	{
		NSLog(@"ImageIO Export failure: document does not respond to -imageUsingVisibleLayers.");
		[self reportCompatibilityError];
		return;
	}
	
	image = [document imageUsingVisibleLayers];
	if (image == nil)
	{
		NSLog(@"ImageIO Export failure: -imageUsingVisibleLayers returned nil.");
		[self reportCompatibilityError];
		return;
	}
	
	if (![image isKindOfClass:[NSImage class]])
	{
		NSLog(@"ImageIO Export failure: -imageUsingVisibleLayers returned unexpected class (%@).", [image className]);
		[self reportCompatibilityError];
		return;
	}
	
	// Get document name (non-critical).
	if ([document respondsToSelector:@selector(displayName)])
	{
		name = [document displayName];
		if (![name isKindOfClass:[NSString class]])  name = nil;
		name = [name stringByDeletingPathExtension];
	}
	if (name == nil)  name = JAPlugLocalizedString(@"untitled", @"Untitled image name");
	
	[self exportImage:image name:name];
}


- (void) exportImage:(NSImage *)image name:(NSString *)name
{
	CGImageRef				cgImage = NULL;
	NSURL					*URL = nil;
	NSString				*UTI = nil;
	NSDictionary			*properties = nil;
	CGImageDestinationRef	destination = NULL;
	
	// Convert image to CG image.
	cgImage = WebConvertNSImageToCGImageRef(image);
	if (cgImage == NULL)
	{
		[self reportConversionError:JAPlugLocalizedString(@"Could not convert the image to the format required by ImageIO.", @"NSBitmapImageRep -> CGImageRef conversion failure error message")];
		return;
	}
	[(id)cgImage autorelease];
	
	// We appear to have an image to export, so ask where to put it.
	if (![self requestExportLocation:&URL
							 andType:&UTI
					   andProperties:&properties
					   forImageNamed:name])  return;	// User cancelled.
	
	// Create and configure ImageIO destination object.
	destination = CGImageDestinationCreateWithURL((CFURLRef)URL, (CFStringRef)UTI, 1, NULL);
	if (destination == NULL)
	{
		[self reportConversionError:[NSString stringWithFormat:JAPlugLocalizedString(@"The ImageIO Export plug-in could not configure an ImageIO exporter for %@", @"Error message on failing to create CGImageDestination"), [[URL path] lastPathComponent]]];
		return;
	}
	[(id)destination autorelease];
	
	// Write the picture.
	if (properties == nil)  properties = [NSDictionary dictionary];
	CGImageDestinationAddImage(destination, cgImage, (CFDictionaryRef)properties);
	if (!CGImageDestinationFinalize(destination))
	{
		[self reportConversionError:JAPlugLocalizedString(@"ImageIO failed to write the file.", @"CGImageDestinationFinalize() failure error message")];
	}
}


- (BOOL) requestExportLocation:(NSURL **)outLocation
					   andType:(NSString **)outUTI
				 andProperties:(NSDictionary **)outProperties
				 forImageNamed:(NSString *)name
{
	NSSavePanel				*panel = nil;
	BOOL					hideExtension = NO;
	JAImageIOExportAccessoryView *accessoryView;
	id						pref;
	double					quality;
	
	assert(outLocation != NULL && outUTI != NULL && outProperties != nil);
	*outLocation = nil;
	*outUTI = nil;
	*outProperties = nil;
	
	pref = JAGetPreference(@"hide file name extension");
	if ([pref respondsToSelector:@selector(boolValue)])  hideExtension = [pref boolValue];
	
	// Configure save panel.
	panel = [NSSavePanel savePanel];
	[panel setCanSelectHiddenExtension:YES];
	[panel setExtensionHidden:hideExtension];
	[panel setTitle:JAPlugLocalizedString(@"ImageIO Export", @"Dialog title")];
	[panel setNameFieldLabel:JAPlugLocalizedString(@"Export As:", @"Dialog name field label")];
	
	// Add accessory view (with format and quality controls).
	accessoryView = [[[JAImageIOExportAccessoryView alloc] initWithSavePanel:panel] autorelease];
	
	// Run save panel.
	if ([panel runModalForDirectory:nil file:name] != NSFileHandlingPanelOKButton)  return NO;
	
	// Get results.
	*outLocation = [panel URL];
	*outUTI = [accessoryView selectedUTI];
	if ([accessoryView selectedTypeSupportsQuality])
	{
		quality = [accessoryView quality];
		*outProperties = [NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:[accessoryView quality]]
													 forKey:(NSString *)kCGImageDestinationLossyCompressionQuality];
	}
	
	JASetPreference(@"hide file name extension", [NSNumber numberWithBool:[panel isExtensionHidden]]);
	
	[accessoryView saveSettings];
	
	return YES;
}


- (void) reportCompatibilityError
{
	static BOOL				haveReported = NO;
	NSAlert					*alert = nil;
	NSString				*version = nil;
	
	if (haveReported)  return;
	haveReported = YES;
	
	version = [[NSBundle bundleForClass:[self class]] objectForInfoDictionaryKey:@"CFBundleVersion"];
	alert = [NSAlert alertWithMessageText:JAPlugLocalizedString(@"The ImageIO Export plug-in is not compatible with this version of Acorn.", @"Error message for methods not existing or doing what we expect.")
							defaultButton:nil	// Default, i.e. OK
						  alternateButton:nil
							  otherButton:nil
				informativeTextWithFormat:JAPlugLocalizedString(@"The ImageIO Export plug-in relies on undocumented details of Acorn's design, which appear to have changed. Please check http://jens.ayton.se/acorn/ for a new version of the plug-in (you are currently using version %@).", @"Error message details for methods not existing or doing what we expect."), version];
	[alert runModal];
}


- (void) reportConversionError:(NSString *)error
{
	NSAlert					*alert = nil;
	
	alert = [NSAlert alertWithMessageText:JAPlugLocalizedString(@"The image could not be exported.", @"Export failure error alert title")
							defaultButton:nil	// Default, i.e. OK
						  alternateButton:nil
							  otherButton:nil
				informativeTextWithFormat:@"%@", error];
	[alert runModal];
}


- (BOOL)validateMenuItem:(id <NSMenuItem>)menuItem
{
	return [[NSDocumentController sharedDocumentController] currentDocument] != nil;
}

@end
