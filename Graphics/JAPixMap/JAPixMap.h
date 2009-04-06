//
//  JAPixMap.h
//  JASunlightRenderer
//
//  Created by Jens Ayton on 2008-10-30.
//  Copyright 2008 Jens Ayton. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum
{
	kJAPixMapGray8,
	kJAPixMapRGBA8888
} JAPixMapFormat;


@interface JAPixMap: NSObject
{
@private
	NSUInteger				_width,
							_height,
							_bytesPerRow;
	void					*_bytes;
	CGContextRef			_context;
	JAPixMapFormat			_format;
}

@property (nonatomic, readonly) NSUInteger width, height, bytesPerRow, byteCount;
@property (nonatomic, readonly) void *bytes;
@property (nonatomic, readonly) JAPixMapFormat format;
@property (nonatomic, readonly) CGContextRef CGContext;

- (id) initWithWidth:(NSUInteger)width
			  height:(NSUInteger)height
			  format:(JAPixMapFormat)format;

- (id) initWithWidth:(NSUInteger)width
			  height:(NSUInteger)height
			  format:(JAPixMapFormat)format
			   bytes:(void *)bytes		// May be NULL
		 bytesPerRow:(NSUInteger)bytesPerRow
		   copyBytes:(BOOL)copyBytes;	// If NO, bytes will be free()d when pixmap dies.

/*	Copy another pixmap into alpha channel. Does nothing if target has no
	alpha channel. If alphaMap's format is gray, the one channel is used.
	If alphaMap's format has an alpha channel, that is used. If an RGB-only
	format is added, attempting to use an RGB alphaMap will fail.
	
	Note that this does *not* premultiply alpha, while loading images with
	initWithPath:/initWithURL: does (due to limitations in Core Graphics).
*/
- (BOOL) mergeAlphaChannel:(JAPixMap *)alphaMap;

- (void) clear;	// Alpha set to 0xFF, other channels to 0.
- (void) fill:(NSUInteger)pattern;	// Low-order bits used as pixel value.

@end


NSUInteger JAPixMapBytesPerPixel(JAPixMapFormat format) __attribute__((pure));
NSUInteger JAPixMapMinimumBytesPerRow(NSUInteger width, JAPixMapFormat format) __attribute__((pure));
NSUInteger JAPixMapOptimumBytesPerRow(NSUInteger width, JAPixMapFormat format) __attribute__((pure));
CGColorSpaceRef JAPixMapCopyCGColorSpaceForFormat(JAPixMapFormat format);
CGBitmapInfo JAPixMapCGBitmapInfoForFormat(JAPixMapFormat format) __attribute__((pure));
