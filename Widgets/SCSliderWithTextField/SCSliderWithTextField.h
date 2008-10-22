/*
	SCSliderWithTextField.h
	
	Subclass of NSSlider which live-updates a text field when being changed. Other than the need to
	hook up a text field to the liveValueTextField outlet, it should work just like a regular slider.
	
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

#import <Cocoa/Cocoa.h>


@interface SCSliderWithTextField: NSSlider
{
	IBOutlet id				delegate;
	IBOutlet NSTextField	*liveValueTextField;
	
	id						outwardsTarget;
	SEL						outwardsAction;
	BOOL					outwardsContinuous;
	BOOL					showFieldWhenNotUpdating;
	BOOL					dragging;
	
	NSTimer					*autoHideTimer;
}

/*	delegate
	Object which implements 0 or more methods of the informal protocol
	SCSliderWithTextFieldDelegate.
	NOTE: as is usual for delegates, this is not retained.
*/
- (id)delegate;
- (void)setDelegate:(id)inDelegate;

/*	liveValueTextField
	NSTextField to display the current value while dragging.
	NOTE: this field is not retained.
*/
- (NSTextField *)liveValueTextField;
- (void)setLiveValueTextField:(NSTextField *)inField;

/*	showFieldWhenNotUpdating
	If true, the text field is left visible after modifying the slider. Otherwise, it is visible
	only while dragging. Default: NO.
	
	-setShowFieldWhenNotUpdating: does not change the visibility of the text field when called; it
	only affects whether it will be hidden after dragging.
*/
- (BOOL)showFieldWhenNotUpdating;
- (void)setShowFieldWhenNotUpdating:(BOOL)inFlag;

@end


@interface NSObject (SCSliderWithTextFieldDelegate)

/*	(Optional) formatted string to show in text field. Default is value as a double. An alternative
	would be to use a formatter on the text field.
*/
- (NSString *)slider:(SCSliderWithTextField *)inSlider displayValueForValue:(double)inValue;

@end
