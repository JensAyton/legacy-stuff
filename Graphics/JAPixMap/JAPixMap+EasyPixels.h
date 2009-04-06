/*
	JAPixMap+EasyPixels.h
	
	Easy access to pixels, with little thought given to efficiency.
*/

#import "JAPixMap.h"


#if __LITTLE_ENDIAN__
typedef struct
{
	uint8_t				r, g, b, a;
} JAPixMapRawPixel;
#else
typedef struct
{
	uint8_t				a, b, g, r;
} JAPixMapRawPixel;
#endif


typedef struct
{
	float				r, g, b, a;
} JAPixMapFloatPixel;


@interface JAPixMap (EasyPixels)

- (JAPixMapRawPixel) pixelAtX:(NSUInteger)x y:(NSUInteger)y;
- (JAPixMapRawPixel) pixelAtPoint:(NSPoint)p;
- (void) setPixel:(JAPixMapRawPixel)value atX:(NSUInteger)x y:(NSUInteger)y;
- (void) setPixel:(JAPixMapRawPixel)value atPoint:(NSPoint)p;

// Range: 0..1
- (JAPixMapFloatPixel) floatPixelAtX:(NSUInteger)x y:(NSUInteger)y;
- (JAPixMapFloatPixel) floatPixelAtPoint:(NSPoint)p;
- (void) setFloatPixel:(JAPixMapFloatPixel)value atX:(NSUInteger)x y:(NSUInteger)y;
- (void) setFloatPixel:(JAPixMapFloatPixel)value atPoint:(NSPoint)p;

// Range: -1..1
- (JAPixMapFloatPixel) floatBiasedPixelAtX:(NSUInteger)x y:(NSUInteger)y;
- (JAPixMapFloatPixel) floatBiasedPixelAtPoint:(NSPoint)p;
- (void) setFloatBiasedPixel:(JAPixMapFloatPixel)value atX:(NSUInteger)x y:(NSUInteger)y;
- (void) setFloatBiasedPixel:(JAPixMapFloatPixel)value atPoint:(NSPoint)p;

// Iterate over pixels
- (void) forEachPixelDo:(JAPixMapRawPixel(*)(NSUInteger x, NSUInteger y, JAPixMap *pixMap, void *context))function context:(void *)context;
- (void) forEachFloatPixelDo:(JAPixMapFloatPixel(*)(NSUInteger x, NSUInteger y, JAPixMap *pixMap, void *context))function context:(void *)context;
- (void) forEachFloatBiasedPixelDo:(JAPixMapFloatPixel(*)(NSUInteger x, NSUInteger y, JAPixMap *pixMap, void *context))function context:(void *)context;

@end
