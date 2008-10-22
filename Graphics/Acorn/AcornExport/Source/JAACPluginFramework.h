/*
 
JAACPluginFramework

A kind-of framework for Acorn plug-ins. Ideally they'd be in a base class for
plug-ins, but that runs into the problem of Objective-C's flat namespace for
classes -- it could be problematic to have the same class defined in multiple
plug-ins. Instead, it's implemented as a category on the plug-in's base class.
For this to work, ACPLUGIN_CLASS_NAME must be defined to the relevant class,
and it must be declared in/imported into a prefix header. The following build
settings are useful (assuming the primary class NameOfPlugInClass is declared
in Source/NameOfPlugInClass.h):

ACPLUGIN_CLASS_NAME = NameOfPlugInClass
GCC_PREPROCESSOR_DEFINITIONS_NOT_USED_IN_PRECOMPS = ACPLUGIN_CLASS_NAME=$ACPLUGIN_CLASS_NAME
GCC_PREFIX_HEADER = Source/$(ACPLUGIN_CLASS_NAME).h


Copyright © 2007 Jens Ayton

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
 
*/


@interface ACPLUGIN_CLASS_NAME (JAACPluginFramework)

+ (NSBundle *) bundle;
+ (NSString *) localizedString:(NSString *)key;
+ (id) preferenceForKey:(NSString *)key;
+ (void) setPreference:(id)value forKey:(NSString *)key;

#define JAPlugBundle() [ACPLUGIN_CLASS_NAME bundle]

#define JAPlugLocalizedString(string, description) \
	[JAPlugBundle() localizedStringForKey:string value:@"" table:nil]

#define JAGetPreference(key)  [ACPLUGIN_CLASS_NAME preferenceForKey:key]
#define JASetPreference(key, value)  [ACPLUGIN_CLASS_NAME setPreference:value forKey:key]

@end
