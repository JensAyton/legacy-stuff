/*
	JAShaderProgram.m
	
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


#import "JAShaderProgram.h"


static NSString *GetGLSLInfoLog(GLhandleARB shaderObject);


@implementation JAShaderProgram

- (id)initWithVertexShaderSource:(NSString *)vertexSource
			fragmentShaderSource:(NSString *)fragmentSource
{
	BOOL					OK = YES;
	const GLcharARB			*sourceString = nil;
	GLint					compileStatus;
	
	self = [super init];
	if (self == nil)  OK = NO;
	
	if (OK && vertexSource == nil && fragmentSource == nil)  OK = NO;	// Must have at least one shader!
	
	if (OK && vertexSource != nil)
	{
		// Compile vertex shader.
		_vertexShader = glCreateShaderObjectARB(GL_VERTEX_SHADER_ARB);
		if (_vertexShader != NULL)
		{
			sourceString = [vertexSource lossyCString];
			glShaderSourceARB(_vertexShader, 1, &sourceString, NULL);
			glCompileShaderARB(_vertexShader);
			
			glGetObjectParameterivARB(_vertexShader, GL_OBJECT_COMPILE_STATUS_ARB, &compileStatus);
			if (compileStatus != GL_TRUE)
			{
				NSLog(@"***** GLSL %s shader compilation failed:\n>>>>> GLSL log:\n%@\n\n>>>>> GLSL source code:\n%@\n", "vertex", GetGLSLInfoLog(_vertexShader), vertexSource);
				OK = NO;
			}
		}
		else  OK = NO;
	}
	
	if (OK && fragmentSource != nil)
	{
		// Compile fragment shader.
		_fragmentShader = glCreateShaderObjectARB(GL_FRAGMENT_SHADER_ARB);
		if (_fragmentShader != NULL)
		{
			sourceString = [fragmentSource lossyCString];
			glShaderSourceARB(_fragmentShader, 1, &sourceString, NULL);
			glCompileShaderARB(_fragmentShader);
			
			glGetObjectParameterivARB(_fragmentShader, GL_OBJECT_COMPILE_STATUS_ARB, &compileStatus);
			if (compileStatus != GL_TRUE)
			{
				NSLog(@"***** GLSL %s shader compilation failed:\n>>>>> GLSL log:\n%@\n\n>>>>> GLSL source code:\n%@\n", "fragment", GetGLSLInfoLog(_fragmentShader), fragmentSource);
				OK = NO;
			}
		}
		else  OK = NO;
	}
	
	if (OK)
	{
		// Link shader.
		_program = glCreateProgramObjectARB();
		if (_program != NULL)
		{
			if (_vertexShader != NULL)  glAttachObjectARB(_program, _vertexShader);
			if (_fragmentShader != NULL)  glAttachObjectARB(_program, _fragmentShader);
			glLinkProgramARB(_program);
			
			glGetObjectParameterivARB(_program, GL_OBJECT_LINK_STATUS_ARB, &compileStatus);
			if (compileStatus != GL_TRUE)
			{
				NSLog(@"***** GLSL shader linking failed:\n>>>>> GLSL log:\n%@\n", GetGLSLInfoLog(_program));
				OK = NO;
			}
		}
		else  OK = NO;
	}
	
	if (!OK)
	{
		if (_vertexShader)  glDeleteObjectARB(_vertexShader);
		if (_fragmentShader)  glDeleteObjectARB(_fragmentShader);
		if (_program)  glDeleteObjectARB(_program);
		
		[self release];
		self = nil;
	}
	return self;
}


- (void)dealloc
{
	if (_program != NULL)  glDeleteObjectARB(_program);
	if (_vertexShader != NULL)  glDeleteObjectARB(_vertexShader);
	if (_fragmentShader != NULL)  glDeleteObjectARB(_fragmentShader);
	
	[super dealloc];
}


- (void)apply
{
	glUseProgramObjectARB(_program);
}


- (GLhandleARB)program
{
	return _program;
}

@end


static NSString *GetGLSLInfoLog(GLhandleARB shaderObject)
{
	GLint					length;
	GLcharARB				*log = nil;
	NSString				*result = nil;
	
	if (shaderObject == NULL)  return nil;
	
	glGetObjectParameterivARB(shaderObject, GL_OBJECT_INFO_LOG_LENGTH_ARB, &length);
	log = malloc(length);
	if (log == NULL)
	{
		length = 1024;
		log = malloc(length);
		if (log == NULL)  return @"<out of memory>";
	}
	glGetInfoLogARB(shaderObject, length, NULL, log);
	
	result = [NSString stringWithUTF8String:log];
	if (result == nil)  result = [[[NSString alloc] initWithBytes:log length:length - 1 encoding:NSISOLatin1StringEncoding] autorelease];
	return result;
}
