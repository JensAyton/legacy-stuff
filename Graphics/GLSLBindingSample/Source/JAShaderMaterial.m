/*
	JAShaderMaterial.m
	
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

#import "JAShaderMaterial.h"
#import "JAShaderUniform.h"
#import "JAShaderProgram.h"
#import <OpenGL/gl.h>


@implementation JAShaderMaterial

- (id)initWithVertexShaderSource:(NSString *)vertexSource
			fragmentShaderSource:(NSString *)fragmentSource
{
	self = [super init];
	if (self != nil)
	{
		_shaderProgram = [[JAShaderProgram alloc] initWithVertexShaderSource:vertexSource
														fragmentShaderSource:fragmentSource];
		if (_shaderProgram == nil)
		{
			[self release];
			self = nil;
		}
	}
	
	return self;
}


- (void)dealloc
{
	[_shaderProgram release];
	[_uniforms release];
	
	[super dealloc];
}


- (BOOL)bindUniform:(NSString *)uniformName
		   toObject:(id)target
		   property:(SEL)selector
{
	JAShaderUniform			*uniform = nil;
	
	if (uniformName == nil) return NO;
	
	uniform = [[JAShaderUniform alloc] initWithName:uniformName
									  shaderProgram:_shaderProgram
									  boundToObject:target
										   property:selector];
	if (uniform != nil)
	{
		if (_uniforms == nil)  _uniforms = [[NSMutableDictionary alloc] init];
		
		[_uniforms setObject:uniform forKey:uniformName];
		[uniform release];
		return YES;
	}
	else
	{
		NSLog(@"Could not set uniform \"%@\"", uniformName);
		[_uniforms removeObjectForKey:uniformName];
		return NO;
	}
}


- (void)apply
{
	NSEnumerator			*uniformEnum = nil;
	JAShaderUniform			*uniform = nil;
	
	[_shaderProgram apply];
	
	NS_DURING
		for (uniformEnum = [_uniforms objectEnumerator]; (uniform = [uniformEnum nextObject]); )
		{
			[uniform apply];
		}
	NS_HANDLER
		/*	Supress exceptions during application of bound uniforms. We use a
			single exception handler around all uniforms because ObjC
			exceptions have some overhead.
		*/
		NSLog(@"Exception %@: %@ thrown while setting up uniforms!", [localException name], [localException reason]);
	NS_ENDHANDLER
}


- (void)setBindingTarget:(id)target
{
	NSEnumerator			*uniformEnum = nil;
	JAShaderUniform			*uniform = nil;
	
	for (uniformEnum = [_uniforms objectEnumerator]; (uniform = [uniformEnum nextObject]); )
	{
		[uniform setBindingTarget:target];
	}
}

@end
