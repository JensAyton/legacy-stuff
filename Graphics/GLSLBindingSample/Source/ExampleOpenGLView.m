/*
	ExampleOpenGLView.m
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

#import "ExampleOpenGLView.h"
#import "ExampleModel.h"
#import "JAShaderMaterial.h"
#import <OpenGL/gl.h>
#import <OpenGL/glu.h>


@implementation ExampleOpenGLView

- (void)dealloc
{
	[_material release];
	[_model release];
	gluDeleteQuadric(_quadric);
	
	[super dealloc];
}


- (float)mainLightAngle
{
	return _light0Angle;
}


- (void)setMainLightAngle:(float)angle
{
	angle = fmod(angle, 360);
	
	if (angle != _light0Angle)
	{
		_light0Angle = angle;
		[self setNeedsDisplay:YES];
	}
}


- (float)secondaryLightAngle
{
	return _light1Angle;
}


- (void)setSecondaryLightAngle:(float)angle
{
	angle = fmod(angle, 360);
	
	if (angle != _light1Angle)
	{
		_light1Angle = angle;
		[self setNeedsDisplay:YES];
	}
}


- (ExampleModel *)model
{
	return _model;
}


- (void)setModel:(ExampleModel *)model
{
	if (model != _model)
	{
		[_model autorelease];
		_model = [model retain];
		[self setNeedsDisplay:YES];
	}
}


- (void)setUp
{
	NSString				*path = nil,
							*vertSource = nil,
							*fragSource = nil;
	NSBundle				*bundle = nil;
	
	_haveSetUp = YES;
	
	_quadric = gluNewQuadric();
	
	bundle = [NSBundle mainBundle];
	path = [bundle pathForResource:@"ExampleShader" ofType:@"vert"];
	if (path != nil)  vertSource = [NSString stringWithContentsOfFile:path];
	path = [bundle pathForResource:@"ExampleShader" ofType:@"frag"];
	if (path != nil)  fragSource = [NSString stringWithContentsOfFile:path];
	
	_material = [[JAShaderMaterial alloc] initWithVertexShaderSource:vertSource
												fragmentShaderSource:fragSource];
	
	if (_material != nil)
	{
		// Bind shader uniforms to model attributes.
		[_material bindUniform:@"uColor" toObject:_model property:@selector(color)];
		[_material bindUniform:@"uShininess" toObject:_model property:@selector(shininess)];
		
		NSLog(@"Shader material set up OK.");
	}
	else
	{
		NSLog(@"Failed to set up shader material.");
	}
}


- (void)drawRect:(NSRect)rect
{
	NSSize					dimensions;
	GLfloat					lightPos0[4] = {0, 3, -5, 1},
							lightPos1[4] = {0, 4, -5, 1},
							lightCol0[4] = {1, 0.9, 0.9, 1},
							lightCol1[4] = {0.05, 0.1, 0.2, 1},
							ambientCol[4] = {0.1, 0.1, 0.1, 1};
	
	if (!_haveSetUp)  [self setUp];
	
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	dimensions = [self bounds].size;
	glViewport(0, 0, dimensions.width, dimensions.height);
	
	dimensions.width = dimensions.width / dimensions.height;
	dimensions.height = 1.0;
	glOrtho(-dimensions.width, dimensions.width, -dimensions.height, dimensions.height, -2000, 2000);
	
	glClearColor(0.1, 0.1, 0.1, 1.0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	glEnable(GL_LIGHTING);
	glEnable(GL_LIGHT0);
	glEnable(GL_LIGHT1);
	glRotatef(_light0Angle, 0, 1, 0);
	glLightfv(GL_LIGHT0, GL_POSITION, lightPos0);
	glLightfv(GL_LIGHT0, GL_DIFFUSE, lightCol0);
	glRotatef(_light1Angle - _light0Angle, 0, 1, 0);
	glLightfv(GL_LIGHT1, GL_POSITION, lightPos1);
	glLightfv(GL_LIGHT1, GL_DIFFUSE, lightCol1);
	glLightModelfv(GL_LIGHT_MODEL_AMBIENT, ambientCol);
	
	glLoadIdentity();
	glTranslatef(0, 0, -2);
	
	[_material apply];
	gluSphere(_quadric, 0.8, 50, 25);
	
	glFlush();
	[[self openGLContext] flushBuffer];
}

@end
