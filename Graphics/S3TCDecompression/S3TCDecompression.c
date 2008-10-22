/*
	S3TCDecompression.c
	By Jens Ayton, October 2006
	Based on code by Denton Woods and Nicolas Weber for DevIL
	
	This code is hereby placed in the public domain.
	
	This code may be subject to patents in some countries.
*/

#include "S3TCDecompression.h"
#include <assert.h>
#include <stdio.h>


#ifndef GCC_ATTR
	#ifdef __GNUC__
		#define GCC_ATTR __attribute__
	#else
		#define GCC_ATTR(ignored)
	#endif
#endif


typedef struct
{
	uint8_t				r, g, b, a;
} ColorRGBA;


static size_t ExpectedSize(S3TCDecompressMode inMode, uint_fast32_t inWidth, uint_fast32_t inHeight);

/* These core functions assume error-free input. Checking the input is done by S3TCDecompress(). */
static void DecompressDXT1(const void *inSource, uint_fast32_t inWidth, uint_fast32_t inHeight, void **outResult);
static void DecompressDXT2(const void *inSource, uint_fast32_t inWidth, uint_fast32_t inHeight, void **outResult);
static void DecompressDXT3(const void *inSource, uint_fast32_t inWidth, uint_fast32_t inHeight, void **outResult);
static void DecompressDXT4(const void *inSource, uint_fast32_t inWidth, uint_fast32_t inHeight, void **outResult);
static void DecompressDXT5(const void *inSource, uint_fast32_t inWidth, uint_fast32_t inHeight, void **outResult);

static inline void ReadColorRGB565(const uint8_t *inData, ColorRGBA *outColor) GCC_ATTR((__always_inline__));
static void UnPremultiply(void *ioPixels, uint_fast32_t inWidth, uint_fast32_t inHeight);


extern S3TCDecompressError S3TCDecompress(S3TCDecompressMode inMode, const void *inSource, size_t inSourceSize, uint_fast32_t inWidth, uint_fast32_t inHeight, void **outResult)
{
	/* Sanity checking */
	if (NULL == outResult) return S3TCDecompressBadResult;
	*outResult = NULL;
	if (inMode < S3TCDecompressModeDXT1 || S3TCDecompressModeDXT5 < inMode) return S3TCDecompressBadMode;
	if (NULL == inSource) return S3TCDecompressBadSource;
	if (inSourceSize < ExpectedSize(inMode, inWidth, inHeight)) return S3TCDecompressBadSourceSize; /* Slop is permitted */
	if (0 == inWidth || inWidth % 4) return S3TCDecompressBadWidth; /* Require 4x4 pixel blocks */
	if (0 == inHeight || inHeight % 4) return S3TCDecompressBadHeight;
	
	*outResult = S3TCDECOMPRESS_MALLOC(4 * inWidth * inHeight);
	if (NULL == outResult) return S3TCDecompressAllocationFailure;
	
	switch (inMode)
	{
		case S3TCDecompressModeDXT1:
			DecompressDXT1(inSource, inWidth, inHeight, outResult);
			break;
		
		case S3TCDecompressModeDXT2:
			DecompressDXT2(inSource, inWidth, inHeight, outResult);
			break;
		
		case S3TCDecompressModeDXT3:
			DecompressDXT3(inSource, inWidth, inHeight, outResult);
			break;
		
		case S3TCDecompressModeDXT4:
			DecompressDXT4(inSource, inWidth, inHeight, outResult);
			break;
		
		case S3TCDecompressModeDXT5:
			DecompressDXT5(inSource, inWidth, inHeight, outResult);
			break;
		
		default:
			/* Should be unreachable. */
			S3TCDECOMPRESS_FREE(*outResult);
			return S3TCDecompressUnimplemented;
	}
	
	return S3TCDecompressOK;
}


#ifndef S3TCDECOMPRESS_NO_ERROR_STRING

extern const char *S3TCDecompressErrorString(S3TCDecompressError inResult)
{
	switch (inResult)
	{
		case S3TCDecompressOK:					return "no error";
		
		case S3TCDecompressBadMode:				return "unknown mode";
		case S3TCDecompressBadSource:			return "NULL source pointer";
		case S3TCDecompressBadSourceSize:		return "bad source size";
		case S3TCDecompressBadWidth:			return "bad width";
		case S3TCDecompressBadHeight:			return "bad height";
		case S3TCDecompressBadResult:			return "NULL result pointer";
		
		case S3TCDecompressAllocationFailure:	return "allocation failure";
		
		case S3TCDecompressUnimplemented:		return "unimplemented mode";
		
		default:								return "unknown error code";
	}
}

