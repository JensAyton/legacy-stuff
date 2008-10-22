/*
	JAShaderUniform.h
	
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


#import "JAShaderUniform.h"
#import "JAShaderProgram.h"
#import "JAVector.h"
#import <string.h>
#import "JAShaderUniformBindingTypes.h"
#import <Cocoa/Cocoa.h>


typedef char (*CharReturnMsgSend)(id, SEL);
typedef short (*ShortReturnMsgSend)(id, SEL);
typedef int (*IntReturnMsgSend)(id, SEL);
typedef long (*LongReturnMsgSend)(id, SEL);
typedef float (*FloatReturnMsgSend)(id, SEL);
typedef double (*DoubleReturnMsgSend)(id, SEL);
typedef JAVector (*VectorReturnMsgSend)(id, SEL);
typedef NSPoint (*PointReturnMsgSend)(id, SEL);


static inline BOOL ValidBindingType(JAShaderUniformType type)
{
	return kJAShaderUniformTypeInt <= type && type <= kJAShaderUniformTypeDouble;
}


@interface JAShaderUniform (OOPrivate)

- (id)initWithName:(NSString *)uniformName shaderProgram:(JAShaderProgram *)shaderProgram;

@end


@implementation JAShaderUniform

- (id)initWithName:(NSString *)uniformName
	 shaderProgram:(JAShaderProgram *)shaderProgram
	 boundToObject:(id)target
		  property:(SEL)selector
{
	BOOL					OK = YES;
	
	if (uniformName == nil || shaderProgram == nil || selector == NULL) OK = NO;
	
	if (OK)
	{
		self = [super init];
		if (self == nil)  OK = NO;
	}
	
	if (OK)
	{
		_location = glGetUniformLocationARB([shaderProgram program], [uniformName lossyCString]);
		if (_location == -1)
		{
			OK = NO;
			NSLog(@"Could not bind uniform \"%@\" to -[%@ %s] (no uniform of that name could be found).", uniformName, [target class], selector);
		}
	}
	
	// If we're still OK, it's a bindable method.
	if (OK)
	{
		_name = [uniformName copy];
		_selector = selector;
		
		if (target != nil)  [self setBindingTarget:target];
	}
	
	if (!OK)
	{
		[self release];
		self = nil;
	}
	return self;
}


- (void)dealloc
{
	[_name release];
	// target not retained.
	
	[super dealloc];
}


- (void)setBindingTarget:(id)target
{
	NSMethodSignature		*signature = nil;
	unsigned				argCount;
	NSString				*error = nil;
	
	if (_target == target)  return;
	
	if (target == nil)
	{
		error = @"target is nil";
	}
	
	if (error == nil && ![target respondsToSelector:_selector])
	{
		error = @"target does not respond to selector";
	}
	
	if (error == nil)
	{
		_method = [target methodForSelector:_selector];
		if (_method == NULL)
		{
			error = @"could not retrieve method implementation";
		}
	}
	
	if (error == nil)
	{
		signature = [target methodSignatureForSelector:_selector];
		if (signature == nil)
		{
			error = @"could not retrieve method signature";
		}
	}
	
	if (error == nil)
	{
		argCount = [signature numberOfArguments];
		if (argCount != 2)	// "no-arguments" methods actually take two arguments, self and _msg.
		{
			error = @"only methods which do not require arguments may be bound to";
		}
	}
	
	if (error == nil)
	{
		_type = JAShaderUniformTypeFromMethodSignature(signature);
		if (_type == kJAShaderUniformTypeInvalid)
		{
			error = [NSString stringWithFormat:@"unsupported type \"%s\"", [signature methodReturnType]];
		}
	}
	
	if (error == nil)
	{
		_target = target;
		_active = YES;
	}
	else
	{
		_active = NO;
		NSLog(@"Shader could not bind uniform \"%@\" to -[%@ %@] (%@).", _name, [target class], NSStringFromSelector(_selector), error);
	}
}


- (void)apply
{
	
	GLint						iVal;
	GLfloat						fVal;
	JAVector					vVal;
	GLfloat						expVVal[4];
	NSPoint						pVal = {0, 0};
	BOOL						isInt = NO, isFloat = NO, isVector = NO, isPoint = NO;
	id							objVal = nil;
	NSString					*colorSpaceName = nil;
	
	if (!_active)  return;
	if (_target == nil)  return;
	
	switch (_type)
	{
		case kJAShaderUniformTypeChar:
		case kJAShaderUniformTypeUnsignedChar:
			iVal = ((CharReturnMsgSend)_method)(_target, _selector);
			isInt = YES;
			break;
			
		case kJAShaderUniformTypeShort:
		case kJAShaderUniformTypeUnsignedShort:
			iVal = ((ShortReturnMsgSend)_method)(_target, _selector);
			isInt = YES;
			break;
			
		case kJAShaderUniformTypeInt:
		case kJAShaderUniformTypeUnsignedInt:
			iVal = ((IntReturnMsgSend)_method)(_target, _selector);
			isInt = YES;
			break;
			
		case kJAShaderUniformTypeLong:
		case kJAShaderUniformTypeUnsignedLong:
			iVal = ((LongReturnMsgSend)_method)(_target, _selector);
			isInt = YES;
			break;
			
		case kJAShaderUniformTypeFloat:
			fVal = ((FloatReturnMsgSend)_method)(_target, _selector);
			isFloat = YES;
			break;
			
		case kJAShaderUniformTypeDouble:
			fVal = ((DoubleReturnMsgSend)_method)(_target, _selector);
			isFloat = YES;
			break;
			
		case kJAShaderUniformTypeVector:
			vVal = ((VectorReturnMsgSend)_method)(_target, _selector);
			expVVal[0] = vVal.x;
			expVVal[1] = vVal.y;
			expVVal[2] = vVal.z;
			expVVal[3] = vVal.w;
			isVector = YES;
			break;
			
		case kJAShaderUniformTypeNSPoint:
			pVal = ((PointReturnMsgSend)_method)(_target, _selector);
			isPoint = YES;
			break;
			
		case kJAShaderUniformTypeObject:
			objVal = _method(_target, _selector);
			if ([objVal isKindOfClass:[NSNumber class]])
			{
				fVal = [objVal floatValue];
				isFloat = YES;
			}
			else if ([objVal isKindOfClass:[NSColor class]])
			{
				colorSpaceName = [objVal colorSpaceName];
				if (![colorSpaceName isEqualToString:NSCalibratedRGBColorSpace] &&
					![colorSpaceName isEqualToString:NSDeviceRGBColorSpace])
				{
					objVal = [objVal colorUsingColorSpaceName:NSDeviceRGBColorSpace];
				}
				expVVal[0] = [objVal redComponent];
				expVVal[1] = [objVal greenComponent];
				expVVal[2] = [objVal blueComponent];
				expVVal[3] = [objVal alphaComponent];
				isVector = YES;
			}
			break;
		
		case kJAShaderUniformTypeInvalid:
		case kJAShaderUniformTypeCount:
			return;
	}
	
	if (isFloat)
	{
		glUniform1fARB(_location, fVal);
	}
	else if (isInt)
	{
		glUniform1iARB(_location, iVal);
	}
	else if (isPoint)
	{
		GLfloat v2[2] = { pVal.x, pVal.y };
		glUniform2fvARB(_location, 1, v2);
	}
	else if (isVector)
	{
		glUniform4fvARB(_location, 1, expVVal);
	}
}

@end
