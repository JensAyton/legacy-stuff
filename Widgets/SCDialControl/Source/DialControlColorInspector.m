/*
	DialControlColorInspector.m
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

#import "DialControlColorInspector.h"
#import "SCDial.h"


@implementation DialControlColorInspector

- (id)init
{
	self = [super init];
	if (nil != self)
	{
		[NSBundle loadNibNamed:@"DialControlColorInspector" owner:self];
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
	
	if (dialColorWell == sender) [cell setDialColor:[sender color]];
	else if (faceColorWell == sender) [cell setFaceColor:[sender color]];
	else if (frameColorWell == sender) [cell setFrameColor:[sender color]];
	else if (knobColorWell == sender) [cell setKnobColor:[sender color]];
	else if (rzColorWell == sender) [cell setRedZoneColor:[sender color]];
	else if (smoothColorWell == sender) [cell setSmoothColor:[sender color]];
	else if (tickColorWell == sender) [cell setTickColor:[sender color]];
	
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
	
    [dialColorWell setColor:[cell dialColor]];
    [faceColorWell setColor:[cell faceColor]];
    [frameColorWell setColor:[cell frameColor]];
    [knobColorWell setColor:[cell knobColor]];
    [rzColorWell setColor:[cell redZoneColor]];
    [smoothColorWell setColor:[cell smoothColor]];
    [tickColorWell setColor:[cell tickColor]];
}


- (BOOL)isResizable
{
	return YES;
}


- (NSView *)initialFirstResponder
{
	return faceColorWell;
}

@end
