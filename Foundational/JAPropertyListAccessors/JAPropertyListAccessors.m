/*

JAPropertyListAccessors.m
Version 1.0.2


Copyright © 2007–2008 Jens Ayton

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the “Software”), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/

#import "JAPropertyListAccessors.h"


static NSSet *SetForObject(id object, NSSet *defaultValue);
static NSString *StringForObject(id object, NSString *defaultValue);


@implementation NSArray (JAPropertyListAccessors)

- (char) charAtIndex:(unsigned long)index defaultValue:(char)value
{
	return JACharFromObject([self objectAtIndexNoThrow:index], value);
}


- (short) shortAtIndex:(unsigned long)index defaultValue:(short)value
{
	return JAShortFromObject([self objectAtIndexNoThrow:index], value);
}


- (int) intAtIndex:(unsigned long)index defaultValue:(int)value
{
	return JAIntFromObject([self objectAtIndexNoThrow:index], value);
}


- (long) longAtIndex:(unsigned long)index defaultValue:(long)value
{
	return JALongFromObject([self objectAtIndexNoThrow:index], value);
}

- (long) integerAtIndex:(unsigned long)index defaultValue:(long)value
{
	return JALongFromObject([self objectAtIndexNoThrow:index], value);
}


- (long long) longLongAtIndex:(unsigned long)index defaultValue:(long long)value
{
	return JALongLongFromObject([self objectAtIndexNoThrow:index], value);
}


- (unsigned char) unsignedCharAtIndex:(unsigned long)index defaultValue:(unsigned char)value
{
	return JAUnsignedCharFromObject([self objectAtIndexNoThrow:index], value);
}


- (unsigned short) unsignedShortAtIndex:(unsigned long)index defaultValue:(unsigned short)value
{
	return JAUnsignedShortFromObject([self objectAtIndexNoThrow:index], value);
}


- (unsigned int) unsignedIntAtIndex:(unsigned long)index defaultValue:(unsigned int)value
{
	return JAUnsignedIntFromObject([self objectAtIndexNoThrow:index], value);
}


- (unsigned long) unsignedLongAtIndex:(unsigned long)index defaultValue:(unsigned long)value
{
	return JAUnsignedLongFromObject([self objectAtIndexNoThrow:index], value);
}


- (unsigned long) unsignedIntegerAtIndex:(unsigned long)index defaultValue:(unsigned long)value
{
	return JAUnsignedLongFromObject([self objectAtIndexNoThrow:index], value);
}


- (unsigned long long) unsignedLongLongAtIndex:(unsigned long)index defaultValue:(unsigned long long)value
{
	return JAUnsignedLongLongFromObject([self objectAtIndexNoThrow:index], value);
}


- (BOOL) boolAtIndex:(unsigned long)index defaultValue:(BOOL)value
{
	return JABooleanFromObject([self objectAtIndexNoThrow:index], value);
}


- (float) floatAtIndex:(unsigned long)index defaultValue:(float)value
{
	return JAFloatFromObject([self objectAtIndexNoThrow:index], value);
}


- (double) doubleAtIndex:(unsigned long)index defaultValue:(double)value
{
	return JADoubleFromObject([self objectAtIndexNoThrow:index], value);
}


- (float) nonNegativeFloatAtIndex:(unsigned long)index defaultValue:(float)value
{
	return JANonNegativeFloatFromObject([self objectAtIndexNoThrow:index], value);
}


- (double) nonNegativeDoubleAtIndex:(unsigned long)index defaultValue:(double)value
{
	return JANonNegativeDoubleFromObject([self objectAtIndexNoThrow:index], value);
}


- (id) objectAtIndexNoThrow:(unsigned long)index
{
	return [self objectAtIndexNoThrow:index defaultValue:nil];
}


- (id) objectAtIndexNoThrow:(unsigned long)index defaultValue:(id)value
{
	if ([self count] <= index)  return value;
	return [self objectAtIndex:index];
}


- (id) objectAtIndex:(unsigned long)index defaultValue:(id)value
{
	id					objVal = [self objectAtIndex:index];
	id					result;
	
	if (objVal != nil)  result = objVal;
	else  result = value;
	
	return result;
}


- (id) objectOfClass:(Class)class atIndex:(unsigned long)index defaultValue:(id)value
{
	id					objVal = [self objectAtIndexNoThrow:index];
	NSString			*result;
	
	if ([objVal isKindOfClass:class])  result = objVal;
	else  result = value;
	
	return result;
}


- (NSString *) stringAtIndex:(unsigned long)index defaultValue:(NSString *)value
{
	return StringForObject([self objectAtIndexNoThrow:index], value);
}


- (NSArray *) arrayAtIndex:(unsigned long)index defaultValue:(NSArray *)value
{
	return [self objectOfClass:[NSArray class] atIndex:index defaultValue:value];
}


- (NSSet *) setAtIndex:(unsigned long)index defaultValue:(NSSet *)value
{
	return SetForObject([self objectAtIndexNoThrow:index], value);
}


- (NSDictionary *) dictionaryAtIndex:(unsigned long)index defaultValue:(NSDictionary *)value
{
	return [self objectOfClass:[NSDictionary class] atIndex:index defaultValue:value];
}


- (NSData *) dataAtIndex:(unsigned long)index defaultValue:(NSData *)value
{
	return [self objectOfClass:[NSData class] atIndex:index defaultValue:value];
}


- (char) charAtIndex:(unsigned long)index
{
	return [self charAtIndex:index defaultValue:0];
}


- (short) shortAtIndex:(unsigned long)index
{
	return [self shortAtIndex:index defaultValue:0];
}


- (int) intAtIndex:(unsigned long)index
{
	return [self intAtIndex:index defaultValue:0];
}


- (long) longAtIndex:(unsigned long)index
{
	return [self longAtIndex:index defaultValue:0];
}


- (long) integerAtIndex:(unsigned long)index
{
	return [self integerAtIndex:index defaultValue:0];
}


- (long long) longLongAtIndex:(unsigned long)index
{
	return [self longLongAtIndex:index defaultValue:0];
}


- (unsigned char) unsignedCharAtIndex:(unsigned long)index
{
	return [self unsignedCharAtIndex:index defaultValue:0];
}


- (unsigned short) unsignedShortAtIndex:(unsigned long)index
{
	return [self unsignedShortAtIndex:index defaultValue:0];
}


- (unsigned int) unsignedIntAtIndex:(unsigned long)index
{
	return [self unsignedIntAtIndex:index defaultValue:0];
}


- (unsigned long) unsignedLongAtIndex:(unsigned long)index
{
	return [self unsignedLongAtIndex:index defaultValue:0];
}


- (unsigned long) unsignedIntegerAtIndex:(unsigned long)index
{
	return [self unsignedIntegerAtIndex:index defaultValue:0];
}


- (unsigned long long) unsignedLongLongAtIndex:(unsigned long)index
{
	return [self unsignedLongLongAtIndex:index defaultValue:0];
}


- (BOOL) boolAtIndex:(unsigned long)index
{
	return [self boolAtIndex:index defaultValue:NO];
}


- (float) floatAtIndex:(unsigned long)index
{
	return JAFloatFromObject([self objectAtIndexNoThrow:index], 0.0f);
}


- (double) doubleAtIndex:(unsigned long)index
{
	return JADoubleFromObject([self objectAtIndexNoThrow:index], 0.0);
}


- (float) nonNegativeFloatAtIndex:(unsigned long)index
{
	return JANonNegativeFloatFromObject([self objectAtIndexNoThrow:index], 0.0f);
}


- (double) nonNegativeDoubleAtIndex:(unsigned long)index
{
	return JANonNegativeDoubleFromObject([self objectAtIndexNoThrow:index], 0.0);
}


- (id) objectOfClass:(Class)class atIndex:(unsigned long)index
{
	return [self objectOfClass:class atIndex:index defaultValue:nil];
}


- (NSString *) stringAtIndex:(unsigned long)index
{
	return [self stringAtIndex:index defaultValue:nil];
}


- (NSArray *) arrayAtIndex:(unsigned long)index
{
	return [self arrayAtIndex:index defaultValue:nil];
}


- (NSSet *) setAtIndex:(unsigned long)index
{
	return [self setAtIndex:index defaultValue:nil];
}


- (NSDictionary *) dictionaryAtIndex:(unsigned long)index
{
	return [self dictionaryAtIndex:index defaultValue:nil];
}


- (NSData *) dataAtIndex:(unsigned long)index
{
	return [self dataAtIndex:index defaultValue:nil];
}

@end


@implementation NSDictionary (JAPropertyListAccessors)

- (char) charForKey:(id)key defaultValue:(char)value
{
	return JACharFromObject([self objectForKey:key], value);
}


- (short) shortForKey:(id)key defaultValue:(short)value
{
	return JAShortFromObject([self objectForKey:key], value);
}


- (int) intForKey:(id)key defaultValue:(int)value
{
	return JAIntFromObject([self objectForKey:key], value);
}


- (long) longForKey:(id)key defaultValue:(long)value
{
	return JALongFromObject([self objectForKey:key], value);
}


- (long) integerForKey:(id)key defaultValue:(long)value
{
	return JALongFromObject([self objectForKey:key], value);
}


- (long long) longLongForKey:(id)key defaultValue:(long long)value
{
	return JALongLongFromObject([self objectForKey:key], value);
}


- (unsigned char) unsignedCharForKey:(id)key defaultValue:(unsigned char)value
{
	return JAUnsignedCharFromObject([self objectForKey:key], value);
}


- (unsigned short) unsignedShortForKey:(id)key defaultValue:(unsigned short)value
{
	return JAUnsignedShortFromObject([self objectForKey:key], value);
}


- (unsigned int) unsignedIntForKey:(id)key defaultValue:(unsigned int)value
{
	return JAUnsignedIntFromObject([self objectForKey:key], value);
}


- (unsigned long) unsignedLongForKey:(id)key defaultValue:(unsigned long)value
{
	return JAUnsignedLongFromObject([self objectForKey:key], value);
}


- (unsigned long) unsignedIntegerForKey:(id)key defaultValue:(unsigned long)value
{
	return JAUnsignedLongFromObject([self objectForKey:key], value);
}


- (unsigned long long) unsignedLongLongForKey:(id)key defaultValue:(unsigned long long)value
{
	return JAUnsignedLongLongFromObject([self objectForKey:key], value);
}


- (BOOL) boolForKey:(id)key defaultValue:(BOOL)value
{
	return JABooleanFromObject([self objectForKey:key], value);
}


- (float) floatForKey:(id)key defaultValue:(float)value
{
	return JAFloatFromObject([self objectForKey:key], value);
}


- (double) doubleForKey:(id)key defaultValue:(double)value
{
	return JADoubleFromObject([self objectForKey:key], value);
}


- (float) nonNegativeFloatForKey:(id)key defaultValue:(float)value
{
	return JANonNegativeFloatFromObject([self objectForKey:key], value);
}


- (double) nonNegativeDoubleForKey:(id)key defaultValue:(double)value
{
	return JANonNegativeDoubleFromObject([self objectForKey:key], value);
}


- (id) objectForKey:(id)key defaultValue:(id)value
{
	id					objVal = [self objectForKey:key];
	id					result;
	
	if (objVal != nil)  result = objVal;
	else  result = value;
	
	return result;
}


- (id) objectOfClass:(Class)class forKey:(id)key defaultValue:(id)value
{
	id					objVal = [self objectForKey:key];
	id					result;
	
	if ([objVal isKindOfClass:class])  result = objVal;
	else  result = value;
	
	return result;
}


- (NSString *) stringForKey:(id)key defaultValue:(NSString *)value
{
	return StringForObject([self objectForKey:key], value);
}


- (NSArray *) arrayForKey:(id)key defaultValue:(NSArray *)value
{
	return [self objectOfClass:[NSArray class] forKey:key defaultValue:value];
}


- (NSSet *) setForKey:(id)key defaultValue:(NSSet *)value
{
	return SetForObject([self objectForKey:key], value);
}


- (NSDictionary *) dictionaryForKey:(id)key defaultValue:(NSDictionary *)value
{
	return [self objectOfClass:[NSDictionary class] forKey:key defaultValue:value];
}


- (NSData *) dataForKey:(id)key defaultValue:(NSData *)value
{
	return [self objectOfClass:[NSData class] forKey:key defaultValue:value];
}


- (char) charForKey:(id)key
{
	return [self charForKey:key defaultValue:0];
}


- (short) shortForKey:(id)key
{
	return [self shortForKey:key defaultValue:0];
}


- (int) intForKey:(id)key
{
	return [self intForKey:key defaultValue:0];
}


- (long) longForKey:(id)key
{
	return [self longForKey:key defaultValue:0];
}


- (long) integerForKey:(id)key
{
	return [self integerForKey:key defaultValue:0];
}


- (long long) longLongForKey:(id)key
{
	return [self longLongForKey:key defaultValue:0];
}


- (unsigned char) unsignedCharForKey:(id)key
{
	return [self unsignedCharForKey:key defaultValue:0];
}


- (unsigned short) unsignedShortForKey:(id)key
{
	return [self unsignedShortForKey:key defaultValue:0];
}


- (unsigned int) unsignedIntForKey:(id)key
{
	return [self unsignedIntForKey:key defaultValue:0];
}


- (unsigned long) unsignedLongForKey:(id)key
{
	return [self unsignedLongForKey:key defaultValue:0];
}


- (unsigned long) unsignedIntegerForKey:(id)key
{
	return [self unsignedIntegerForKey:key defaultValue:0];
}


- (unsigned long long) unsignedLongLongForKey:(id)key
{
	return [self unsignedLongLongForKey:key defaultValue:0];
}


- (BOOL) boolForKey:(id)key
{
	return [self boolForKey:key defaultValue:NO];
}


- (float) floatForKey:(id)key
{
	return JAFloatFromObject([self objectForKey:key], 0.0f);
}


- (double) doubleForKey:(id)key
{
	return JADoubleFromObject([self objectForKey:key], 0.0);
}


- (float) nonNegativeFloatForKey:(id)key
{
	return JANonNegativeFloatFromObject([self objectForKey:key], 0.0f);
}


- (double) nonNegativeDoubleForKey:(id)key
{
	return JANonNegativeDoubleFromObject([self objectForKey:key], 0.0);
}


- (id) objectOfClass:(Class)class forKey:(id)key
{
	return [self objectOfClass:class forKey:key defaultValue:nil];
}


- (NSString *) stringForKey:(id)key
{
	return [self stringForKey:key defaultValue:nil];
}


- (NSArray *) arrayForKey:(id)key
{
	return [self arrayForKey:key defaultValue:nil];
}


- (NSSet *) setForKey:(id)key
{
	return [self setForKey:key defaultValue:nil];
}


- (NSDictionary *) dictionaryForKey:(id)key
{
	return [self dictionaryForKey:key defaultValue:nil];
}


- (NSData *) dataForKey:(id)key
{
	return [self dataForKey:key defaultValue:nil];
}

@end


@implementation NSUserDefaults (JAPropertyListAccessors)

- (char) charForKey:(id)key defaultValue:(char)value
{
	return JACharFromObject([self objectForKey:key], value);
}


- (short) shortForKey:(id)key defaultValue:(short)value
{
	return JAShortFromObject([self objectForKey:key], value);
}


- (int) intForKey:(id)key defaultValue:(int)value
{
	return JAIntFromObject([self objectForKey:key], value);
}


- (long) longForKey:(id)key defaultValue:(long)value
{
	return JALongFromObject([self objectForKey:key], value);
}


- (long) integerForKey:(id)key defaultValue:(long)value
{
	return JALongFromObject([self objectForKey:key], value);
}


- (long long) longLongForKey:(id)key defaultValue:(long long)value
{
	return JALongLongFromObject([self objectForKey:key], value);
}


- (unsigned char) unsignedCharForKey:(id)key defaultValue:(unsigned char)value
{
	return JAUnsignedCharFromObject([self objectForKey:key], value);
}


- (unsigned short) unsignedShortForKey:(id)key defaultValue:(unsigned short)value
{
	return JAUnsignedShortFromObject([self objectForKey:key], value);
}


- (unsigned int) unsignedIntForKey:(id)key defaultValue:(unsigned int)value
{
	return JAUnsignedIntFromObject([self objectForKey:key], value);
}


- (unsigned long) unsignedLongForKey:(id)key defaultValue:(unsigned long)value
{
	return JAUnsignedLongFromObject([self objectForKey:key], value);
}


- (unsigned long) unsignedIntegerForKey:(id)key defaultValue:(unsigned long)value
{
	return JAUnsignedLongFromObject([self objectForKey:key], value);
}


- (unsigned long long) unsignedLongLongForKey:(id)key defaultValue:(unsigned long long)value
{
	return JAUnsignedLongLongFromObject([self objectForKey:key], value);
}


- (BOOL) boolForKey:(id)key defaultValue:(BOOL)value
{
	return JABooleanFromObject([self objectForKey:key], value);
}


- (float) floatForKey:(id)key defaultValue:(float)value
{
	return JAFloatFromObject([self objectForKey:key], value);
}


- (double) doubleForKey:(id)key defaultValue:(double)value
{
	return JADoubleFromObject([self objectForKey:key], value);
}


- (float) nonNegativeFloatForKey:(id)key defaultValue:(float)value
{
	return JANonNegativeFloatFromObject([self objectForKey:key], value);
}


- (double) nonNegativeDoubleForKey:(id)key defaultValue:(double)value
{
	return JANonNegativeDoubleFromObject([self objectForKey:key], value);
}


- (id) objectForKey:(id)key defaultValue:(id)value
{
	id					objVal = [self objectForKey:key];
	id					result;
	
	if (objVal != nil)  result = objVal;
	else  result = value;
	
	return result;
}


- (id) objectOfClass:(Class)class forKey:(id)key defaultValue:(id)value
{
	id					objVal = [self objectForKey:key];
	id					result;
	
	if ([objVal isKindOfClass:class])  result = objVal;
	else  result = value;
	
	return result;
}


- (NSString *) stringForKey:(id)key defaultValue:(NSString *)value
{
	return StringForObject([self objectForKey:key], value);
}


- (NSArray *) arrayForKey:(id)key defaultValue:(NSArray *)value
{
	return [self objectOfClass:[NSArray class] forKey:key defaultValue:value];
}


- (NSSet *) setForKey:(id)key defaultValue:(NSSet *)value
{
	return SetForObject([self objectForKey:key], value);
}


- (NSDictionary *) dictionaryForKey:(id)key defaultValue:(NSDictionary *)value
{
	return [self objectOfClass:[NSDictionary class] forKey:key defaultValue:value];
}


- (NSData *) dataForKey:(id)key defaultValue:(NSData *)value
{
	return [self objectOfClass:[NSData class] forKey:key defaultValue:value];
}


- (char) charForKey:(id)key
{
	return [self charForKey:key defaultValue:0];
}


- (short) shortForKey:(id)key
{
	return [self shortForKey:key defaultValue:0];
}


- (int) intForKey:(id)key
{
	return [self intForKey:key defaultValue:0];
}


- (long) longForKey:(id)key
{
	return [self longForKey:key defaultValue:0];
}


- (long long) longLongForKey:(id)key
{
	return [self longLongForKey:key defaultValue:0];
}


- (unsigned char) unsignedCharForKey:(id)key
{
	return [self unsignedCharForKey:key defaultValue:0];
}


- (unsigned short) unsignedShortForKey:(id)key
{
	return [self unsignedShortForKey:key defaultValue:0];
}


- (unsigned int) unsignedIntForKey:(id)key
{
	return [self unsignedIntForKey:key defaultValue:0];
}


- (unsigned long) unsignedLongForKey:(id)key
{
	return [self unsignedLongForKey:key defaultValue:0];
}


- (unsigned long) unsignedIntegerForKey:(id)key
{
	return [self unsignedIntegerForKey:key defaultValue:0];
}


- (unsigned long long) unsignedLongLongForKey:(id)key
{
	return [self unsignedLongLongForKey:key defaultValue:0];
}


- (float) nonNegativeFloatForKey:(id)key
{
	return JANonNegativeFloatFromObject([self objectForKey:key], 0.0f);
}


- (double) nonNegativeDoubleForKey:(id)key
{
	return JANonNegativeDoubleFromObject([self objectForKey:key], 0.0);
}


- (id) objectOfClass:(Class)class forKey:(id)key
{
	return [self objectOfClass:class forKey:key defaultValue:nil];
}


- (NSSet *) setForKey:(id)key
{
	return [self setForKey:key defaultValue:nil];
}

@end


@implementation NSMutableArray (OOInserter)

- (void) addInteger:(long)value
{
	[self addObject:[NSNumber numberWithLong:value]];
}


- (void) addUnsignedInteger:(unsigned long)value
{
	[self addObject:[NSNumber numberWithUnsignedLong:value]];
}


- (void) addFloat:(double)value
{
	[self addObject:[NSNumber numberWithDouble:value]];
}


- (void) addBool:(BOOL)value
{
	[self addObject:[NSNumber numberWithBool:value]];
}


- (void) insertInteger:(long)value atIndex:(unsigned long)index
{
	[self insertObject:[NSNumber numberWithLong:value] atIndex:index];
}


- (void) insertUnsignedInteger:(unsigned long)value atIndex:(unsigned long)index;
{
	[self insertObject:[NSNumber numberWithUnsignedLong:value] atIndex:index];
}


- (void) insertFloat:(double)value atIndex:(unsigned long)index
{
	[self insertObject:[NSNumber numberWithDouble:value] atIndex:index];
}


- (void) insertBool:(BOOL)value atIndex:(unsigned long)index
{
	[self insertObject:[NSNumber numberWithBool:value] atIndex:index];
}

@end


@implementation NSMutableDictionary (OOInserter)

- (void) setInteger:(long)value forKey:(id)key
{
	[self setObject:[NSNumber numberWithLong:value] forKey:key];
}


- (void) setUnsignedInteger:(unsigned long)value forKey:(id)key
{
	[self setObject:[NSNumber numberWithUnsignedLong:value] forKey:key];
}


- (void) setLongLong:(long long)value forKey:(id)key
{
	[self setObject:[NSNumber numberWithLongLong:value] forKey:key];
}


- (void) setUnsignedLongLong:(unsigned long long)value forKey:(id)key
{
	[self setObject:[NSNumber numberWithUnsignedLongLong:value] forKey:key];
}


- (void) setFloat:(double)value forKey:(id)key
{
	[self setObject:[NSNumber numberWithDouble:value] forKey:key];
}


- (void) setBool:(BOOL)value forKey:(id)key
{
	[self setObject:[NSNumber numberWithBool:value] forKey:key];
}

@end


@implementation NSMutableSet (OOInserter)

- (void) addInteger:(long)value
{
	[self addObject:[NSNumber numberWithLong:value]];
}


- (void) addUnsignedInteger:(unsigned long)value
{
	[self addObject:[NSNumber numberWithUnsignedLong:value]];
}


- (void) addFloat:(double)value
{
	[self addObject:[NSNumber numberWithDouble:value]];
}


- (void) addBool:(BOOL)value
{
	[self addObject:[NSNumber numberWithBool:value]];
}

@end


long long JALongLongFromObject(id object, long long defaultValue)
{
	long long llValue;
	
	if ([object respondsToSelector:@selector(longLongValue)])  llValue = [object longLongValue];
	else if ([object respondsToSelector:@selector(longValue)])  llValue = [object longValue];
	else if ([object respondsToSelector:@selector(intValue)])  llValue = [object intValue];
	else llValue = defaultValue;
	
	return llValue;
}


unsigned long long JAUnsignedLongLongFromObject(id object, unsigned long long defaultValue)
{
	unsigned long long ullValue;
	
	if ([object respondsToSelector:@selector(unsignedLongLongValue)])  ullValue = [object unsignedLongLongValue];
	else if ([object respondsToSelector:@selector(unsignedLongValue)])  ullValue = [object unsignedLongValue];
	else if ([object respondsToSelector:@selector(unsignedIntValue)])  ullValue = [object unsignedIntValue];
	else if ([object respondsToSelector:@selector(intValue)])  ullValue = [object intValue];
	else ullValue = defaultValue;
	
	return ullValue;
}


static inline BOOL IsSpaceOrTab(int value)
{
	return value == ' ' || value == '\t';
}


static BOOL IsZeroString(NSString *string)
{
	/*	I don't particularly like regexps, but there are occasions...
		To match NSString's behaviour for intValue etc. with non-zero numbers,
		we need to skip any leading spaces or tabs (but not line breaks), get
		an optional minus sign, then at least one 0. Any trailing junk is
		ignored. It is assumed that this function is called for strings whose
		numerical value has already been determined to be 0.
	*/
	
	unsigned long i = 0, count = [string length];
