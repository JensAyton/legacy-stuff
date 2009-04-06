//
//  JAPixMap+UIImage.m
//  World Clock
//
//  Created by Jens Ayton on 2008-11-07.
//  Copyright 2008 Jens Ayton. All rights reserved.
//

#import "JAPixMap+UIImage.h"
#import "JAPixMap+CGImage.h"


@implementation JAPixMap (UIImage)

- (UIImage *) asUIImage
{
	CGImageRef				cgImage = NULL;
	UIImage					*image = nil;
	
	cgImage = [self copyCGImageWithInterpolation:YES renderingIntent:kCGRenderingIntentDefault];
	image = [UIImage imageWithCGImage:cgImage];
	CFRelease(cgImage);
	
	return image;
}

@end
