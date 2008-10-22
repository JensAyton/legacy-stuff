/*
	DialControlTestApplication.m
	SCDial
	
	©2004 Jens Ayton

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software
	and associated documentation files (the “Software”), to deal in the Software without
	restriction, including without limitation the rights to use, copy, modify, merge, publish,
	distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
	Software is furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in all copies or
	substantial portions of the Software.

	THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
	BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
	DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#import "DialControlTestApplication.h"
#import <stdlib.h>


@implementation DialControlTestApplication

- (void)awakeFromNib
{
	srandomdev();
	[NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(idle:) userInfo:nil repeats:YES];
	
	[[NSColorPanel sharedColorPanel] setShowsAlpha:YES];
}


- (void)idle:junk
{
	double			offset;
	
	offset = ((double)random()) / (double)0x7FFFFFFF;
	offset = (offset - 0.5) * 0.1;
	
	_value += offset;
	if (_value < 0) _value = 0;
	if (1 < _value) _value = 1;
	
	[_dial setDoubleValue:_value];
}

@end
