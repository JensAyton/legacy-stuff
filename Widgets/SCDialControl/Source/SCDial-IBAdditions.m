/*
	SCDial-IBAdditions.m
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

#import "SCDial-IBAdditions.h"


@implementation SCDial(IBAdditions)

- (NSString *)inspectorClassName
{
	return @"DialControlInspector";
}


- (NSSize)minimumFrameSizeFromKnobPosition:(IBKnobPosition)position
{
	NSSize result = { 32.0f, 32.0f };
	return result;
}


- (NSSize)maximumFrameSizeFromKnobPosition:(IBKnobPosition)knobPosition
{
	NSSize result = { HUGE_VALF, HUGE_VALF };
	return result;
}

- (BOOL)allowsAltDragging
{
	// We allow option-dragging a knob to create a matrix
	return YES;
}


- (BOOL)acceptsColor:(NSColor *)color atPoint:(NSPoint)point
{
	return YES;
}


- (void)depositColor:(NSColor *)inColor atPoint:(NSPoint)point
{
	[[self cell] depositColor:inColor];
}


- (BOOL)canEditSelf
{
	return NO;
}


- (BOOL)ibHasAlternateMinimumWidth
{
	return YES;
}


- (BOOL)ibHasAlternateMinimumHeight
{
	return YES;
}


- (float)ibAlternateMinimumWidth
{
	return 32.0f;
}


- (float)ibAlternateMinimumHeight
{
	return 32.0f;
}


- (BOOL)ibSupportsInsideOutSelection
{
	return NO;
}


- (BOOL)ibIsContainer
{
	return NO;
}


- (BOOL)ibSupportsLiveResize
{
	return YES;
}
   
- (int)ibNumberOfBaseLine
{
	return 1;
}


- (float)ibBaseLineAtIndex:(int)index
{
	return [self bounds].size.height / 2.0f;
}


- (BOOL)ibDrawFrameWhileResizing
{
	return YES;
}

@end


@implementation SCDialCell(IBAdditions)

- (NSString *)inspectorClassName
{
	return @"DialControlInspector";
}


- (NSSize)minimumSizeForCellSize:(NSSize)cellSize knobPosition:(IBKnobPosition)knobPosition
{
	NSSize result = { 32.0f, 32.0f };
	return result;
}


- (NSSize)maximumSizeForCellSize:(NSSize)cellSize knobPosition:(IBKnobPosition)knobPosition
{
	NSSize result = { HUGE_VALF, HUGE_VALF };
	return result;
}


- (BOOL)acceptsColor:(NSColor *)inColor
{
	return YES;
}


- (void)depositColor:(NSColor *)inColor
{
	[self setFaceColor:inColor];
}



- (BOOL)ibHasAlternateMinimumWidth
{
	return YES;
}


- (float)ibAlternateMinimumWidth
{
	return 32.0f;
}


- (BOOL)ibHasAlternateMinimumHeight
{
	return YES;
}


- (float)ibAlternateMinimumHeight
{
	return 32.0f;
}


- (BOOL)ibHasBaseLine
{
	return YES;
}


- (float)ibBaseLineForCellSize:(NSSize)cellSize
{
	return cellSize.height / 2.0f;
}


- (void)ibMatchPrototype:(NSCell*)inPrototype
{
	[super ibMatchPrototype:inPrototype];
	
	if ([inPrototype isKindOfClass:[SCDialCell class]])
	{
		SCDialCell			*proto = (SCDialCell *)inPrototype;
		
		_min = proto->_min;
		_max = proto->_max;
		_val = proto->_val;
		_smoothRate = proto->_smoothRate;
		_ticks = proto->_ticks;
		_secondaryTicks = proto->_secondaryTicks;
		[self setFaceColor:proto->_faceColor];
		[self setFrameColor:proto->_frameColor];
		[self setDialColor:proto->_dialColor];
		[self setSmoothColor:proto->_smoothColor];
		[self setKnobColor:proto->_knobColor];
		[self setTickColor:proto->_tickColor];
		[self setRedZoneColor:proto->_rzColor];
		_rzMin = proto->_rzMin;
		_rzMax = proto->_rzMax;
		_showRZ = proto->_showRZ;
		[self setShowSmoothedValue:proto->_showSmooth];
	}
}

@end