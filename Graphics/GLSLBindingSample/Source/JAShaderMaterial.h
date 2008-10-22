/*
	JAShaderMaterial.h
	
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

#import <Foundation/Foundation.h>

@class JAShaderProgram;


@interface JAShaderMaterial: NSObject
{
	JAShaderProgram					*_shaderProgram;
	NSMutableDictionary				*_uniforms;
}

- (id)initWithVertexShaderSource:(NSString *)vertexSource
			fragmentShaderSource:(NSString *)fragmentSource;

- (void)apply;

/*	Bind a uniform to a property of an object.
	
	SelectorName should specify a method of source which returns the desired
	value; it will be called every time -apply is, assuming uniformName is
	used in the shader. (If not, JAShaderMaterial will not track the binding.)
	
	A bound method must not take any parameters, and must return one of the
	following types:
		* Any integer or float type (except long longs).
		* NSNumber.
		* NSColor.
		* JAVector.
	
	IMPORTANT: to avoid retain cycles, the binding target is not retained.
*/
- (BOOL)bindUniform:(NSString *)uniformName
		   toObject:(id)target
		   property:(SEL)selector;

- (void)setBindingTarget:(id)target;

@end