#endif


static size_t ExpectedSize(S3TCDecompressMode inMode, uint_fast32_t inWidth, uint_fast32_t inHeight)
{
	size_t					result;
	
	if (inWidth % 4 || inHeight % 4) result = 0; /* Require 4x4 blocks. */
	else if (S3TCDecompressModeDXT1 == inMode) result = inWidth * inHeight / 2;
	else if (S3TCDecompressModeDXT2 <= inMode && inMode <= S3TCDecompressModeDXT5) return inWidth * inHeight;
	else result = 0;
	
	return result;
}


/*	Expand a 16-bit colour (with the bit pattern rrrrrggg gggbbbbb) into 8-bit
	r, g and b values.
*/
static inline void ReadColorRGB565(const uint8_t *inData, ColorRGBA *outColor)
{
	uint8_t				r, g, b;
	
	b = inData[0] & 0x1F;
	g = ((inData[0] & 0xE0) >> 5) | ((inData[1] & 0x7) << 3);
	r = (inData[1] & 0xF8) >> 3;
	
	/*	Replicating the initial bits at the bottom of the byte is the standard way
		of ensuring that the byte's full range is used.
	*/
	outColor->r = (r << 3) | (r >> 2);
	outColor->g = (g << 2) | (g >> 4);
	outColor->b = (b << 3) | (b >> 2);
}


static void DecompressDXT1(const void *inSource, uint_fast32_t inWidth, uint_fast32_t inHeight, void **outResult)
{
	const uint8_t			*source;
	uint8_t					*result;
	uint_fast32_t			x, y,	/* coordinates of current block */
							sx, sy,	/* sub-coordinates within block */
							bitMask;
	uintptr_t				offset;
	ColorRGBA				colors[4], *col;
	uint16_t				col0, col1;
	
	source = inSource;
	result = *outResult;
	
	for (y = 0; y < inHeight; y += 4)
	{
		for (x = 0; x < inWidth; x += 4)
		{
			
			/*	Each 16-pixel block is stored as 64 bits.
				The first 32 bits are two colours in RGB-565 format. The remaining
				32 bits are a 16-entry two-bit look-up table to select colours.
				
				Colours 0 and 1 are those specified in the block. Colours 2 and 3
				are generated from these. If the numeric value of colour 0 is
				greater than that of colour one, they are interpolated with weights
				2,1 and 1,2. Otherwise, colour 2 is the average of 0 and 1, and
				colour 3 is fully transparent.
			*/
			col0 = source[0] | (source[1] << 8);
			col1 = source[2] | (source[3] << 8);
			ReadColorRGB565(source + 0, &colors[0]);
			ReadColorRGB565(source + 2, &colors[1]);
			colors[0].a = 0xFF;
			colors[1].a = 0xFF;
			bitMask = source[4] | (source[5] << 8) | (source[6] << 16) | (source[7] << 24);
			source += 8;
			
			/* Calculate interpolated colour values */
			if (col1 < col0)
			{
				colors[2].r = (2 * colors[0].r + colors[1].r + 1) / 3;
				colors[2].g = (2 * colors[0].g + colors[1].g + 1) / 3;
				colors[2].b = (2 * colors[0].b + colors[1].b + 1) / 3;
				colors[2].a = 0xFF;
				
				colors[3].r = (colors[0].r + 2 * colors[1].r + 1) / 3;
				colors[3].g = (colors[0].g + 2 * colors[1].g + 1) / 3;
				colors[3].b = (colors[0].b + 2 * colors[1].b + 1) / 3;
				colors[3].a = 0xFF;
			}
			else
			{
				colors[2].r = (colors[0].r + colors[1].r) / 2;
				colors[2].g = (colors[0].g + colors[1].g) / 2;
				colors[2].b = (colors[0].b + colors[1].b) / 2;
				colors[3].a = 0xFF;
				
				colors[3].r = 0;
				colors[3].g = 0;
				colors[3].b = 0;
				colors[3].a = 0;
			}
			
			for (sy = 0; sy != 4; ++sy)
			{
				for (sx = 0; sx != 4; ++sx)
				{
					offset = 4 * ((y + sy) * inWidth + (x + sx));
					col = &colors[bitMask & 0x3];
					*(uint32_t *)(result + offset) = *(uint32_t *)col;
					
					/* "advance" bitMask */
					bitMask >>= 2;
				}
			}
		}
	}
}


static void DecompressDXT2(const void *inSource, uint_fast32_t inWidth, uint_fast32_t inHeight, void **outResult)
{
	DecompressDXT3(inSource, inWidth, inHeight, outResult);
	UnPremultiply(*outResult, inWidth, inHeight);
}


