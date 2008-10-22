/*
	ExampleController.m
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

#import "ExampleController.h"
#import "ExampleOpenGLView.h"
#import "ExampleModel.h"


@implementation ExampleController

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		_model = [[ExampleModel alloc] init];
	}
	return self;
}


- (void)dealloc
{
	[window release];
	[_model release];
	[_timer invalidate];
	
	[super dealloc];
}


- (void)awakeFromNib
{
	NSRunLoop				*runLoop = nil;
	
	[colorWell setColor:[_model color]];
	[shininessSlider setDoubleValue:[_model shininess]];
	[glView setModel:_model];
	
	_startTime = [[NSDate date] retain];
	_timer = [NSTimer timerWithTimeInterval:0.05
									 target:self
								   selector:@selector(update)
								   userInfo:nil
									repeats:YES];
	runLoop = [NSRunLoop currentRunLoop];
	[runLoop addTimer:_timer forMode:NSDefaultRunLoopMode];
	[runLoop addTimer:_timer forMode:NSEventTrackingRunLoopMode];
}


- (IBAction)takeShininessFrom:(id)sender
{
	[_model setShininess:[sender doubleValue]];
}


- (IBAction)takeColorFrom:(id)sender
{
	[_model setColor:[sender color]];
}


- (void)update
{
	double timeOffset = [_startTime timeIntervalSinceNow];
	
	[glView setMainLightAngle:timeOffset * 30.0];
	[glView setSecondaryLightAngle:timeOffset * -11.0 - 60];
}

@end
