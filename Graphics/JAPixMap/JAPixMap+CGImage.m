//
//  JAPixMap+CGImage.m
//  CD-tangent
//
//  Created by Jens Ayton on 2009-04-04.
//  Copyright 2009 Jens Ayton. All rights reserved.
//

#import "JAPixMap+CGImage.h"


@interface JAPixMap (CGImageInternal)

- (CGImageRef) createCGImageWithPNGAtURL:(NSURL *)url;
- (CGImageRef) createCGImageWithJPEGAtURL:(NSURL *)url;
- (JAPixMapFormat) pixelFormatForCGImage:(CGImageRef)image;

@end


static void ReleaseForCGDataProviderCallback(void *info, const void *data, size_t size);


@implementation JAPixMap (CGImage)

- (id) initWithCGImage:(CGImageRef)image
{
	BOOL						OK = YES;
	
	if (OK)
	{
		self = [self initWithWidth:CGImageGetWidth(image)
							height:CGImageGetHeight(image)
							format:[self pixelFormatForCGImage:image]];
		
		OK = (self != nil);
	}
	
	if (OK)
	{
		OK = [self loadCGImage:image];
	}
	
	if (OK == NO)
	{
		[self release];
		self = nil;
	}
	
	return self;
}


- (id) initWithPNGImageAtPath:(NSString *)path
{
	return [self initWithPNGImageAtURL:[NSURL fileURLWithPath:path]];
}


- (id) initWithPNGImageAtURL:(NSURL *)url
{
	BOOL						OK = YES;
	CGImageRef					image = NULL;
	
	image = [self createCGImageWithPNGAtURL:url];
	OK = (image != NULL);
	
	if (OK)
	{
		self = [self initWithCGImage:image];
	}
	
	if (image != NULL)
	{
		CFRelease(image);
	}
	
	return self;
}


- (id) initWithJPEGImageAtPath:(NSString *)path
{
	return [self initWithJPEGImageAtURL:[NSURL fileURLWithPath:path]];
}


- (id) initWithJPEGImageAtURL:(NSURL *)url
{
	BOOL						OK = YES;
	CGImageRef					image = NULL;
	
	image = [self createCGImageWithJPEGAtURL:url];
	OK = (image != NULL);
	
	if (OK)
	{
		self = [self initWithCGImage:image];
	}
	
	if (image != NULL)
	{
		CFRelease(image);
	}
	
	return self;
}


- (BOOL) loadCGImage:(CGImageRef)image
{
	CGContextRef				context = NULL;
	
	if (image == NULL || (context = self.CGContext) == nil)
	{
		[self clear];
		return NO;
	}
	
	CGContextDrawImage(context, CGRectMake(0, 0, self.width, self.height), image);
	return YES;
}


- (BOOL) loadPNGImageAtPath:(NSString *)path
{
	return [self loadPNGImageAtURL:[NSURL fileURLWithPath:path]];
}


- (BOOL) loadPNGImageAtURL:(NSURL *)url
{
	BOOL						OK = YES;
	CGImageRef					image = NULL;
	
	image = [self createCGImageWithPNGAtURL:url];
	OK = [self loadCGImage:image];
	if (image != NULL)  CFRelease(image);
	
	return OK;
}


- (BOOL) loadJPEGImageAtPath:(NSString *)path
{
	return [self loadJPEGImageAtURL:[NSURL fileURLWithPath:path]];
}


- (BOOL) loadJPEGImageAtURL:(NSURL *)url
{
	BOOL						OK = YES;
	CGImageRef					image = NULL;
	
	image = [self createCGImageWithJPEGAtURL:url];
	OK = [self loadCGImage:image];
	if (image != NULL)  CFRelease(image);
	
	return OK;
}


- (CGImageRef) copyCGImageWithInterpolation:(BOOL)shouldInterpolate renderingIntent:(CGColorRenderingIntent)intent
{
	CGColorSpaceRef		cSpace = NULL;
	CGDataProviderRef	provider = NULL;
	CGImageRef			image = NULL;
	
	[self retain];	// Balanced in ReleaseForCGDataProviderCallback()
	cSpace = JAPixMapCopyCGColorSpaceForFormat(self.format);
	provider = CGDataProviderCreateWithData(self, self.bytes, self.byteCount, ReleaseForCGDataProviderCallback);
	image = CGImageCreate(self.width, self.height, 8, JAPixMapBytesPerPixel(self.format) * 8, self.bytesPerRow, cSpace, JAPixMapCGBitmapInfoForFormat(self.format), provider, NULL, shouldInterpolate, intent);
	
	if (cSpace != NULL)  CFRelease(cSpace);
	if (provider != NULL) CFRelease(provider);
	
	return image;
}


- (CGImageRef) createCGImageWithPNGAtURL:(NSURL *)url
{
	CGDataProviderRef			dataProvider = NULL;
	CGImageRef					image = NULL;
	
	if (url == nil)  return NULL;
	
	dataProvider = CGDataProviderCreateWithURL((CFURLRef)url);
	if (dataProvider == NULL)  return NULL;
	
	image = CGImageCreateWithPNGDataProvider(dataProvider, NULL, NO, kCGRenderingIntentDefault);
	CFRelease(dataProvider);
	if (image == NULL)  return NULL;
	
	return image;
}


- (CGImageRef) createCGImageWithJPEGAtURL:(NSURL *)url
{
	CGDataProviderRef			dataProvider = NULL;
	CGImageRef					image = NULL;
	
	if (url == nil)  return NULL;
	
	dataProvider = CGDataProviderCreateWithURL((CFURLRef)url);
	if (dataProvider == NULL)  return NULL;
	
	image = CGImageCreateWithJPEGDataProvider(dataProvider, NULL, NO, kCGRenderingIntentDefault);
	CFRelease(dataProvider);
	if (image == NULL)  return NULL;
	
	return image;
}


- (JAPixMapFormat) pixelFormatForCGImage:(CGImageRef)image
{
	CGColorSpaceRef				colorSpace = NULL;
	
	if (image != NULL)  colorSpace = CGImageGetColorSpace(image);
	if (colorSpace != NULL && CGColorSpaceGetNumberOfComponents(colorSpace) == 1)  return kJAPixMapGray8;
	else  return kJAPixMapRGBA8888;
}

@end


static void ReleaseForCGDataProviderCallback(void *info, const void *data, size_t size)
{
	// Balances retain in copyCGImageWithInterpolation:renderingIntent:
	[(JAPixMap *)info release];
}
