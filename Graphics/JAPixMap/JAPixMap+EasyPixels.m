//
//  JAPixMap+EasyPixels.m
//  CD-tangent
//
//  Created by Jens Ayton on 2009-04-05.
//  Copyright 2009 Jens Ayton. All rights reserved.
//

#import "JAPixMap+EasyPixels.h"


static inline uint32_t PackPixelRGBA8888(JAPixMapRawPixel px)  __attribute__((const));
static inline uint8_t PackPixelGray8(JAPixMapRawPixel px)  __attribute__((const));
static inline JAPixMapRawPixel UnpackPixel(uint32_t px)  __attribute__((const));
static inline float ByteToFloat(uint8_t f)  __attribute__((const));
static inline uint8_t FloatToByte(float f)  __attribute__((const));
static inline JAPixMapFloatPixel PixelToFloat(JAPixMapRawPixel px)  __attribute__((const));
static inline JAPixMapRawPixel FloatToPixel(JAPixMapFloatPixel px)  __attribute__((const));
static inline float BiasFloat(float f)  __attribute__((const));
static inline float UnbiasFloat(float f)  __attribute__((const));
static inline JAPixMapFloatPixel BiasPixel(JAPixMapFloatPixel px)  __attribute__((const));
static inline JAPixMapFloatPixel UnbiasPixel(JAPixMapFloatPixel px)  __attribute__((const));


#if __LITTLE_ENDIAN__
static inline uint32_t PackPixelRGBA8888(JAPixMapRawPixel px)
{
	return	((uint32_t)px.r) |
			((uint32_t)px.g << 8) |
			((uint32_t)px.b << 16) |
			((uint32_t)px.a << 24);
}


static inline JAPixMapRawPixel UnpackPixel(uint32_t px)
{
	return (JAPixMapRawPixel)
	{
		.r = px & 0xFF,
		.g = (px >> 8) & 0xFF,
		.b = (px >> 16) & 0xFF,
		.a = (px >> 24) & 0xFF
	};
}
#elif __BIG_ENDIAN__
static inline uint32_t PackPixelRGBA8888(JAPixMapRawPixel px)
{
	return	((uint32_t)px.r << 24) |
			((uint32_t)px.g << 16) |
			((uint32_t)px.b << 8) |
			((uint32_t)px.a);
}


static inline JAPixMapRawPixel UnpackPixel(uint32_t px)
{
	return (JAPixMapRawPixel)
	{
		.r = (px >> 24) & 0xFF,
		.g = (px >> 16) & 0xFF,
		.b = (px >> 8) & 0xFF,
		.a = px & 0xFF
	};
}
#else
#error Unknown byte sex!
#endif


static inline uint8_t PackPixelGray8(JAPixMapRawPixel px)
{
	return FloatToByte((0.3 * px.r + 0.59 * px.g + 0.11 * px.b) * px.a);
}


static inline float ByteToFloat(uint8_t f)
{
	return (float)f / 255.0f;
}


static inline uint8_t FloatToByte(float f)
{
	/*	NOTE: multiplying by 256 and clamping is required for correct round-
		trip compatible rounding in all cases. (Without it, only 1.0 would
		give 0xFF, rather than 255/256 and up.)
	*/
	return fmaxf(0.0f, fminf(f * 256.0f, 255.0f));
}


static inline JAPixMapFloatPixel PixelToFloat(JAPixMapRawPixel px)
{
	return (JAPixMapFloatPixel)
	{
		.r = ByteToFloat(px.r),
		.g = ByteToFloat(px.g),
		.b = ByteToFloat(px.b),
		.a = ByteToFloat(px.a)
	};
}


static inline JAPixMapRawPixel FloatToPixel(JAPixMapFloatPixel px)
{
	return (JAPixMapRawPixel)
	{
		.r = FloatToByte(px.r),
		.g = FloatToByte(px.g),
		.b = FloatToByte(px.b),
		.a = FloatToByte(px.a)
	};
}


static inline float BiasFloat(float f)
{
	return f * 2.0f - 1.0f;
}


static inline float UnbiasFloat(float f)
{
	return f * 0.5f + 0.5f;
}


static inline JAPixMapFloatPixel BiasPixel(JAPixMapFloatPixel px)
{
	return (JAPixMapFloatPixel)
	{
		.r = BiasFloat(px.r),
		.g = BiasFloat(px.g),
		.b = BiasFloat(px.b),
		.a = BiasFloat(px.a)
	};
}


static inline JAPixMapFloatPixel UnbiasPixel(JAPixMapFloatPixel px)
{
	return (JAPixMapFloatPixel)
	{
		.r = UnbiasFloat(px.r),
		.g = UnbiasFloat(px.g),
		.b = UnbiasFloat(px.b),
		.a = UnbiasFloat(px.a)
	};
}


@implementation JAPixMap (EasyPixels)

- (JAPixMapRawPixel) pixelAtX:(NSUInteger)x y:(NSUInteger)y
{
	if (__builtin_expect(x < self.width || y < self.height, 1))
	{
		uint32_t val;
		
		switch (self.format)
		{
			case kJAPixMapRGBA8888:
				val = ((uint32_t *)self.bytes)[(self.bytesPerRow >> 2) * y + x];
				return UnpackPixel(val);
				
			case kJAPixMapGray8:
				val = ((uint8_t *)self.bytes)[self.bytesPerRow * y + x];
				return (JAPixMapRawPixel){ .r = val, .g = val, .b = val, .a = 0xFF };
				
			// No default: so we get warning if new formats are added
		}
	}
	
	return (JAPixMapRawPixel){ .r = 0, .g = 0, .b = 0, .a = 0xFF };
}