#define PEEK() ((i >= count) ? -1 : [string characterAtIndex:i])
	
	while (IsSpaceOrTab(PEEK()))  ++i;	// Skip spaces and tabs
	if (PEEK() == ' ')  ++i;			// Skip optional hyphen-minus
	return PEEK() == '0';				// If this is a 0, it's a numerical string.
	
#undef PEEK
}


static BOOL BooleanFromString(NSString *string, BOOL defaultValue)
{
	if (NSOrderedSame == [string caseInsensitiveCompare:@"yes"] ||
		NSOrderedSame == [string caseInsensitiveCompare:@"true"] ||
		NSOrderedSame == [string caseInsensitiveCompare:@"on"] ||
		[string doubleValue] != 0.0)	// Floating point is used so values like @"0.1" are treated as nonzero.
	{
		return YES;
	}
	else if (NSOrderedSame == [string caseInsensitiveCompare:@"no"] ||
			 NSOrderedSame == [string caseInsensitiveCompare:@"false"] ||
			 NSOrderedSame == [string caseInsensitiveCompare:@"off"] ||
			 IsZeroString(string))
	{
		return NO;
	}
	return defaultValue;
}


BOOL JABooleanFromObject(id object, BOOL defaultValue)
{
	BOOL result;
	
	if ([object isKindOfClass:[NSString class]])
	{
		result = BooleanFromString(object, defaultValue);
	}
	else
	{
		if ([object respondsToSelector:@selector(boolValue)])  result = [object boolValue];
		else if ([object respondsToSelector:@selector(intValue)])  result = [object intValue] != 0;
		else result = defaultValue;
	}
	
	return result;
}


