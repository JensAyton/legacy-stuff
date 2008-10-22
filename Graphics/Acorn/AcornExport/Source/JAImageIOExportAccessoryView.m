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


#import "JAImageIOExportAccessoryView.h"
#import "JAACPluginFramework.h"


@interface JAImageIOExportAccessoryView (Private)

- (void) buildMenuWithUTIs:(NSArray *)UTIs;
- (NSString *) typeNameForUTI:(NSString *)UTI;
- (void) menuItemSelected:(NSMenuItem *)item;
- (BOOL) showQualitySliderForUTI:(NSString *)UTI;
- (NSArray *)allowedExtensionsForUTI:(NSString *)UTI;

@end


static int CompareMenuItems(id a, id b, void *context);


@implementation JAImageIOExportAccessoryView

- (id) initWithSavePanel:(NSSavePanel *)panel
{
	self = [super initWithFrame:NSMakeRect(0, 0, 10, 10)];	// Actual frame will be taken from superview.
	if (self == nil)  return self;
	
	_panel = panel;
	if (panel == nil ||
		![NSBundle loadNibNamed:@"JAImageIOExportAccessoryView"
						  owner:self])
	{
		[self release];
		return nil;
	}
	
	[self setFrame:[_contentView frame]];
	[panel setAccessoryView:self];
		
	return self;
}


- (id) initWithFrame:(NSRect)frame
{
	[self release];
	return nil;
}


- (void) dealloc
{
	[_contentView release];
	
	[super dealloc];
}


- (void) awakeFromNib
{
	NSArray					*supportedUTIs = nil;
	id						pref = nil;
	NSString				*selectedUTI = @"public.png";
	double					quality = 0.75;
	
	supportedUTIs = (NSArray *)CGImageDestinationCopyTypeIdentifiers();
	[self buildMenuWithUTIs:supportedUTIs];
	
	pref = JAGetPreference(@"selected type");
	if ([pref isKindOfClass:[NSString class]])  selectedUTI = pref;
	if (![supportedUTIs containsObject:selectedUTI])  selectedUTI = [supportedUTIs objectAtIndex:0];
	[self setSelectedUTI:selectedUTI];
	
	pref = JAGetPreference(@"export quality");
	if ([pref respondsToSelector:@selector(doubleValue)])  quality = [pref doubleValue];
	[self setQuality:quality];
	
	[self addSubview:_contentView];
}

- (NSString *) selectedUTI
{
	return [[_formatMenuButton selectedItem] representedObject];
}


- (void) setSelectedUTI: (NSString *)UTI
{
	int						idx;
	
	if (UTI == nil)  return;
	
	idx = [[_formatMenuButton menu] indexOfItemWithRepresentedObject:UTI];
	if (idx >= 0)
	{
		JASetPreference(@"selected type", UTI);
		[_formatMenuButton selectItemAtIndex:idx];
		
		[_qualityHider setHidden:![self showQualitySliderForUTI:UTI]];
		
		// Set file extension.
		[_panel setAllowedFileTypes:[self allowedExtensionsForUTI:UTI]];
	}
}


- (double) quality
{
	return [_qualitySlider doubleValue];
}


- (void) setQuality:(double) quality
{
	[_qualitySlider setDoubleValue:fmin(fmax(quality, 0), 1)];
}


- (BOOL) selectedTypeSupportsQuality
{
	return [self showQualitySliderForUTI:[self selectedUTI]];
}


- (void) setSavePanel:(NSSavePanel *) panel
{
	_panel = panel;	// Not retained for reasons of cyclicity
}


- (void) saveSettings
{
	JASetPreference(@"selected type", [self selectedUTI]);
	if ([self selectedTypeSupportsQuality])
	{
		JASetPreference(@"export quality", [NSNumber numberWithDouble:[self quality]]);
	}
}

@end


@implementation JAImageIOExportAccessoryView (Private)

