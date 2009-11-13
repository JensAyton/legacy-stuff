//
//  JAPixMap.m
//  JASunlightRenderer
//
//  Created by Jens Ayton on 2008-10-30.
//  Copyright 2008 Jens Ayton. All rights reserved.
//

#import "JAPixMap.h"
#import "CollectionUtils.h"


#if TARGET_OS_IPHONE
static void MemsetPattern4(void *bytes, const void *pattern, size_t length);
#else
#define MemsetPattern4 memset_pattern4
#endif


static inline BOOL IsValidFormat(JAPixMapFormat format)
{
	return ((int)format >= kJAPixMapGray8) && (format <= kJAPixMapRGBA8888);
}


@implementation JAPixMap

@synthesize	width = _width, height = _height, bytesPerRow = _bytesPerRow,
			bytes = _bytes, format = _format;


- (id) initWithWidth:(NSUInteger)width
			  height:(NSUInteger)height
			  format:(JAPixMapFormat)format
{
	return [self initWithWidth:width
						height:height
						format:format
						 bytes:NULL
				   bytesPerRow:0
					 copyBytes:NO];
}

- (id) initWithWidth:(NSUInteger)width
			  height:(NSUInteger)height
			  format:(JAPixMapFormat)format
			   bytes:(void *)bytes
		 bytesPerRow:(NSUInteger)bytesPerRow
		   copyBytes:(BOOL)copyBytes
{
	BOOL					OK = YES;
	
	if (!IsValidFormat(format))  OK = NO;
	if (OK)
	{
		if (bytes == NULL)
		{
			copyBytes = NO;
			if (bytesPerRow == 0)  bytesPerRow = JAPixMapOptimumBytesPerRow(width, format);
		}
		if (bytesPerRow < JAPixMapMinimumBytesPerRow(width, format))  OK = NO;
	}
	
	if (OK && bytes == NULL)
	{
		copyBytes = NO;
		bytes = malloc(bytesPerRow * height);
		OK = bytes != NULL;
	}
	else if (OK && copyBytes)
	{
		void *newBytes = malloc(bytesPerRow * height);
		bcopy(bytes, newBytes, bytesPerRow * height);
		bytes = newBytes;
	}
	
	if (OK)
	{
		self = [super init];
		OK = (self != nil);
	}
	
	if (OK)
	{
		_width = width;
		_height = height;
		_bytesPerRow = bytesPerRow;
		_bytes = bytes;
		_format = format;
	}
	else
	{
		if (!copyBytes)  free(bytes);
		[self release];
		self = nil;
	}
	
	return self;
}


- (void) dealloc
{
	if (_context != NULL)  CFRelease(_context);
	if (_bytes != NULL)  free(_bytes);
	
	[super dealloc];
}


#ifndef NDEBUG
- (NSString *) description
{
	NSString *formatString = @"unknown format";
	switch (self.format)
	{
		case kJAPixMapGray8:
			formatString = @"Gray-8";
			break;
			
		case kJAPixMapRGBA8888:
			formatString = @"RGBA-8888";
			break;
	}
	return $sprintf(@"<%@ %p>{%@, %u x %u px}", self.class, self, formatString, self.width, self.height);
}
#endif


- (NSUInteger) byteCount
{
	return self.bytesPerRow * self.height;
}


- (CGContextRef) CGContext
{
	if (_context == NULL)
	{
		CGColorSpaceRef colorSpace = JAPixMapCopyCGColorSpaceForFormat(self.format);
		_context = CGBitmapContextCreate(self.bytes, self.width, self.height, 8, self.bytesPerRow, colorSpace, JAPixMapCGBitmapInfoForFormat(self.format));
		CFRelease(colorSpace);
	}
	
	return _context;
}


- (BOOL) mergeAlphaChannel:(JAPixMap *)alphaMap
{
	assert(0);
}


- (void) clear
{
	NSUInteger			pattern = 0;
	
	switch (self.format)
	{
		case kJAPixMapGray8:
			pattern = 0;
			break;
			
		case kJAPixMapRGBA8888:
			pattern = 0x000000FF;
			break;
	}
	
	[self fill:pattern];
}


- (void) fill:(NSUInteger)pattern
{
	uint8_t				buffer[4];
	
	switch (self.format)
	{
		case kJAPixMapGray8:
			memset(self.bytes, (uint8_t)pattern, self.byteCount);
			break;
			
		case kJAPixMapRGBA8888:
			buffer[0] = (pattern >> 24) & 0xFF;
			buffer[1] = (pattern >> 16) & 0xFF;
			buffer[2] = (pattern >> 8) & 0xFF;
			buffer[3] = pattern & 0xFF;
			MemsetPattern4(self.bytes, buffer, self.byteCount);
			break;
	}
}

@end


NSUInteger JAPixMapBytesPerPixel(JAPixMapFormat format)
{
	switch (format)
	{
		case kJAPixMapGray8:
			return 1;
		
		case kJAPixMapRGBA8888:
			return 4;
	}
	
	return 0;
}


NSUInteger JAPixMapMinimumBytesPerRow(NSUInteger width, JAPixMapFormat format)
{
	return JAPixMapBytesPerPixel(format) * width;
}


NSUInteger JAPixMapOptimumBytesPerRow(NSUInteger width, JAPixMapFormat format)
{
	enum
	{
#if TARGET_OS_IPHONE
		kOptimumPadding = 8
#else
		kOptimumPadding = 16
#endif
	};
	
	width = width + kOptimumPadding - 1;
	width -= width % kOptimumPadding;
	
	return JAPixMapBytesPerPixel(format) * width;
}


CGColorSpaceRef JAPixMapCopyCGColorSpaceForFormat(JAPixMapFormat format)
{
	switch (format)
	{
		case kJAPixMapGray8:
			return CGColorSpaceCreateDeviceGray();
			
		case kJAPixMapRGBA8888:
			return CGColorSpaceCreateDeviceRGB();
	}
	
	return NULL;
}


CGBitmapInfo JAPixMapCGBitmapInfoForFormat(JAPixMapFormat format)
{
	switch (format)
	{
		case kJAPixMapGray8:
			return kCGImageAlphaNone;
			
		case kJAPixMapRGBA8888:
			return kCGImageAlphaPremultipliedLast | kCGBitmapByteOrderDefault;
	}
	
	return 0;
}


#if TARGET_OS_IPHONE
/*	Implementation of memset_pattern4(), which (as of OS 2.1 SDK) is declared
	but not defined in iPhone OS. I don’t actually know enough about ARM to
	know whether this fullfills the no-alignment-required guarantee of
	memset_pattern4(), but don’t need that for this usage.
*/
static void MemsetPattern4(void *bytes, const void *pattern, size_t length)
{
	uint32_t			data;
	uint32_t			*dst;
	size_t				counter;
	const uint8_t		*tailSrc;
	uint8_t				*tailDst;
	
	dst = bytes;
	data = *(uint32_t *)pattern;
	counter = length >> 2;
	
	while (counter--)
	{
		*dst++ = data;
	}
	
	counter = length & 3;
	tailSrc = pattern;
	tailDst = (uint8_t *)dst;
	while (counter--)
	{
		*tailDst++ = *tailSrc++;
	}
}
#endif
