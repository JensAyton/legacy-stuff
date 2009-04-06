//
//  JAPixMap+ImageIO.h
//  CD-tangent
//
//  Created by Jens Ayton on 2009-04-04.
//  Copyright 2009 Jens Ayton. All rights reserved.
//

#import "JAPixMap.h"


@interface JAPixMap (ImageIO)

//- (BOOL) writeToURL:(NSURL *)url format:(NSString *)formatUTI quality:(double)quality compositeBackground:(NSColor *)background;
- (BOOL) writeToURL:(NSURL *)url format:(NSString *)formatUTI properties:(NSDictionary *)imageIOProperties;

@end
