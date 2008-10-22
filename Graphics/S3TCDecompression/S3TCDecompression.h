/*
	S3TCDecompression.h
	By Jens Ayton, October 2006
	Based on code by Denton Woods and Nicolas Weber for DevIL
	
	This code is hereby placed in the public domain.
	
	This code may be subject to patents in some countries.
*/

#ifndef INCLUDED_S3TCDecompression_h
#define INCLUDED_S3TCDecompression_h

#if __cplusplus
extern "C" {
#endif

#ifndef S3TCDECOMPRESS_NO_INCLUDES
#include <stdint.h>			/* For uint32_t, uint_fast32_t, uint_fast16_t, uint8_t */
#include <stdlib.h>			/* For malloc(), size_t, NULL */
#endif


#ifndef S3TCDECOMPRESS_BIG_ENDIAN
	#ifdef __BIG_ENDIAN__
		#define S3TCDECOMPRESS_BIG_ENDIAN 1
	#elif defined (__LITTLE_ENDIAN__) || defined(__i386__)
		#define S3TCDECOMPRESS_BIG_ENDIAN 0
	#else
		#error S3TCDECOMPRESS_BIG_ENDIAN undefined; must be 1 or 0
	#endif
#endif


typedef enum
{
	/*	IMPORTANT: only S3TCDecompressModeDXT3 has been tested. */
	S3TCDecompressModeDXT1 = 1,
	S3TCDecompressModeDXT2,
	S3TCDecompressModeDXT3,
	S3TCDecompressModeDXT4,
	S3TCDecompressModeDXT5
} S3TCDecompressMode;


typedef enum
{
	S3TCDecompressOK,
	
	/* Parameter errors */
	S3TCDecompressBadMode,			/* mode must be one of the values declared above */
	S3TCDecompressBadSource,		/* source must not be NULL */
	S3TCDecompressBadSourceSize,	/* source size is less than expected size for given mode and dimensions */
	S3TCDecompressBadWidth,			/* width must be a non-zero multiple of four */
	S3TCDecompressBadHeight,		/* height must be a non-zero multiple of four */
	S3TCDecompressBadResult,		/* result must be a pointer to a void pointer */
	
	/* Resource errors */
	S3TCDecompressAllocationFailure,
	
	S3TCDecompressUnimplemented
} S3TCDecompressError;


#ifndef S3TCDECOMPRESS_MALLOC
	#define S3TCDECOMPRESS_MALLOC	malloc
	#define S3TCDECOMPRESS_FREE		free
#endif


/*
	Convert S3TC-compressed data to 32-bit RGBA.
	Result is a malloced buffer, inWidth * inHeight * 4 bytes.
*/
extern S3TCDecompressError S3TCDecompress(S3TCDecompressMode inMode, const void *inSource, size_t inSourceSize, uint_fast32_t inWidth, uint_fast32_t inHeight, void **outResult);


#ifndef S3TCDECOMPRESS_NO_ERROR_STRING
/*	This will return a pointer to a static string which does not need to be deallocated.
	The string will not be localised or user-friendly.
*/
extern const char *S3TCDecompressErrorString(S3TCDecompressError inResult);
#endif


#endif	/* INCLUDED_S3TCDecompression_h */
