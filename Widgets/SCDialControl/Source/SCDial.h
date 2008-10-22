/*
	SCDial.h
	
	Implements a control which displays a value on a circular dial, optionally
	with tick marks. Can also display a running average of recent values.
	
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

#import <Cocoa/Cocoa.h>


@interface SCDial: NSControl

- (double)minValue;
- (void)setMinValue:(double)inValue;
- (double)maxValue;
- (void)setMaxValue:(double)inValue;

- (void)setNumberOfTickMarks:(int)inCount;
- (int)numberOfTickMarks;					// Default: 2

// Secondary tick marks are displayed between primary tick marks, and are smaller.
- (void)setNumberOfSecondaryTickMarks:(int)inCount;
- (int)numberOfSecondaryTickMarks;			// Default: 0

/*
	RED ZONE
	
	A range which is hilited, by default in red. Disabled by default.
*/
- (double)minRedZoneValue;
- (void)setMinRedZoneValue:(double)inValue;
- (double)maxRedZoneValue;
- (void)setMaxRedZoneValue:(double)inValue;
- (BOOL)showRedZone;
- (void)setShowRedZone:(BOOL)inFlag;

/*
	COLOURS
	
	The dial control uses seven configurable colours to draw.
		Face colour		The control’s background colour. Default: white.
		Frame colour	Colour used for outline of control. Default: black.
		Dial colour		Colour used for main dial. Default: black.
		Smooth colour   Colour used for smoothed value indicator. Default: dark red, 75% alpha.
		Knob colour		Colour used for central circle. Default: black.
		Tick colour		Colour used for tick marks and face text. Default: dark grey.
		Red zone colour Colour used to idicate red zone. Default: red, 75% alpha.
	
	Alpha is fully supported, but not reccomended for the knob and frame colours.
*/

- (NSColor *)faceColor;
- (void)setFaceColor:(NSColor *)inColor;
- (IBAction)takeFaceColorFrom:sender;		// color or objectValue
- (NSColor *)frameColor;
- (void)setFrameColor:(NSColor *)inColor;
- (IBAction)takeFrameColorFrom:sender;		// color or objectValue
- (NSColor *)dialColor;
- (void)setDialColor:(NSColor *)inColor;
- (IBAction)takeDialColorFrom:sender;		// color or objectValue
- (NSColor *)smoothColor;
- (void)setSmoothColor:(NSColor *)inColor;
- (IBAction)takeSmoothColorFrom:sender;		// color or objectValue
- (NSColor *)knobColor;
- (void)setKnobColor:(NSColor *)inColor;
- (IBAction)takeKnobColorFrom:sender;		// color or objectValue
- (NSColor *)tickColor;
- (void)setTickColor:(NSColor *)inColor;
- (IBAction)takeTickColorFrom:sender;		// color or objectValue
- (NSColor *)redZoneColor;
- (void)setRedZoneColor:(NSColor *)inColor;
- (IBAction)takeRedZoneColorFrom:sender;	// color or objectValue

/*
	SMOOTHING
	
	The dial can show a "smoothed" value, which is an exponential-falloff average.
	The rate of fallof can be set with the smoothRate parameter, which ranges from
	0 (freeze at current value - allows you to set the smoothing indicator manually)
	to 1 (no smoothing). Default is 0.1. Values higher than 0.5 or so are pretty
	pointless. NOTE: the smoothing accumulator value will be reset to the current
	value when smoothing is turned on.
*/
- (BOOL)showSmoothedValue;
- (void)setShowSmoothedValue:(BOOL)inFlag;
- (IBAction)takeShowSmoothFrom:sender;		// boolValue or intValue
- (double)smoothRate;
- (void)setSmoothRate:(double)inSmoothRate;
- (IBAction)takeSmoothRateFrom:sender;		// doubleValue
- (double)smoothValue;						// returns value if smoothing is off
- (void)setSmoothValue:(double)inSmoothValue;
- (IBAction)takeSmoothValueFrom:sender;		// doubleValue
- (void)resetSmoothing;

@end


@interface SCDialCell: NSActionCell
{
@private
	double					_min, _max;
	double					_val, _oldVal,
							_smooth, _oldSmooth,
							_smoothScale, _smoothRate,
							_rzMin, _rzMax;
	NSColor					*_faceColor,
							*_frameColor,
							*_dialColor,
							*_smoothColor,
							*_knobColor,
							*_tickColor,
							*_rzColor;
	uint32_t				_ticks, _secondaryTicks;
	uint32_t				_showSmooth: 1,
							_showRZ: 1;
}

- (double)minValue;
- (void)setMinValue:(double)inValue;
- (double)maxValue;
- (void)setMaxValue:(double)inValue;

- (void)setNumberOfTickMarks:(int)inCount;
- (int)numberOfTickMarks;
- (void)setNumberOfSecondaryTickMarks:(int)inCount;
- (int)numberOfSecondaryTickMarks;

- (double)minRedZoneValue;
- (void)setMinRedZoneValue:(double)inValue;
- (double)maxRedZoneValue;
- (void)setMaxRedZoneValue:(double)inValue;
- (BOOL)showRedZone;
- (void)setShowRedZone:(BOOL)inFlag;

- (NSColor *)faceColor;
- (void)setFaceColor:(NSColor *)inColor;
- (IBAction)takeFaceColorFrom:sender;
- (NSColor *)frameColor;
- (void)setFrameColor:(NSColor *)inColor;
- (IBAction)takeFrameColorFrom:sender;
- (NSColor *)dialColor;
- (void)setDialColor:(NSColor *)inColor;
- (IBAction)takeDialColorFrom:sender;
- (NSColor *)smoothColor;
- (void)setSmoothColor:(NSColor *)inColor;
- (IBAction)takeSmoothColorFrom:sender;
- (NSColor *)knobColor;
- (void)setKnobColor:(NSColor *)inColor;
- (IBAction)takeKnobColorFrom:sender;
- (NSColor *)tickColor;
- (void)setTickColor:(NSColor *)inColor;
- (IBAction)takeTickColorFrom:sender;
- (NSColor *)redZoneColor;
- (void)setRedZoneColor:(NSColor *)inColor;
- (IBAction)takeRedZoneColorFrom:sender;

- (BOOL)showSmoothedValue;
- (void)setShowSmoothedValue:(BOOL)inFlag;
- (IBAction)takeShowSmoothFrom:sender;
- (double)smoothRate;
- (void)setSmoothRate:(double)inSmoothRate;
- (IBAction)takeSmoothRateFrom:sender;
- (double)smoothValue;
- (void)setSmoothValue:(double)inSmoothValue;
- (IBAction)takeSmoothValueFrom:sender;
- (void)resetSmoothing;

@end