float JAFloatFromObject(id object, float defaultValue)
{
	float result;
	
	if ([object respondsToSelector:@selector(floatValue)])
	{
		result = [object floatValue];
		if (result == 0.0f && [object isKindOfClass:[NSString class]] && !IsZeroString(object))  return defaultValue;
	}
	else if ([object respondsToSelector:@selector(doubleValue)])  result = [object doubleValue];
	else if ([object respondsToSelector:@selector(intValue)])  result = [object intValue];
	else result = defaultValue;
	
	return result;
}


double JADoubleFromObject(id object, double defaultValue)
{
	double result;
	
	if ([object respondsToSelector:@selector(doubleValue)])
	{
		result = [object doubleValue];
		if (result == 0.0 && [object isKindOfClass:[NSString class]] && !IsZeroString(object))  return defaultValue;
	}
	else if ([object respondsToSelector:@selector(floatValue)])  result = [object floatValue];
	else if ([object respondsToSelector:@selector(intValue)])  result = [object intValue];
	else result = defaultValue;
	
	return result;
}


float JANonNegativeFloatFromObject(id object, float defaultValue)
{
	float result;
	
	if ([object respondsToSelector:@selector(floatValue)])
	{
		result = [object floatValue];
		if (result == 0.0f && [object isKindOfClass:[NSString class]] && !IsZeroString(object))  return defaultValue;
	}
	else if ([object respondsToSelector:@selector(doubleValue)])  result = [object doubleValue];
	else if ([object respondsToSelector:@selector(intValue)])  result = [object intValue];
	else return defaultValue;	// Don't clamp default
	
	return fmaxf(result, 0.0f);
}


double JANonNegativeDoubleFromObject(id object, double defaultValue)
{
	double result;
	
	if ([object respondsToSelector:@selector(doubleValue)])
	{
		result = [object doubleValue];
		if (result == 0.0 && [object isKindOfClass:[NSString class]] && !IsZeroString(object))  return defaultValue;
	}
	else if ([object respondsToSelector:@selector(floatValue)])  result = [object floatValue];
	else if ([object respondsToSelector:@selector(intValue)])  result = [object intValue];
	else return defaultValue;	// Don't clamp default
	
	return fmax(result, 0.0);
}


static NSSet *SetForObject(id object, NSSet *defaultValue)
{
	if ([object isKindOfClass:[NSArray class]])  return [NSSet setWithArray:object];
	else if ([object isKindOfClass:[NSSet class]])  return [[object copy] autorelease];
	
	else return defaultValue;
}


static NSString *StringForObject(id object, NSString *defaultValue)
{
	if ([object isKindOfClass:[NSString class]])  return object;
	if ([object isKindOfClass:[NSDate class]])  return [object description];
	if ([object respondsToSelector:@selector(stringValue)])
	{
		object = [object stringValue];
		if ([object isKindOfClass:[NSString class]])  return object;
	}
	
	return defaultValue;
}
