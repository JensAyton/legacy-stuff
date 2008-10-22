/*
	TestController.m
	Test rig for SCSliderWithTextField
	
	Copyright © 2007 Jens Ayton

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

#import "TestController.h"
#import "SCSliderWithTextField.h"


@implementation TestController

- (void)awakeFromNib
{
	// Create slider and put it in the window, at the right place.
	slider = [[SCSliderWithTextField alloc] initWithFrame:[placeholderView frame]];
	[slider setAutoresizingMask:[placeholderView autoresizingMask]];
	[[placeholderView superview] replaceSubview:placeholderView with:slider];
	
	// Configure slider.
	[slider setDelegate:self];
	[slider setLiveValueTextField:liveValueField];
	[slider setShowFieldWhenNotUpdating:NO];	// This is the default.
	[slider setContinuous:NO];					// This is the default.
	[slider setTarget:self];
	[slider setAction:@selector(sliderValueChanged:)];
	[slider setMaxValue:5.0];
	[slider setDoubleValue:2.5];
}


- (NSString *)slider:(SCSliderWithTextField *)inSlider displayValueForValue:(double)inValue
{
	return [self formattedValue:inValue];
}


- (IBAction)sliderValueChanged:(id)inSender
{
	[resultField setStringValue:[self formattedValue:[inSender doubleValue]]];
}


- (NSString *)formattedValue:(double)inValue
{
	// Scales from 0..5 to 0..100, to demonstrate flexibility in formatting.
	return [NSString stringWithFormat:@"%i%%", (int)((20.0 * inValue) + 0.5)];
}

@end
