/*
	DialControlInspector.m
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

#import "DialControlInspector.h"
#import "SCDial.h"


@implementation DialControlInspector

- (id)init
{
	self = [super init];
	if (nil != self)
	{
		[NSBundle loadNibNamed:@"DialControlInspector" owner:self];
	}
	return self;
}


- (void)ok:(id)sender
{
	SCDial				*control;
	SCDialCell			*cell;
	
	control = [self object];
	if ([control isKindOfClass:[SCDial class]])
	{
		cell = [(NSControl *)control cell];
	}
	else
	{
		cell = (SCDialCell *)control;
		control = nil;
	}
	
	if (![cell isKindOfClass:[SCDialCell class]])
	{
		return;
	}
	
	if (minField == sender) [cell setMinValue:[sender doubleValue]];
	else if (maxField == sender) [cell setMaxValue:[sender doubleValue]];
	else if (valField == sender) [cell setDoubleValue:[sender doubleValue]];
	else if (tagField == sender) [cell setTag:[sender intValue]];
	
	else if (rzCheckBox == sender)
	{
		// Ensure legal values for rzMin and rzMax, to avoid confusing users
		double			rzMin, rzMax, min, max;
		
		rzMin = [cell minRedZoneValue];
		rzMax = [cell maxRedZoneValue];
		if (rzMin <= rzMax)
		{
			min = [cell minValue];
			max = [cell maxValue];
			[cell setMinRedZoneValue:min + (max - min) * 0.8];
			[cell setMaxRedZoneValue:max];
		}
		[cell setShowRedZone:[sender intValue]];
	}
	else if (rzMinField == sender) [cell setMinRedZoneValue:[sender doubleValue]];
	else if (rzMaxField == sender) [cell setMaxRedZoneValue:[sender doubleValue]];
	
	else if (ticksField == sender) [cell setNumberOfTickMarks:[sender intValue]];
	else if (secTicksField == sender) [cell setNumberOfSecondaryTickMarks:[sender intValue]];
	
	else if (smoothCheckBox == sender) [cell setShowSmoothedValue:[sender intValue]];
	else if (falloffField == sender) [cell setSmoothRate:[sender doubleValue]];
	
	[self revert:self];
	
	if (nil != control) [control setNeedsDisplay];
}


- (void)revert:(id)sender
{
	SCDial				*control;
	SCDialCell			*cell;
	
	control = [self object];
	if ([control isKindOfClass:[SCDial class]])
	{
		cell = [(NSControl *)control cell];
	}
	else
	{
		cell = (SCDialCell *)control;
		control = nil;
	}
	
	if (![cell isKindOfClass:[SCDialCell class]])
	{
		return;
	}
	
	[minField setDoubleValue:[cell minValue]];
	[maxField setDoubleValue:[cell maxValue]];
	[valField setDoubleValue:[cell doubleValue]];
	[tagField setIntValue:[cell tag]];
	
	[rzCheckBox setIntValue:[cell showRedZone]];
	[rzMinField setDoubleValue:[cell minRedZoneValue]];
	[rzMaxField setDoubleValue:[cell maxRedZoneValue]];
	
	[ticksField setIntValue:[cell numberOfTickMarks]];
	[secTicksField setIntValue:[cell numberOfSecondaryTickMarks]];
	
	[smoothCheckBox setIntValue:[cell showSmoothedValue]];
	[falloffField setDoubleValue:[cell smoothRate]];
}


- (BOOL)isResizable
{
	return YES;
}


- (NSView *)initialFirstResponder
{
	return minField;
}

@end
