/*

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

#import "JAACPluginFramework.h"


@implementation ACPLUGIN_CLASS_NAME (JAACPluginFramework)

+ (NSBundle *) bundle
{
	static NSBundle			*bundle = nil;
	
	if (bundle == nil)  bundle = [[NSBundle bundleForClass:[ACPLUGIN_CLASS_NAME class]] retain];
	return bundle;
}


+ (NSString *) localizedString:(NSString *)key
{
	return [[self bundle] localizedStringForKey:key value:@"" table:nil];
}

/*	Since Acorn doesn't provide a mechanism for plug-in prefs management, we
	use a dictionary keyed by bundle in the app prefs.
*/
+ (NSString *) preferencesRootKey
{
	return [NSString stringWithFormat:@"Plug-in %@ settings", [[self bundle] bundleIdentifier]];
}


+ (NSDictionary *) preferencesDictionary
{
	NSDictionary			*dict = nil;
	
	dict = [[NSUserDefaults standardUserDefaults] objectForKey:[self preferencesRootKey]];
	if (![dict isKindOfClass:[NSDictionary class]])  dict = nil;
	
	return dict;
}


+ (id) preferenceForKey:(NSString *)key
{
	return [[self preferencesDictionary] objectForKey:key];
}


+ (void) setPreference:(id)value forKey:(NSString *)key
{
	NSMutableDictionary		*prefs = nil;
	
	if (key == nil)  return;
	
	prefs = [[self preferencesDictionary] mutableCopy];
	if (prefs == nil && value != nil)  prefs = [NSMutableDictionary dictionaryWithCapacity:1];
	if (value != nil)  [prefs setObject:value forKey:key];
	else  [prefs removeObjectForKey:key];
	
	[[NSUserDefaults standardUserDefaults] setObject:prefs forKey:[self preferencesRootKey]];
}

@end
