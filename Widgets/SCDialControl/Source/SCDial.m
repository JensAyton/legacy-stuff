/*
	SCDial.m
	
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

#import "SCDial.h"


#define kMinSize			(32.0f) // Minimum allowable size


@interface SCDialCell(Private)

- (void)invalidateAll;

@end


@implementation SCDial

+ (void)initialize
{
    if (self == [SCDial class]) {		// Do it once
        [self setCellClass: [SCDialCell class]];
    }
}


+ (Class)cellClass
{
    return [SCDialCell class];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:nil name:nil object:self];
    [super dealloc];
}


- (double)minValue
{
	return [[self cell] minValue];
}


- (void)setMinValue:(double)inValue
{
	[[self cell] setMinValue:inValue];
}


- (double)maxValue
{
	return [[self cell] maxValue];
}


- (void)setMaxValue:(double)inValue
{
	[[self cell] setMaxValue:inValue];
}


- (void)setNumberOfTickMarks:(int)inCount
{
	[[self cell] setNumberOfTickMarks:inCount];
}


- (int)numberOfTickMarks
{
	return [[self cell] numberOfTickMarks];
}


- (void)setNumberOfSecondaryTickMarks:(int)inCount
{
	[[self cell] setNumberOfSecondaryTickMarks:inCount];
}


- (int)numberOfSecondaryTickMarks
{
	return [[self cell] numberOfSecondaryTickMarks];
}


- (double)minRedZoneValue
{
	return [[self cell] minRedZoneValue];
}


- (void)setMinRedZoneValue:(double)inValue
{
	[[self cell] setMinRedZoneValue:inValue];
}


- (double)maxRedZoneValue
{
	return [[self cell] maxRedZoneValue];
}


- (void)setMaxRedZoneValue:(double)inValue
{
	[[self cell] setMaxRedZoneValue:inValue];
}


- (BOOL)showRedZone
{
	return [[self cell] showRedZone];
}


- (void)setShowRedZone:(BOOL)inFlag
{
	[[self cell] setShowRedZone:inFlag];
}


- (NSColor *)faceColor
{
	return [[self cell] faceColor];
}


- (void)setFaceColor:(NSColor *)inColor
{
	[[self cell] setFaceColor:inColor];
}


- (IBAction)takeFaceColorFrom:sender
{
	[[self cell] takeFaceColorFrom:sender];
}


- (NSColor *)frameColor
{
	return [[self cell] frameColor];
}


- (void)setFrameColor:(NSColor *)inColor
{
	[[self cell] setFrameColor:inColor];
}


- (IBAction)takeFrameColorFrom:sender
{
	[[self cell] takeFrameColorFrom:sender];
}


- (NSColor *)dialColor
{
	return [[self cell] dialColor];
}


- (void)setDialColor:(NSColor *)inColor
{
	[[self cell] setDialColor:inColor];
}


- (IBAction)takeDialColorFrom:sender
{
	[[self cell] takeDialColorFrom:sender];
}


- (NSColor *)smoothColor
{
	return [[self cell] smoothColor];
}


- (void)setSmoothColor:(NSColor *)inColor
{
	[[self cell] setSmoothColor:inColor];
}


- (IBAction)takeSmoothColorFrom:sender
{
	[[self cell] takeSmoothColorFrom:sender];
}


- (NSColor *)knobColor
{
	return [[self cell] knobColor];
}


- (void)setKnobColor:(NSColor *)inColor
{
	[[self cell] setKnobColor:inColor];
}


- (IBAction)takeKnobColorFrom:sender
{
	[[self cell] takeKnobColorFrom:sender];
}


- (NSColor *)tickColor
{
	return [[self cell] tickColor];
}


- (void)setTickColor:(NSColor *)inColor
{
	[[self cell] setTickColor:inColor];
}


- (IBAction)takeTickColorFrom:sender
{
	[[self cell] takeTickColorFrom:sender];
}


- (NSColor *)redZoneColor
{
	return [[self cell] redZoneColor];
}


- (void)setRedZoneColor:(NSColor *)inColor
{
	[[self cell] setRedZoneColor:inColor];
}


- (IBAction)takeRedZoneColorFrom:sender
{
	[[self cell] takeRedZoneColorFrom:sender];
}


- (BOOL)showSmoothedValue
{
	return [[self cell] showSmoothedValue];
}


- (void)setShowSmoothedValue:(BOOL)inFlag
{
	[[self cell] setShowSmoothedValue:inFlag];
}


- (IBAction)takeShowSmoothFrom:sender
{
	[[self cell] takeShowSmoothFrom:sender];
}


- (double)smoothRate
{
	return [[self cell] smoothRate];
}


- (void)setSmoothRate:(double)inSmoothRate
{
	[[self cell] setSmoothRate:inSmoothRate];
}


- (IBAction)takeSmoothRateFrom:sender
{
	[[self cell] takeSmoothRateFrom:sender];
}


- (double)smoothValue
{
	return [[self cell] smoothValue];
}


- (void)setSmoothValue:(double)inSmoothValue
{
	[[self cell] setSmoothValue:inSmoothValue];
}


- (IBAction)takeSmoothValueFrom:sender
{
	[[self cell] takeSmoothValueFrom:sender];
}


- (void)resetSmoothing
{
	[[self cell] resetSmoothing];
}


- (void)updateCell:(NSCell *)aCell
{
	[self setNeedsDisplay];
}

@end


#pragma mark -

@implementation SCDialCell

- (id)init
{
	self = [super init];
	
	if (nil != self)
	{
		_min = 0.0;
		_max = 1.0;
		_showSmooth = NO;
		_smoothRate = 0.1;
		_ticks = 2;
		[self setFaceColor:[NSColor whiteColor]];
		[self setFrameColor:[NSColor blackColor]];
		[self setDialColor:[NSColor blackColor]];
		[self setSmoothColor:[NSColor colorWithCalibratedRed:0.5 green:0 blue:0 alpha:0.75]];
		[self setKnobColor:[NSColor blackColor]];
		[self setTickColor:[NSColor darkGrayColor]];
		[self setRedZoneColor:[[NSColor redColor] colorWithAlphaComponent:0.75]];
	}
	return self;
}


- (id)initWithCoder:(NSCoder *)inCoder
{
    self = [super initWithCoder:inCoder];
    if ([inCoder allowsKeyedCoding])
	{
		_val = [inCoder decodeDoubleForKey:@"value"];
		_min = [inCoder decodeDoubleForKey:@"min"];
		_max = [inCoder decodeDoubleForKey:@"max"];
		_showSmooth = [inCoder decodeBoolForKey:@"show smoothed"];
		_smoothRate = [inCoder decodeDoubleForKey:@"smooth rate"];
		_ticks = [inCoder decodeIntForKey:@"ticks"];
		_secondaryTicks = [inCoder decodeIntForKey:@"secondary ticks"];
		_faceColor = [[inCoder decodeObjectForKey:@"face color"] retain];
		_frameColor = [[inCoder decodeObjectForKey:@"frame color"] retain];
		_dialColor = [[inCoder decodeObjectForKey:@"dial color"] retain];
		_smoothColor = [[inCoder decodeObjectForKey:@"smooth color"] retain];
		_knobColor = [[inCoder decodeObjectForKey:@"knob color"] retain];
		_tickColor = [[inCoder decodeObjectForKey:@"tick color"] retain];
		_rzColor = [[inCoder decodeObjectForKey:@"rz color"] retain];
		_rzMin = [inCoder decodeDoubleForKey:@"rz min"];
		_rzMax = [inCoder decodeDoubleForKey:@"rz max"];
		_showRZ = [inCoder decodeBoolForKey:@"show rz"];
    }
	else
	{
		_val = [[inCoder decodeObject] doubleValue];
		_min = [[inCoder decodeObject] doubleValue];
		_max = [[inCoder decodeObject] doubleValue];
		_showSmooth = [[inCoder decodeObject] boolValue];
		_smoothRate = [[inCoder decodeObject] doubleValue];
		_ticks = [[inCoder decodeObject] intValue];
		_secondaryTicks = [[inCoder decodeObject] intValue];
		_faceColor = [[inCoder decodeObject] retain];
		_frameColor = [[inCoder decodeObject] retain];
		_dialColor = [[inCoder decodeObject] retain];
		_smoothColor = [[inCoder decodeObject] retain];
		_knobColor = [[inCoder decodeObject] retain];
		_tickColor = [[inCoder decodeObject] retain];
		_rzColor = [[inCoder decodeObject] retain];
		_rzMin = [[inCoder decodeObject] doubleValue];
		_rzMax = [[inCoder decodeObject] doubleValue];
		_showRZ = [[inCoder decodeObject] boolValue];
    }
	
	if (_ticks < 0) _ticks = 0;
	if (_secondaryTicks < 0) _secondaryTicks = 0;
	
    return self;
}


- (void)encodeWithCoder:(NSCoder *)inCoder
{
    [super encodeWithCoder:inCoder];
    if ([inCoder allowsKeyedCoding])
	{
		[inCoder encodeDouble:_val forKey:@"value"];
		[inCoder encodeDouble:_min forKey:@"min"];
		[inCoder encodeDouble:_max forKey:@"max"];
		[inCoder encodeBool:_showSmooth forKey:@"show smoothed"];
		[inCoder encodeDouble:_smoothRate forKey:@"smooth rate"];
		[inCoder encodeInt:_ticks forKey:@"ticks"];
		[inCoder encodeInt:_secondaryTicks forKey:@"secondary ticks"];
		[inCoder encodeObject:_faceColor forKey:@"face color"];
		[inCoder encodeObject:_frameColor forKey:@"frame color"];
		[inCoder encodeObject:_dialColor forKey:@"dial color"];
		[inCoder encodeObject:_smoothColor forKey:@"smooth color"];
		[inCoder encodeObject:_knobColor forKey:@"knob color"];
		[inCoder encodeObject:_tickColor forKey:@"tick color"];
		[inCoder encodeObject:_rzColor forKey:@"rz color"];
		[inCoder encodeDouble:_rzMin forKey:@"rz min"];
		[inCoder encodeDouble:_rzMax forKey:@"rz max"];
		[inCoder encodeBool:_showRZ forKey:@"show rz"];
    }
	else
	{
		[inCoder encodeObject:[NSNumber numberWithDouble:_val]];
		[inCoder encodeObject:[NSNumber numberWithDouble:_min]];
		[inCoder encodeObject:[NSNumber numberWithDouble:_max]];
		[inCoder encodeObject:[NSNumber numberWithBool:_showSmooth]];
		[inCoder encodeObject:[NSNumber numberWithDouble:_smoothRate]];
		[inCoder encodeObject:[NSNumber numberWithInt:_ticks]];
		[inCoder encodeObject:[NSNumber numberWithInt:_secondaryTicks]];
		[inCoder encodeObject:_faceColor];
		[inCoder encodeObject:_frameColor];
		[inCoder encodeObject:_dialColor];
		[inCoder encodeObject:_smoothColor];
		[inCoder encodeObject:_knobColor];
		[inCoder encodeObject:_tickColor];
		[inCoder encodeObject:_rzColor];
		[inCoder encodeObject:[NSNumber numberWithDouble:_rzMin]];
		[inCoder encodeObject:[NSNumber numberWithDouble:_rzMax]];
		[inCoder encodeObject:[NSNumber numberWithBool:_showRZ]];
    }
}


- (id)copyWithZone:(NSZone *)inZone
{
	SCDialCell			*copy;
	
	copy = [[SCDialCell allocWithZone:inZone] init];
	if (nil != copy)
	{
		copy->_min = _min;
		copy->_max = _max;
		copy->_val = _val;
		copy->_smoothRate = _smoothRate;
		copy->_ticks = _ticks;
		copy->_secondaryTicks = _secondaryTicks;
		copy->_faceColor = [_faceColor copyWithZone:inZone];
		copy->_frameColor = [_frameColor copyWithZone:inZone];
		copy->_dialColor = [_dialColor copyWithZone:inZone];
		copy->_smoothColor = [_smoothColor copyWithZone:inZone];
		copy->_knobColor = [_knobColor copyWithZone:inZone];
		copy->_tickColor = [_tickColor copyWithZone:inZone];
		copy->_rzColor = [_rzColor copyWithZone:inZone];
		copy->_rzMin = _rzMin;
		copy->_rzMax = _rzMax;
		copy->_showRZ = _showRZ;
		if (_showSmooth) [copy setShowSmoothedValue:YES];
	}
	
	return copy;
}

- (void)dealloc
{
	[_faceColor release];
	[_frameColor release];
	[_dialColor release];
	[_smoothColor release];
	[_knobColor release];
	[_tickColor release];
	[_rzColor release];
	
    [super dealloc];
}


- (void)sendActionToTarget
{
	id					target;
	SEL					action;
	
	target = [self target];
	action = [self action];
	
    if (nil != target && nil != action)
	{
        [(NSControl *)[self controlView] sendAction:action to:target];
    }
}


- (double)minValue
{
	return _min;
}


- (void)setMinValue:(double)inValue
{
	_min = inValue;
	[self invalidateAll];
}


- (double)maxValue
{
	return _max;
}


- (void)setMaxValue:(double)inValue
{
	_max = inValue;
	[self invalidateAll];
}


- (double)doubleValue
{
	return _val;
}


- (void)setDoubleValue:(double)inValue
{
	_oldVal = _val;
	_val = inValue;
	if (_showSmooth)
	{
		_oldSmooth = _smooth;
		_smooth = _smooth * (1 - _smoothRate) + _val * _smoothRate;
		_smoothScale = _smoothScale * (1 - _smoothRate) + _smoothRate;
	}
	if (_val != inValue || (_showSmooth && _oldSmooth != _smooth)) [self invalidateAll];
}


- (float)floatValue
{
	return _val;
}


- (void)setFloatValue:(float)inValue
{
	[self setDoubleValue:inValue];
}


- (int)intValue
{
	return _val;
}


- (void)setIntValue:(int)inValue
{
	[self setDoubleValue:inValue];
}


- (void)setObjectValue:(id <NSCopying>)inValue
{
	id value = (id)inValue;
	
	if ([value respondsToSelector:@selector(doubleValue)])
	{
		[self setDoubleValue:[value doubleValue]];
	}
	else if ([value respondsToSelector:@selector(floatValue)])
	{
		[self setFloatValue:[value floatValue]];
	}
	else if ([value respondsToSelector:@selector(intValue)])
	{
		[self setIntValue:[value intValue]];
	}
	else
	{
		if ([value respondsToSelector:@selector(stringValue)])
		{
			id string = [value stringValue];
			if ([string respondsToSelector:@selector(doubleValue)])
			{
				[self setDoubleValue:[string doubleValue]];
				return;
			}
		}
		
		[NSException raise: NSInvalidArgumentException format: @"%s: Invalid object %@", __FUNCTION__, value];
	}
}


- (id)objectValue
{
	return [NSNumber numberWithDouble:_val];
}


- (void)setStringValue:(NSString *)inString
{
	[self setDoubleValue:[inString doubleValue]];
}


- (NSString *)stringValue
{
	return [NSString stringWithFormat:@"%g", [self doubleValue]];
}


- (void)setNumberOfTickMarks:(int)inCount
{
	if (inCount < 1000 && 0 <= inCount) _ticks = inCount;
}


- (int)numberOfTickMarks
{
	return _ticks;
}


- (void)setNumberOfSecondaryTickMarks:(int)inCount
{
	if (inCount < 100 && 0 <= inCount) _secondaryTicks = inCount;
}


- (int)numberOfSecondaryTickMarks
{
	return _secondaryTicks;
}


- (double)minRedZoneValue
{
	return _rzMin;
}


- (void)setMinRedZoneValue:(double)inValue
{
	if (inValue < _min) inValue = _min;
	_rzMin = inValue;
	if (_rzMax <= _rzMin) _showRZ = NO;
}


- (double)maxRedZoneValue
{
	return _rzMax;
}


- (void)setMaxRedZoneValue:(double)inValue
{
	if (_max < inValue) inValue = _max;
	_rzMax = inValue;
	if (_rzMax <= _rzMin) _showRZ = NO;
}


- (BOOL)showRedZone
{
	return _showRZ;
}


- (void)setShowRedZone:(BOOL)inFlag
{
	if (inFlag)
	{
		if (!_showRZ && _rzMin < _rzMax)
		{
			_showRZ = YES;
		}
	}
	else
	{
		_showRZ = NO;
	}
}


- (NSColor *)faceColor
{
	return [[_faceColor copy] autorelease];
}


- (void)setFaceColor:(NSColor *)inColor
{
	if (_faceColor != inColor)
	{
		[_faceColor release];
		_faceColor = [inColor copy];
	}
}


- (IBAction)takeFaceColorFrom:sender
{
	id				object = nil;
	
	if ([sender respondsToSelector:@selector(color)]) object = [sender color];
	else if ([sender respondsToSelector:@selector(objectValue)]) [sender objectValue];
	if ([object isKindOfClass:[NSColor class]]) [self setFaceColor:object];
}


- (NSColor *)frameColor
{
	return [[_frameColor copy] autorelease];
}


- (void)setFrameColor:(NSColor *)inColor
{
	if (_frameColor != inColor)
	{
		[_frameColor release];
		_frameColor = [inColor copy];
	}
}


- (IBAction)takeFrameColorFrom:sender
{
	id				object = nil;
	
	if ([sender respondsToSelector:@selector(color)]) object = [sender color];
	else if ([sender respondsToSelector:@selector(objectValue)]) [sender objectValue];
	if ([object isKindOfClass:[NSColor class]]) [self setFrameColor:object];
}


- (NSColor *)dialColor
{
	return [[_dialColor copy] autorelease];
}


- (void)setDialColor:(NSColor *)inColor
{
	if (_dialColor != inColor)
	{
		[_dialColor release];
		_dialColor = [inColor copy];
	}
}


- (IBAction)takeDialColorFrom:sender
{
	id				object = nil;
	
	if ([sender respondsToSelector:@selector(color)]) object = [sender color];
	else if ([sender respondsToSelector:@selector(objectValue)]) [sender objectValue];
	if ([object isKindOfClass:[NSColor class]]) [self setDialColor:object];
}


- (NSColor *)smoothColor
{
	return [[_smoothColor copy] autorelease];
}


- (void)setSmoothColor:(NSColor *)inColor
{
	if (_smoothColor != inColor)
	{
		[_smoothColor release];
		_smoothColor = [inColor copy];
	}
}


- (IBAction)takeSmoothColorFrom:sender
{
	id				object = nil;
	
	if ([sender respondsToSelector:@selector(color)]) object = [sender color];
	else if ([sender respondsToSelector:@selector(objectValue)]) [sender objectValue];
	if ([object isKindOfClass:[NSColor class]]) [self setSmoothColor:object];
}


- (NSColor *)knobColor
{
	return [[_knobColor copy] autorelease];
}


- (void)setKnobColor:(NSColor *)inColor
{
	if (_knobColor != inColor)
	{
		[_knobColor release];
		_knobColor = [inColor copy];
	}
}


- (IBAction)takeKnobColorFrom:sender
{
	id				object = nil;
	
	if ([sender respondsToSelector:@selector(color)]) object = [sender color];
	else if ([sender respondsToSelector:@selector(objectValue)]) [sender objectValue];
	if ([object isKindOfClass:[NSColor class]]) [self setKnobColor:object];
}


- (NSColor *)tickColor
{
	return [[_tickColor copy] autorelease];
}


- (void)setTickColor:(NSColor *)inColor
{
	if (_tickColor != inColor)
	{
		[_tickColor release];
		_tickColor = [inColor copy];
	}
}


- (IBAction)takeTickColorFrom:sender
{
	id				object = nil;
	
	if ([sender respondsToSelector:@selector(color)]) object = [sender color];
	else if ([sender respondsToSelector:@selector(objectValue)]) [sender objectValue];
	if ([object isKindOfClass:[NSColor class]]) [self setTickColor:object];
}


- (NSColor *)redZoneColor
{
	return [[_rzColor copy] autorelease];
}


- (void)setRedZoneColor:(NSColor *)inColor
{
	if (_rzColor != inColor)
	{
		[_rzColor release];
		_rzColor = [inColor copy];
	}
}


- (IBAction)takeRedZoneColorFrom:sender
{
	id				object = nil;
	
	if ([sender respondsToSelector:@selector(color)]) object = [sender color];
	else if ([sender respondsToSelector:@selector(objectValue)]) object = [sender objectValue];
	if ([object isKindOfClass:[NSColor class]]) [self setRedZoneColor:object];
}


- (BOOL)showSmoothedValue
{
	return _showSmooth;
}


- (void)setShowSmoothedValue:(BOOL)inFlag
{
	if (inFlag)
	{
		if (!_showSmooth)
		{
			_showSmooth = YES;
			_smoothScale = _smoothRate;
			_smooth = _val * _smoothRate;
		}
	}
	else
	{
		_showSmooth = NO;
	}
}


- (IBAction)takeShowSmoothFrom:sender
{
	if ([sender respondsToSelector:@selector(boolValue)])
	{
		[self setShowSmoothedValue:[sender boolValue]];
	}
	else
	{
		[self setShowSmoothedValue:!![sender intValue]];
	}
}


- (double)smoothRate
{
	return _smoothRate;
}


- (void)setSmoothRate:(double)inSmoothRate
{
	if (inSmoothRate < 0.0) _smoothRate = 0.0;
	else if (1.0 < inSmoothRate) _smoothRate = 1.0;
	else _smoothRate = inSmoothRate;
}


- (IBAction)takeSmoothRateFrom:sender
{
	[self setSmoothRate:[sender doubleValue]];
}


- (double)smoothValue
{
	if (_showSmooth) return _smooth / _smoothScale;
	else return _val;
}


- (void)setSmoothValue:(double)inSmoothValue
{
	if (_showSmooth)
	{
		_smooth = inSmoothValue * _smoothRate;
		_smoothScale = _smoothRate;
	}
}


- (IBAction)takeSmoothValueFrom:sender
{
	[self setSmoothValue:[sender doubleValue]];
}


- (void)resetSmoothing
{
	if (_showSmooth)
	{
		_smooth = _val * _smoothRate;
		_smoothScale = _smoothRate;
	}
}


- (void)invalidateAll
{
	[(NSControl *)[self controlView] updateCell: self];
}


- (NSSize)cellSizeForBounds:(NSRect)inRect
{
	NSSize			result;
	
	result = inRect.size;
	if (result.width < kMinSize) result.width = kMinSize;
	if (result.height < kMinSize) result.height = kMinSize;
	
	return result;
}


- (void)drawWithFrame:(NSRect)inBounds inView:(NSView *)inView
{
	NSGraphicsContext   *ctx;
	NSRect				frameRect;
	NSBezierPath		*path, *framePath;
	float				size;
	float				frameThickness, dialThickness, dialRadius, knobRadius,
						tickLength, tickThickness, secTickLength, secTickThickness,
						smoothThickness, rzRadius, rzThickness, smoothLength,
						smoothHalfWidth;
	float				dialScale, dialAngle;
	float				s, c;
	NSPoint				middle = {0, 0}, point;
	NSAffineTransform   *toMiddle, *transform;
	int					iter, secIter;
	double				smooth;
	
	ctx = [NSGraphicsContext currentContext];
	[ctx saveGraphicsState];
	
	if (inBounds.size.width < inBounds.size.height)
	{
		inBounds.origin.y += (inBounds.size.height - inBounds.size.width) / 2.0f;
		size = inBounds.size.height = inBounds.size.width;
	}
	else
	{
		inBounds.origin.x += (inBounds.size.width - inBounds.size.height) / 2.0f;
		size = inBounds.size.width = inBounds.size.height;
	}
	
	if (size < kMinSize)
	{
		inBounds.origin.x -= (kMinSize - size) / 2.0f;
		inBounds.origin.y -= (kMinSize - size) / 2.0f;
		size = inBounds.size.width = inBounds.size.height = kMinSize;
	}
	
	frameThickness = 0.02f * size;
	dialThickness = 0.02f * size;
	smoothThickness = 0.015f * size;
	dialRadius = 0.4f * size;
	knobRadius = 0.04f * size;
	tickLength = 0.08f * size;
	secTickLength = 0.7f * tickLength;
	tickThickness = 0.016f * size;
	secTickThickness = 0.6f * tickThickness;
	rzThickness = secTickLength * 0.8;
	rzRadius = (size - rzThickness * 2) / 2;
	smoothLength = 0.08f * size;
	smoothHalfWidth = 0.03f * size;
	
	toMiddle = [[NSAffineTransform alloc] init];
	[toMiddle translateXBy:inBounds.origin.x + inBounds.size.width / 2
					   yBy:inBounds.origin.y + inBounds.size.height / 2];
	if ([inView isFlipped])
	{
		[toMiddle scaleXBy:1 yBy:-1];
	}
	[toMiddle concat];
	
	frameRect.size.width = inBounds.size.width - 2 - 2 * frameThickness;
	frameRect.size.height = inBounds.size.height - 2 - 2 * frameThickness;
	frameRect.origin.x = -frameRect.size.width * 0.5;
	frameRect.origin.y = -frameRect.size.height * 0.5;
	
	framePath = [NSBezierPath bezierPathWithOvalInRect:frameRect];
	[framePath setLineWidth: frameThickness];
	[_faceColor set];
	[framePath fill];
	
	if (_showRZ)
	{
		float				start, end;
		path = [[NSBezierPath alloc] init];
		
		dialScale = (_rzMin - _min) / (_max - _min);
		start = 225.0 - dialScale * 270.0f;
		
		dialScale = (_rzMax - _min) / (_max - _min);
		end = 225.0 - dialScale * 270.0f;
		
		[_rzColor set];
		[path setLineWidth: rzThickness];
		[path appendBezierPathWithArcWithCenter:middle radius:rzRadius - 1
				startAngle:start endAngle:end clockwise:YES];
		[path stroke];
	}
	
	if (0 != _ticks)
	{
		[_tickColor set];
		
		// Build path representing one tick
		path = [NSBezierPath bezierPath];
		point.x = 0;
		point.y = 0.5 * size - 1 - frameThickness;
		[path moveToPoint:point];
		point.y -= tickLength;
		[path lineToPoint:point];
		[path setLineWidth: tickThickness];
		
		if (1 == _ticks)
		{
			// Special case: no ticks at start and end
			[path stroke];
		}
		else
		{
			// Distribute ticks from start to end
			float angle = 270.0f / (float)(_ticks - 1);
			
			transform = [[NSAffineTransform alloc] init];
			[transform rotateByDegrees:-135.0f];
			[path transformUsingAffineTransform:transform];
			
			[transform rotateByDegrees:135.0f + angle];
			
			for (iter = 0; iter != _ticks; ++iter)
			{
				[path stroke];
				[path transformUsingAffineTransform:transform];
			}
			[transform release];
			
			if (0 != _secondaryTicks)
			{
				angle /= (float)(_secondaryTicks + 1);
				
				path = [[NSBezierPath alloc] init];
				point.x = 0;
				point.y = 0.5 * size - 1 - frameThickness;
				[path moveToPoint:point];
				point.y -= secTickLength;
				[path lineToPoint:point];
				[path setLineWidth: secTickThickness];
			
				transform = [[NSAffineTransform alloc] init];
				[transform rotateByDegrees:-135.0f];
				[path transformUsingAffineTransform:transform];
				
				[transform rotateByDegrees:135.0f + angle];
				
				for (iter = 0; iter != _ticks - 1; ++iter)
				{
					[path transformUsingAffineTransform:transform];
					
					for (secIter = 0; secIter != _secondaryTicks; ++secIter)
					{
						[path stroke];
						[path transformUsingAffineTransform:transform];
					}
				}
				[path release];
				[transform release];
			}
		}
	}
	
	if (_showSmooth)
	{
		smooth = _smooth;
		if (smooth < _min) smooth = _min;
		if (_max < smooth) smooth = _max;
		dialScale = smooth / _smoothScale;
		dialScale = (dialScale - _min) / (_max - _min);
		dialAngle = dialScale * 270.0f;
		
		transform = [[NSAffineTransform alloc] init];
		[transform translateXBy:middle.x yBy:middle.y];
		[transform rotateByDegrees:135.0f - dialAngle];
		
		path = [[NSBezierPath alloc] init];
		point.x = 0;
		point.y = 0.5 * size - frameThickness - smoothLength - 2;
		[path moveToPoint:point];
		point.x = smoothHalfWidth;
		point.y = 0.5 * size - frameThickness - 1;
		[path lineToPoint:point];
		point.x = -smoothHalfWidth;
		[path lineToPoint:point];
		[path closePath];
		
		[_smoothColor set];
		[path transformUsingAffineTransform:transform];
		[path fill];
		[path release];
		[transform release];
	}
	
	if (_val < _min) dialScale = _min;
	else if (_max < _val) dialScale = _max;
	else dialScale = _val;
	
	dialScale = (dialScale - _min) / (_max - _min);
	dialAngle = 45.0f + dialScale * 270.0f;
	dialAngle = dialAngle * 3.1415f / 180.0f;
	
	s = sin(dialAngle);
	c = cos(dialAngle);
	
	path = [[NSBezierPath alloc] init];
	[path moveToPoint:middle];
	point.x = middle.x - s * dialRadius;
	point.y = middle.y - c * dialRadius;
	[path lineToPoint:point];
	[path setLineWidth: dialThickness];
	[path setLineCapStyle:NSRoundLineCapStyle];
	
	[_dialColor set];
	[path stroke];
	[path release];
	
	[_knobColor set];
	frameRect.origin.x = middle.x - knobRadius;
	frameRect.origin.y = middle.y - knobRadius;
	frameRect.size.width = frameRect.size.height = knobRadius * 2;
	[[NSBezierPath bezierPathWithOvalInRect:frameRect] fill];
	
	[_frameColor set];
	[framePath stroke];
	
	[ctx restoreGraphicsState];
}

@end