- (void) buildMenuWithUTIs:(NSArray *)UTIs
{
	NSMenu					*menu = nil;
	NSMenuItem				*item = nil;
	NSEnumerator			*enumerator = nil;
	NSString				*UTI = nil;
	NSString				*name = nil;
	NSMutableArray			*menuItems = nil;
	
	// Put items in an array for sortability.
	menuItems = [NSMutableArray array];
	for (enumerator = [UTIs objectEnumerator]; (UTI = [enumerator nextObject]); )
	{
		name = [self typeNameForUTI:UTI];
		item = [[NSMenuItem alloc] initWithTitle:name
										  action:@selector(menuItemSelected:)
								   keyEquivalent:@""];
		[item setTarget:self];
		[item setRepresentedObject:UTI];
		
		[menuItems addObject:item];
		[item release];
	}
	[menuItems sortUsingFunction:CompareMenuItems context:NULL];
	
	menu = [[NSMenu alloc] initWithTitle:@"Types"];	// Name is not user-visible
	for (enumerator = [menuItems objectEnumerator]; (item = [enumerator nextObject]); )
	{
		[menu addItem:item];
	}
	
	[_formatMenuButton setMenu:menu];
	[menu release];
}


- (NSString *) typeNameForUTI:(NSString *)UTI
{
	return (NSString *)UTTypeCopyDescription((CFStringRef)UTI);
}


- (void) menuItemSelected:(NSMenuItem *)item
{
	NSString				*UTI;
	
	UTI = [item representedObject];
	if (UTI == nil)  return;
	
	[self setSelectedUTI:UTI];
}


- (BOOL) showQualitySliderForUTI:(NSString *)UTI
{
	// There should be a robust way to do this, but I'm damned if I know what it is.
	if (UTTypeConformsTo((CFStringRef)UTI, CFSTR("public.jpeg")))  return YES;
	if (UTTypeConformsTo((CFStringRef)UTI, CFSTR("public.jpeg-2000")))  return YES;
	
	return NO;
}


/*	Get list of file name extensions relevant to a given file type.
	
	This is recursive (breadth-first), so that, for instance, it would allow
	an HTML file to be saved as foo.txt if you really wanted it to. This
	currently doesn't make a difference for images, but might if e.g.
	public.mng was added and public.png was declared to conform to it.
*/
- (NSArray *)allowedExtensionsForUTI:(NSString *)UTI
{
	NSMutableArray			*result = nil;
	NSString				*thisUTI = nil;
	NSDictionary			*thisUTIDecl = nil;
	NSMutableSet			*seenUTIs = nil;
	NSMutableArray			*queue = nil;
	id						thisConformsTo = nil;
	NSDictionary			*thisTypeTagSpec = nil;
	id						thisExtensions = nil;
	
	if (UTI == nil)  return nil;
	
	result = [NSMutableArray array];
	queue = [NSMutableArray arrayWithObject:UTI];	// Queue of types to process.
	seenUTIs = [NSMutableSet set];					// Used to avoid handling a type more than once.
	
	while ([queue count] != 0)
	{
		thisUTI = [queue objectAtIndex:0];
		[queue removeObjectAtIndex:0];
		if ([seenUTIs containsObject:thisUTI])  continue;
		[seenUTIs addObject:thisUTI];
		
		// Add UTIs this UTI conforms to to the queue.
		thisUTIDecl = (NSDictionary *)UTTypeCopyDeclaration((CFStringRef)thisUTI);
		thisConformsTo = [thisUTIDecl objectForKey:(NSString *)kUTTypeConformsToKey];
		// Conforms to may be an array or a single string.
		if ([thisConformsTo isKindOfClass:[NSString class]])
		{
			[queue addObject:thisConformsTo];
		}
		else if ([thisConformsTo isKindOfClass:[NSArray class]])
		{
			[queue addObjectsFromArray:thisConformsTo];
		}
		
		// Add extensions for this UTI to the result.
		thisTypeTagSpec = [thisUTIDecl objectForKey:(NSString *)kUTTypeTagSpecificationKey];
		if ([thisTypeTagSpec isKindOfClass:[NSDictionary class]])
		{
			thisExtensions = [thisTypeTagSpec objectForKey:(NSString *)kUTTagClassFilenameExtension];
			// Extensions may be an array or a single string.
			if ([thisExtensions isKindOfClass:[NSString class]])
			{
				[result addObject:thisExtensions];
			}
			else if ([thisExtensions isKindOfClass:[NSArray class]])
			{
				[result addObjectsFromArray:thisExtensions];
			}
		}
	}
	
	if ([result count] == 0)  result = nil;
	return result;
}

@end


static int CompareMenuItems(id a, id b, void *context)
{
#pragma unused (context)
	return [[a title] caseInsensitiveCompare:[b title]];
}