- (JAPixMapRawPixel) pixelAtPoint:(NSPoint)p
{
	return [self pixelAtX:p.x y:p.y];
}


- (void) setPixel:(JAPixMapRawPixel)value atX:(NSUInteger)x y:(NSUInteger)y
{
	if (__builtin_expect(x < self.width || y < self.height, 1))
	{
		switch (self.format)
		{
			case kJAPixMapRGBA8888:
				((uint32_t *)self.bytes)[(self.bytesPerRow >> 2) * y + x] = PackPixelRGBA8888(value);
				break;
				
			case kJAPixMapGray8:
			{
				((uint8_t *)self.bytes)[self.bytesPerRow * y + x] = PackPixelGray8(value);
				break;
			}
		}
	}
}


- (void) setPixel:(JAPixMapRawPixel)value atPoint:(NSPoint)p
{
	[self setPixel:value atX:p.x y:p.y];
}


- (JAPixMapFloatPixel) floatPixelAtX:(NSUInteger)x y:(NSUInteger)y
{
	return PixelToFloat([self pixelAtX:x y:y]);
}


- (JAPixMapFloatPixel) floatPixelAtPoint:(NSPoint)p
{
	return PixelToFloat([self pixelAtX:p.x y:p.y]);
}


- (void) setFloatPixel:(JAPixMapFloatPixel)value atX:(NSUInteger)x y:(NSUInteger)y
{
	[self setPixel:FloatToPixel(value) atX:x y:y];
}


- (void) setFloatPixel:(JAPixMapFloatPixel)value atPoint:(NSPoint)p
{
	[self setFloatPixel:value atX:p.x y:p.y];
}


- (JAPixMapFloatPixel) floatBiasedPixelAtX:(NSUInteger)x y:(NSUInteger)y
{
	return BiasPixel(PixelToFloat([self pixelAtX:x y:y]));
}


- (JAPixMapFloatPixel) floatBiasedPixelAtPoint:(NSPoint)p
{
	return [self floatBiasedPixelAtX:p.x y:p.y];
}


- (void) setFloatBiasedPixel:(JAPixMapFloatPixel)value atX:(NSUInteger)x y:(NSUInteger)y
{
	[self setPixel:FloatToPixel(UnbiasPixel(value)) atX:x y:y];
}


- (void) setFloatBiasedPixel:(JAPixMapFloatPixel)value atPoint:(NSPoint)p
{
	[self setFloatBiasedPixel:value atX:p.x y:p.y];
}


- (void) forEachPixelDo:(JAPixMapRawPixel(*)(NSUInteger x, NSUInteger y, JAPixMap *pixMap, void *context))function context:(void *)context
{
	NSUInteger				x, y, width, height, bytesPerRow;
	JAPixMapRawPixel		px;
	
	if (__builtin_expect(function == NULL, NO))  return;
	
	width = self.width;
	height = self.height;
	bytesPerRow = self.bytesPerRow;
	
	switch (self.format)
	{
		case kJAPixMapRGBA8888:
		{
			for (y = 0; y < width; y++)
			{
				uint32_t *pxRGBA = (uint32_t *)self.bytes + (self.bytesPerRow >> 2) * y;
				
				for (x = 0; x < width; x++)
				{
					px = function(x, y, self, context);
					*pxRGBA++ = PackPixelRGBA8888(px);
				}
			}
			break;
		}
			
		case kJAPixMapGray8:
		{
			for (y = 0; y < width; y++)
			{
				uint8_t *pxG = (uint8_t *)self.bytes + self.bytesPerRow * y;
				
				for (x = 0; x < width; x++)
				{
					px = function(x, y, self, context);
					*pxG++ = PackPixelGray8(px);
				}
			}
			break;
		}
		
		// No default: so we get warning if new formats are added
	}
}


typedef struct
{
	JAPixMapFloatPixel (*function)(NSUInteger x, NSUInteger y, JAPixMap *pixMap, void *context);
	void *context;
} FloatApplierContext;


JAPixMapRawPixel ApplyFloatFunc(NSUInteger x, NSUInteger y, JAPixMap *pixMap, void *context)
{
	FloatApplierContext *ctxt = context;
	return FloatToPixel(ctxt->function(x, y, pixMap, ctxt->context));
}


- (void) forEachFloatPixelDo:(JAPixMapFloatPixel(*)(NSUInteger x, NSUInteger y, JAPixMap *pixMap, void *context))function context:(void *)context
{
	FloatApplierContext appCtxt = { function, context };
	[self forEachPixelDo:ApplyFloatFunc context:&appCtxt];
}


typedef struct
{
	JAPixMapFloatPixel (*function)(NSUInteger x, NSUInteger y, JAPixMap *pixMap, void *context);
	void *context;
} FloatBiasedApplierContext;


JAPixMapRawPixel ApplyFloatBiasedFunc(NSUInteger x, NSUInteger y, JAPixMap *pixMap, void *context)
{
	FloatBiasedApplierContext *ctxt = context;
	return FloatToPixel(UnbiasPixel(ctxt->function(x, y, pixMap, ctxt->context)));
}


- (void) forEachFloatBiasedPixelDo:(JAPixMapFloatPixel(*)(NSUInteger x, NSUInteger y, JAPixMap *pixMap, void *context))function context:(void *)context
{
	FloatBiasedApplierContext appCtxt = { function, context };
	[self forEachPixelDo:ApplyFloatBiasedFunc context:&appCtxt];
}

@end
