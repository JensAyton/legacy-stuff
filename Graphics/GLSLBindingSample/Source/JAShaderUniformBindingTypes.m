/*
	JAShaderUniformBindingTypes.m
	
	
	Copyright © 2007 Jens Ayton
	
	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the “Software”), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
*/


/*
	For shader uniform binding to work, it is necessary to be able to tell the
	return type of a method. This is done by comparing the methodReturnType of
	a method's NSMethodSignature to those of methods in a template class, one
	method for each supported return type.
	
	Under OS X, the methodReturnType for a type foo is simply @encode(foo),
	but under the GNU runtime, it is the @encode() string for the entire
	method signature. In general, this is platform-defined. In order to
	maintain an implementation-agnostic approach, we get the signature from a
	known method of each time at runtime.
	
	NOTE: the GNU runtime's approach means that the methodReturnType differs
	between different method signatures with the same return type. For
	instance, a method -(id)foo:(int) will have a different methodReturnType
	than a method -(id)foo. As far as I can see this is a bug, but since we
	only support binding to methods with no parameters, this is not a problem.
*/


#import "JAShaderUniformBindingTypes.h"
#import "JAVector.h"

static BOOL				sInited = NO;
static const char		*sTemplates[kJAShaderUniformTypeCount];

static void InitTemplates(void);
static const char *CopyTemplateForSelector(SEL selector);


JAShaderUniformType JAShaderUniformTypeFromMethodSignature(NSMethodSignature *signature)
{
	unsigned				i;
	const char				*typeCode = NULL;
	
	if (sInited == NO)  InitTemplates();
	
	typeCode = [signature methodReturnType];
	if (typeCode == NULL)  return kJAShaderUniformTypeInvalid;
	
	for (i = kJAShaderUniformTypeInvalid + 1; i != kJAShaderUniformTypeCount; ++i)
	{
		if (sTemplates[i] != NULL && strcmp(sTemplates[i], typeCode) == 0)  return i;
	}
	
	return kJAShaderUniformTypeInvalid;
}


@interface JAShaderUniformTypeMethodSignatureTemplateClass: NSObject

- (float)floatMethod;
- (double)doubleMethod;
- (signed char)signedCharMethod;
- (unsigned char)unsignedCharMethod;
- (signed short)signedShortMethod;
- (unsigned short)unsignedShortMethod;
- (signed int)signedIntMethod;
- (unsigned int)unsignedIntMethod;
- (signed long)signedLongMethod;
- (unsigned long)unsignedLongMethod;
- (JAVector)vectorMethod;
- (NSPoint)pointMethod;
- (id)idMethod;

@end


static void InitTemplates(void)
{
	#define GET_TEMPLATE(enumValue, sel) do { \
					sTemplates[enumValue] = CopyTemplateForSelector(@selector(sel)); \
				} while (0)
	
	GET_TEMPLATE(kJAShaderUniformTypeChar,			signedCharMethod);
	GET_TEMPLATE(kJAShaderUniformTypeUnsignedChar,	unsignedCharMethod);
	GET_TEMPLATE(kJAShaderUniformTypeShort,			signedShortMethod);
	GET_TEMPLATE(kJAShaderUniformTypeUnsignedShort,	unsignedShortMethod);
	GET_TEMPLATE(kJAShaderUniformTypeInt,			signedIntMethod);
	GET_TEMPLATE(kJAShaderUniformTypeUnsignedInt,	unsignedIntMethod);
	GET_TEMPLATE(kJAShaderUniformTypeLong,			signedLongMethod);
	GET_TEMPLATE(kJAShaderUniformTypeUnsignedLong,	unsignedLongMethod);
	GET_TEMPLATE(kJAShaderUniformTypeFloat,			floatMethod);
	GET_TEMPLATE(kJAShaderUniformTypeDouble,		doubleMethod);
	GET_TEMPLATE(kJAShaderUniformTypeVector,		vectorMethod);
	GET_TEMPLATE(kJAShaderUniformTypeNSPoint,		pointMethod);
	GET_TEMPLATE(kJAShaderUniformTypeObject,		idMethod);
	
	sInited = YES;
}


static const char *CopyTemplateForSelector(SEL selector)
{
	NSMethodSignature		*signature = nil;
	const char				*typeCode = NULL;
	
	signature = [JAShaderUniformTypeMethodSignatureTemplateClass instanceMethodSignatureForSelector:selector];
	typeCode = [signature methodReturnType];
	
	/*	typeCode is *probably* a constant, but this isn't formally guaranteed
		as far as I'm aware, so we make a copy of it.
	*/
	return typeCode ? strdup(typeCode) : NULL;
}


@implementation JAShaderUniformTypeMethodSignatureTemplateClass: NSObject

- (signed char)signedCharMethod
{
	return 0;
}


- (unsigned char)unsignedCharMethod
{
	return 0;
}


- (signed short)signedShortMethod
{
	return 0;
}


- (unsigned short)unsignedShortMethod
{
	return 0;
}


- (signed int)signedIntMethod
{
	return 0;
}


- (unsigned int)unsignedIntMethod
{
	return 0;
}


- (signed long)signedLongMethod
{
	return 0;
}


- (unsigned long)unsignedLongMethod
{
	return 0;
}


- (float)floatMethod
{
	return 0.0f;
}


- (double)doubleMethod
{
	return 0.0;
}


- (JAVector)vectorMethod
{
	JAVector v = {0, 0, 0, 0};
	return v;
}


- (NSPoint)pointMethod
{
	return NSZeroPoint;
}


- (id)idMethod
{
	return nil;
}

@end