static void DecompressDXT3(const void *inSource, uint_fast32_t inWidth, uint_fast32_t inHeight, void **outResult)
{
	const uint8_t			*source;
	uint8_t					*result;
	uint_fast32_t			x, y,	/* coordinates of current block */
							sx, sy,	/* sub-coordinates within block */
							alphaWord, a, bitMask;
	uintptr_t				offset;
	ColorRGBA				colors[4], *col;
	const uint8_t			*alphas;
	uint32_t				pixel;
	
	source = inSource;
	result = *outResult;
	
	for (y = 0; y < inHeight; y += 4)
	{
		for (x = 0; x < inWidth; x += 4)
		{
			/*	Each 16-pixel block is stored as 128 bits.
				The first 64 bits contain one 4-bit alpha value per pixel. This is
				followed by two colours in 16 bit RGB-565 format. The remaining 32
				bits are a 16-entry two-bit look-up table to select colours.
				
				Colours 0 and 1 are those specified in the block. Colours 2 and 3
				are interpolated from these, with weights 2,1 and 1,2 respectively.
			*/
			alphas = source;
			ReadColorRGB565(source + 8, &colors[0]);
			ReadColorRGB565(source + 10, &colors[1]);
			bitMask = source[12] | (source[13] << 8) | (source[14] << 16) | (source[15] << 24);
			source += 16;
			
			/* Calculate interpolated colour values */
			colors[2].r = (2 * colors[0].r + colors[1].r + 1) / 3;
			colors[2].g = (2 * colors[0].g + colors[1].g + 1) / 3;
			colors[2].b = (2 * colors[0].b + colors[1].b + 1) / 3;
			
			colors[3].r = (colors[0].r + 2 * colors[1].r + 1) / 3;
			colors[3].g = (colors[0].g + 2 * colors[1].g + 1) / 3;
			colors[3].b = (colors[0].b + 2 * colors[1].b + 1) / 3;
			
			for (sy = 0; sy != 4; ++sy)
			{
				alphaWord = alphas[2 * sy] + 0x100 * alphas[2 * sy + 1];
				
				for (sx = 0; sx != 4; ++sx)
				{
					offset = 4 * ((y + sy) * inWidth + (x + sx));
					
					col = &colors[bitMask & 0x3];
					
					/* Read 4-bit alpha and expand to 8 bits */
					a = alphaWord & 0xF;
					a |= a << 4;
					
					/* This semi-random write is the biggest bottleneck in the decompression. */
					#if 0
						/* Simple method, for debugging or strange byte sex. */
						result[offset + 0] = col->r;
						result[offset + 1] = col->g;
						result[offset + 2] = col->b;
						result[offset + 3] = a;
					#else
						/* Optimised bit-packing methods for big-endian and little-endian systems. */
						#if S3TCDECOMPRESS_BIG_ENDIAN
							pixel = a | ((*(uint32_t *)col) & 0xFFFFFF00);
						#else
							pixel = (a << 24) | ((*(uint32_t *)col) & 0x00FFFFFF);
						#endif
						*(uint32_t *)(result + offset) = pixel;
					#endif
					
					/* "advance" alphaWords and bitMask */
					alphaWord >>= 4;
					bitMask >>= 2;
				}
			}
		}
	}
}


static void DecompressDXT4(const void *inSource, uint_fast32_t inWidth, uint_fast32_t inHeight, void **outResult)
{
	DecompressDXT4(inSource, inWidth, inHeight, outResult);
	UnPremultiply(*outResult, inWidth, inHeight);
}


