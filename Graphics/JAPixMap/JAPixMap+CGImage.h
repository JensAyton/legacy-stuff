//
//  JAPixMap+CGImage.h
//  CD-tangent
//
//  Created by Jens Ayton on 2009-04-04.
//  Copyright 2009 Jens Ayton. All rights reserved.
//

#import "JAPixMap.h"


@interface JAPixMap (CGImage)

- (id) initWithCGImage:(CGImageRef)image;
- (id) initWithPNGImageAtPath:(NSString *)path;
- (id) initWithPNGImageAtURL:(NSURL *)url;
- (id) initWithJPEGImageAtPath:(NSString *)path;
- (id) initWithJPEGImageAtURL:(NSURL *)url;

/*	-loadImage: etc.
	Load an image into an existing pixmap.
	Note: image will be stretched to fit full pixmap. Use initWithPath: or
	initWithURL: to load an image at its native resolution and best pixel
	format.
	If image is nil, this is equivalent to -clear.
 */
- (BOOL) loadCGImage:(CGImageRef)image;
- (BOOL) loadPNGImageAtPath:(NSString *)path;
- (BOOL) loadPNGImageAtURL:(NSURL *)url;
- (BOOL) loadJPEGImageAtPath:(NSString *)path;
- (BOOL) loadJPEGImageAtURL:(NSURL *)url;

- (CGImageRef) copyCGImageWithInterpolation:(BOOL)shouldInterpolate renderingIntent:(CGColorRenderingIntent)intent;

@end
