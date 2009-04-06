//
//  JAPixMap+ImageIO.m
//  CD-tangent
//
//  Created by Jens Ayton on 2009-04-04.
//  Copyright 2009 Jens Ayton. All rights reserved.
//

#import "JAPixMap+CGImage.h"


@implementation JAPixMap (ImageIO)

- (BOOL) writeToURL:(NSURL *)url format:(NSString *)formatUTI properties:(NSDictionary *)imageIOProperties
{
	CGImageDestinationRef		destination = NULL;
	CGImageRef					image = NULL;
	BOOL						OK = NO;
	
	destination = CGImageDestinationCreateWithURL((CFURLRef)url, (CFStringRef)formatUTI, 1, NULL);
	if (destination == NULL)  return NO;
	
	image = [self copyCGImageWithInterpolation:NO renderingIntent:kCGRenderingIntentDefault];
	if (image != NULL)
	{
		CGImageDestinationAddImage(destination, image, (CFDictionaryRef)imageIOProperties);
		OK = CGImageDestinationFinalize(destination);
		
		CFRelease(image);
	}
	CFRelease(destination);
	
	return OK;
}

@end
