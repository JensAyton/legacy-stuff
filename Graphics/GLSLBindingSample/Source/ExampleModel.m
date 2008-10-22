/*
	ExampleModel.m
	GLSLBindingSample
	
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

#import "ExampleModel.h"


@implementation ExampleModel

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		_shininess = 2.0f;
		_color = [[NSColor lightGrayColor] retain];
	}
	return self;
}


- (void)dealloc
{
	[_color release];
	
	[super dealloc];
}


- (float)shininess
{
	return _shininess;
}


- (void)setShininess:(float)shininess
{
	if (shininess < 0.0f) shininess = 0.0f;
	if (10.0 < shininess) shininess = 10.0;
	_shininess = shininess;
}

- (NSColor *)color
{
	return _color;
}


- (void)setColor:(NSColor *)color
{
	if (color != nil)
	{
		[_color autorelease];
		_color = [color retain];
	}
}

@end
