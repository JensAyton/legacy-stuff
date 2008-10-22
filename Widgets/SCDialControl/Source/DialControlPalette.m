/*
	DialControlPalette.m
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

#import "DialControlPalette.h"
#import "DialControlInspector.h"


@implementation DialControlPalette

- (void)finishInstantiate
{
	// Register dial colours inspector
	NSBundle				*bundle;
	NSString				*title;
	IBInspectorManager		*mgr;
	
	mgr = [IBInspectorManager sharedInspectorManager];
	bundle = [NSBundle bundleForClass:[self class]];
	title = [bundle localizedStringForKey:@"Colors" value:nil table:@"DialControlPalette"];
	
	[mgr addInspectorModeWithIdentifier: @"net.is-a-geek.ahruman.dialcontrol.colorinspector"
		forObject:[SCDial class] localizedLabel:title inspectorClassName:@"DialControlColorInspector"
		ordering:1000.0f];
	
	// Set up “custom” to show an alternative use
	[custom setNumberOfTickMarks:11];
	[custom setNumberOfSecondaryTickMarks:4];
	[custom setDoubleValue:0.25];
	[custom setMinRedZoneValue:0.8];
	[custom setMaxRedZoneValue:1.0];
	[custom setShowRedZone:YES];
}

@end