static void DecompressDXT5(const void *inSource, uint_fast32_t inWidth, uint_fast32_t inHeight, void **outResult)
{
	const uint8_t			*source;
	uint8_t					*result;
	uint_fast32_t			x, y,	/* coordinates of current block */
							sx, sy,	/* sub-coordinates within block */
							alphaWord, bitMask;
	uintptr_t				offset;
	ColorRGBA				colors[4], *col;
	uint8_t					alphas[8];
	const uint8_t			*alphaMask;
	
	source = inSource;
	result = *outResult;
	
	for (y = 0; y < inHeight; y += 4)
	{
		for (x = 0; x < inWidth; x += 4)
		{
			/*	Each 16-pixel block is stored as 128 bits.
				The first 16 bits are two 8-bit alpha values. These are followed
				by a 16-entry 3-bit-per-entry lookup table. The second 64 bits
				specify colours in the same way as DXT3.
			*/
			alphas[0] = source[0];
			alphas[1] = source[1];
			alphaMask = source + 2;
			ReadColorRGB565(source + 8, &colors[0]);
			ReadColorRGB565(source + 10, &colors[1]);
			bitMask = source[12] | (source[13] << 8) | (source[14] << 16) | (source[15] << 24);
			source += 16;
			
			colors[2].r = (2 * colors[0].r + colors[1].r + 1) / 3;
			colors[2].g = (2 * colors[0].g + colors[1].g + 1) / 3;
			colors[2].b = (2 * colors[0].b + colors[1].b + 1) / 3;
			
			colors[3].r = (colors[0].r + 2 * colors[1].r + 1) / 3;
			colors[3].g = (colors[0].g + 2 * colors[1].g + 1) / 3;
			colors[3].b = (colors[0].b + 2 * colors[1].b + 1) / 3;
			
			for (sy = 0; sy != 4; ++sy)
			{
				for (sx = 0; sx != 4; ++sx)
				{
					offset = 4 * ((y + sy) * inWidth + (x + sx));
					col = &colors[bitMask & 0x3];
					*(uint32_t *)(result + offset) = *(uint32_t *)col; /* Alpha will be set below */
					
					/* "advance" bitMask */
					bitMask >>= 2;
				}
			}
			
			/*	If alphas[1] < alphas[0], six interpolated alphas are generated,
				evenly distributed between the two. Otherwise, four are generated, 
				and the other two are 0 and 0xFF.
			*/
			if (alphas[1] < alphas[0])
			{
				alphas[2] = (6 * alphas[0] + 1 * alphas[1] + 3) / 7;
				alphas[3] = (5 * alphas[0] + 2 * alphas[1] + 3) / 7;
				alphas[4] = (4 * alphas[0] + 3 * alphas[1] + 3) / 7;
				alphas[5] = (3 * alphas[0] + 4 * alphas[1] + 3) / 7;
				alphas[6] = (2 * alphas[0] + 5 * alphas[1] + 3) / 7;
				alphas[7] = (1 * alphas[0] + 6 * alphas[1] + 3) / 7;
			}
			else
			{
				alphas[2] = (4 * alphas[0] + 1 * alphas[1] + 3) / 5;
				alphas[3] = (3 * alphas[0] + 2 * alphas[1] + 3) / 5;
				alphas[4] = (2 * alphas[0] + 2 * alphas[1] + 3) / 5;
				alphas[5] = (1 * alphas[0] + 3 * alphas[1] + 3) / 5;
				alphas[6] = 0x00;
				alphas[7] = 0xFF;
			}
			
			/*	Alpha is separated out into two loops, because the selector mask is
				48 bits. Could use a single loop on 64-bit systems. */
			alphaWord = alphaMask[0] | (alphaMask[1] << 8) | (alphaMask[2] << 16);
			for (sy = 0; sy < 2; sy++)
			{
				for (sx = 0; sx != 4; ++sx)
				{
					offset = 4 * ((y + sy) * inWidth + (x + sx));
					result[offset + 3] = alphas[alphaWord & 0x7];
					alphaWord >>= 3;
				}
			}
			
			alphaWord = alphaMask[3] | (alphaMask[4] << 8) | (alphaMask[5] << 16);
			for (; sy < 4; sy++)
			{
				for (sx = 0; sx != 4; ++sx)
				{
					offset = 4 * ((y + sy) * inWidth + (x + sx));
					result[offset + 3] = alphas[alphaWord & 0x7];
					alphaWord >>= 3;
				}
			}
		}
	}
}


/*	UnPremultiply: convert premultiplied alpha to separate alpha.
	Premultiplication works as follows:
		pR = R * A;
		pG = G * A;
		pB = B * A;
	In 8-bit integer terms, this is:
		pr = r * a / 255;
		pr = g * a / 255;
		pr = b * a / 255;
	
	To reverse this,
		R = pR / A;
		G = pG / A;
		B = pB / A;
	Or in integer terms:
		r = pr * 255 / a;
		g = pr * 255 / g;
		b = pr * 255 / b;
*/
static void UnPremultiply(void *ioPixels, uint_fast32_t inWidth, uint_fast32_t inHeight)
{
	ColorRGBA				*pixels;
	uint_fast32_t			remaining;
	uint_fast16_t			value;
	
	pixels = ioPixels;
	remaining = inWidth * inHeight;
	
	while (remaining--)
	{
		if (0 != pixels->a)
		{
			value = pixels->r;
			value = value * 255 / pixels->a;
			pixels->r = value;
			
			value = pixels->g;
			value = value * 255 / pixels->a;
			pixels->g = value;
			
			value = pixels->b;
			value = value * 255 / pixels->a;
			pixels->b = value;
		}
		pixels++;
	}
}
