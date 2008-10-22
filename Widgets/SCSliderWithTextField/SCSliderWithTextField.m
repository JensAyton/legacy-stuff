/*
	SCSliderWithTextField.m
	
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

/*	DESIGN NOTE
	To function, the SCSliderWithTextField needs to set the target/action to self (to get updates
	while dragging is in progress), and it must use continuous updating. In order to be
	self-contained, a separate target, action, and continuousness state are maintained for the
	client code; these are referred to as the “outward” target, action, etc. From a usage
	perspective, the normal target/action behaviour works as usual, including setting them up in IB
	and using the “Continuously send action while sliding” checkbox in the IB inspector.
	
	From a client code perspective, the only difference from a normal slider are the public
	properties - delegate, liveValueTextField and showFieldWhenNotUpdating. The second set of
	target/action and isContinuous values is only relevant to understanding the implementation.
	
	NOTE: currently, no specific support for full keyboard navigation exists. It is expected that
	changing the slider with the keyboard will work, but that the text field will not be shown. It
	should update correctly if showFieldWhenNotUpdating is set and the field is already visible.
*/

#import "SCSliderWithTextField.h"


/*	kSCSliderWithTextFieldShowInterval
	Time, in seconds, to show text field when value is updated by a method other than dragging (for
	example, using full keyboard navigation).
*/
#ifndef kSCSliderWithTextFieldShowInterval
#define kSCSliderWithTextFieldShowInterval		2.0
#endif


// Methods used internally, not intended for client use.
@interface SCSliderWithTextField (Private)

- (void)performSetUp;
- (void)selfDidUpdate:(id)inSender;
- (void)sendOutwardAction;
- (void)deferredHideTextField;
- (void)autoHideTimerDidFire:(NSTimer *)inTimer;

@end


@implementation SCSliderWithTextField

#pragma mark NSObject

- (void)dealloc
{
	[autoHideTimer invalidate];
	[autoHideTimer release];
	
	[super dealloc];
}


- (void)awakeFromNib
{
	[self performSetUp];
}


#pragma mark NSResponder

/*	-mouseDown:
	NSSlider tracking is handled entirely within -[NSSlider mouseDown:]. What we do here is show
	the text field for the duration of the event, and send the outward target/action when completed
	if continuous updating is off. (See Design Note at top of file.)
*/
- (void)mouseDown:(NSEvent *)inEvent
{
	[liveValueTextField setHidden:NO];
	dragging = YES;
	[super mouseDown:inEvent];
	dragging = NO;
	if (!showFieldWhenNotUpdating) [liveValueTextField setHidden:YES];
	
	if (!outwardsContinuous && NULL != outwardsAction) [NSApp sendAction:outwardsAction to:outwardsTarget from:self];
}


#pragma mark NSView

- (id)initWithFrame:(NSRect)inFrame
{
	self = [super initWithFrame:inFrame];
	if (nil != self) [self performSetUp];
	return self;
}


#pragma mark NSControl

- (BOOL)isContinuous
{
	return outwardsContinuous;
}


- (void)setContinuous:(BOOL)inFlag
{
	outwardsContinuous = inFlag;
}


- (id)target
{
	return outwardsTarget;
}


- (void)setTarget:(id)inObject
{
	outwardsTarget = inObject;
}


- (SEL)action
{
	return outwardsAction;
}


- (void)setAction:(SEL)inAction
{
	outwardsAction = inAction;
}


#pragma mark SCSliderWithTextField

- (id)delegate
{
	return delegate;
}


- (void)setDelegate:(id)inDelegate
{
	delegate = inDelegate;
}


- (NSTextField *)liveValueTextField
{
	return liveValueTextField;
}


- (void)setLiveValueTextField:(NSTextField *)inField
{
	liveValueTextField = inField;
}


- (BOOL)showFieldWhenNotUpdating
{
	return showFieldWhenNotUpdating;
}


- (void)setShowFieldWhenNotUpdating:(BOOL)inFlag
{
	showFieldWhenNotUpdating = inFlag;
}


#pragma mark SCSliderWithTextField (Private)

/*	-performSetUp
	Perform necessary set-up. In particular, set up target and action to call -selfDidUpdate:,
	while remembering the “real” target and action. See Design Note at top of file.
*/
- (void)performSetUp
{
	outwardsTarget = [self target];
	[super setTarget:self];
	
	outwardsAction = [self action];
	[super setAction:@selector(selfDidUpdate:)];
	
	outwardsContinuous = [self isContinuous];
	[super setContinuous:YES];
}


/*	-selfDidUpdate:
	The target as seen by the superclass. This is responsible for updating the liveValueTextField,
	and calling through to the “outwards target” if the slider is (outwardsly) continuous-updating.
	(See Design Note at top of file.)
*/
- (void)selfDidUpdate:(id)inSender
{
	double						value;
	NSString					*displayString = nil;
	
	// inSender should be self here, unless someone’s playing silly buggers.
	value = [inSender doubleValue];
	if ([delegate respondsToSelector:@selector(slider:displayValueForValue:)])
	{
		// Let delegate format the string.
		displayString = [delegate slider:self displayValueForValue:value];
	}
	else
	{
		// Just put a double in with no formatting. This allows maximum flexibility to formatters on the text field.
		displayString = [NSString stringWithFormat:@"%g", value];
	}
	[liveValueTextField setStringValue:displayString];
	[liveValueTextField displayIfNeeded];
	
	 if (dragging)
	{
		// Support continuous updating from the client’s perspective.
		if ((outwardsContinuous && NULL != outwardsAction))
		{
			[self sendOutwardAction];
		}
	}
	else
	{
		// Not dragging - full keyboard navigation, accessibility interfaces etc.
		[self sendOutwardAction];
		
		// Temporarily show live value field
		[liveValueTextField setHidden:NO];
		if (!showFieldWhenNotUpdating) [self deferredHideTextField];
	}
}


- (void)sendOutwardAction
{
	[NSApp sendAction:outwardsAction to:outwardsTarget from:self];
}


- (void)deferredHideTextField
{
	NSDate						*fireDate;
	
	if (nil != autoHideTimer)
	{
		[autoHideTimer invalidate];
		[autoHideTimer release];
		autoHideTimer = nil;
	}
	
	fireDate = [NSDate dateWithTimeIntervalSinceNow:kSCSliderWithTextFieldShowInterval];
	autoHideTimer = [[NSTimer alloc] initWithFireDate:fireDate
											 interval:0
											   target:self
											 selector:@selector(autoHideTimerDidFire:)
											 userInfo:nil
											  repeats:NO];
	
	[[NSRunLoop currentRunLoop] addTimer:autoHideTimer forMode:NSDefaultRunLoopMode];
}


- (void)autoHideTimerDidFire:(NSTimer *)inTimer
{
	[liveValueTextField setHidden:YES];
	
	[autoHideTimer release];
	autoHideTimer = nil;
}

@end

