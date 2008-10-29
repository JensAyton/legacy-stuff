/*

JAPropertyListAccessors.h
Version 1.0.1

Convenience accessors for NSArray, NSDictionary and NSUserDefaults.
In addition to being convenient, these perform type checking. Which is,
y’know, good to have. Each method has a <type>AtIndex: or <type>ForKey: variant
and a <type>AtIndex:defaultValue:/<typ>ForKey:defaultValue: variant. The
default value for the simpler variants is always 0, NO or nil.

Note on types: ideally, stdint.h types would be used for integers. However,
NSNumber doesn’t do this, so doing so portably would add new complications.

The various integer methods will always clamp values to the range of the
return type, rather than truncating like NSNumber.

The “Integer” variants are intended to be used with NSInteger variables.
They’re typed long, which is the same size as NSInteger on 32-bit and 64-bit
Mac OS X platforms. Similarly, all array indices are typed unsigned long.
I haven’t looked at the GNUstep definition of NSInteger.

Set accessors aren’t provided for all integer types, since there are no
overflow issues in those cases.

The “non-negative float”/“non-negative double” variants will clamp read values
to zero if negative, but will return a negative defaultValue unchanged.

Functions used to convert objects to various numerical types are at the bottom
of the header.

Set accessors automatically convert arrays to set if necessary. String
accessors automatically convert NSNumbers and NSDates (but extracting dates and
using NSDateFormatter is generally a better plan if a date is what you expect).

Array accessors return default value rather than throwing if index is out of
bounds -- except objectAtIndex:defaultValue:, for parity with objectAtIndex:.
The methods objectAtIndexNoThrow:[defaultValue:] are provided to get this
behaviour for arbitrary objects.


CHANGE LOG
	1.0.1		Default value (rather than nil) is now returned when
				conversion to string fails.
				String conversion now uses -stringValue if available.
	1.0			Initial release.


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


#import <Foundation/Foundation.h>
#import <limits.h>


@interface NSArray (JAPropertyListAccessors)

// Basic integer and boolean accessors; default 0/NO
- (long) integerAtIndex:(unsigned long)index;
- (unsigned long) unsignedIntegerAtIndex:(unsigned long)index;
- (BOOL) boolAtIndex:(unsigned long)index;

// Specific integer types; default 0
- (char) charAtIndex:(unsigned long)index;
- (short) shortAtIndex:(unsigned long)index;
- (int) intAtIndex:(unsigned long)index;
- (long) longAtIndex:(unsigned long)index;
- (long long) longLongAtIndex:(unsigned long)index;

- (unsigned char) unsignedCharAtIndex:(unsigned long)index;
- (unsigned short) unsignedShortAtIndex:(unsigned long)index;
- (unsigned int) unsignedIntAtIndex:(unsigned long)index;
- (unsigned long) unsignedLongAtIndex:(unsigned long)index;
- (unsigned long long) unsignedLongLongAtIndex:(unsigned long)index;

// Floats; default: 0.0
- (float) floatAtIndex:(unsigned long)index;
- (double) doubleAtIndex:(unsigned long)index;
- (float) nonNegativeFloatAtIndex:(unsigned long)index;
- (double) nonNegativeDoubleAtIndex:(unsigned long)index;

// Objects; default: nil
// - (id) objectAtIndex:(unsigned long)index;	// Defined in framework
- (id) objectAtIndexNoThrow:(unsigned long)index;
- (id) objectOfClass:(Class)aClass atIndex:(unsigned long)index;
- (NSString *) stringAtIndex:(unsigned long)index;
- (NSArray *) arrayAtIndex:(unsigned long)index;
- (NSSet *) setAtIndex:(unsigned long)index;
- (NSDictionary *) dictionaryAtIndex:(unsigned long)index;
- (NSData *) dataAtIndex:(unsigned long)index;


// Basic integer and boolean accessors
- (long) integerAtIndex:(unsigned long)index defaultValue:(long)value;
- (unsigned long) unsignedIntegerAtIndex:(unsigned long)index defaultValue:(unsigned long)value;
- (BOOL) boolAtIndex:(unsigned long)index defaultValue:(BOOL)value;

// Specific integer types
- (char) charAtIndex:(unsigned long)index defaultValue:(char)value;
- (short) shortAtIndex:(unsigned long)index defaultValue:(short)value;
- (int) intAtIndex:(unsigned long)index defaultValue:(int)value;
- (long) longAtIndex:(unsigned long)index defaultValue:(long)value;
- (long long) longLongAtIndex:(unsigned long)index defaultValue:(long long)value;

- (unsigned char) unsignedCharAtIndex:(unsigned long)index defaultValue:(unsigned char)value;
- (unsigned short) unsignedShortAtIndex:(unsigned long)index defaultValue:(unsigned short)value;
- (unsigned int) unsignedIntAtIndex:(unsigned long)index defaultValue:(unsigned int)value;
- (unsigned long) unsignedLongAtIndex:(unsigned long)index defaultValue:(unsigned long)value;
- (unsigned long long) unsignedLongLongAtIndex:(unsigned long)index defaultValue:(unsigned long long)value;

// Floats
- (float) floatAtIndex:(unsigned long)index defaultValue:(float)value;
- (double) doubleAtIndex:(unsigned long)index defaultValue:(double)value;
- (float) nonNegativeFloatAtIndex:(unsigned long)index defaultValue:(float)value;
- (double) nonNegativeDoubleAtIndex:(unsigned long)index defaultValue:(double)value;

// Objects
- (id) objectAtIndex:(unsigned long)index defaultValue:(id)value;
- (id) objectAtIndexNoThrow:(unsigned long)index defaultValue:(id)value;
- (id) objectOfClass:(Class)aClass atIndex:(unsigned long)index defaultValue:(id)value;
- (NSString *) stringAtIndex:(unsigned long)index defaultValue:(NSString *)value;
- (NSArray *) arrayAtIndex:(unsigned long)index defaultValue:(NSArray *)value;
- (NSSet *) setAtIndex:(unsigned long)index defaultValue:(NSSet *)value;
- (NSDictionary *) dictionaryAtIndex:(unsigned long)index defaultValue:(NSDictionary *)value;
- (NSData *) dataAtIndex:(unsigned long)index defaultValue:(NSData *)value;

@end



@interface NSDictionary (JAPropertyListAccessors)

// Basic integer and boolean accessors; default 0/NO
- (long) integerForKey:(id)key;
- (unsigned long) unsignedIntegerForKey:(id)key;
- (BOOL) boolForKey:(id)key;

// Specific integer types; default 0
- (char) charForKey:(id)key;
- (short) shortForKey:(id)key;
- (int) intForKey:(id)key;
- (long) longForKey:(id)key;
- (long long) longLongForKey:(id)key;

- (unsigned char) unsignedCharForKey:(id)key;
- (unsigned short) unsignedShortForKey:(id)key;
- (unsigned int) unsignedIntForKey:(id)key;
- (unsigned long) unsignedLongForKey:(id)key;
- (unsigned long long) unsignedLongLongForKey:(id)key;

// Floats; default: 0.0
- (float) floatForKey:(id)key;
- (double) doubleForKey:(id)key;
- (float) nonNegativeFloatForKey:(id)key;
- (double) nonNegativeDoubleForKey:(id)key;

// Objects; default: nil
// - (id) objectForKey:(id)key;			// Defined in framework
- (id) objectOfClass:(Class)aClass forKey:(id)key;
- (NSString *) stringForKey:(id)key;
- (NSArray *) arrayForKey:(id)key;
- (NSSet *) setForKey:(id)key;
- (NSDictionary *) dictionaryForKey:(id)key;
- (NSData *) dataForKey:(id)key;


// Basic integer and boolean accessors
- (long) integerForKey:(id)key defaultValue:(long)value;
- (unsigned long) unsignedIntegerForKey:(id)key defaultValue:(unsigned long)value;
- (BOOL) boolForKey:(id)key defaultValue:(BOOL)value;

// Specific integer types
- (char) charForKey:(id)key defaultValue:(char)value;
- (short) shortForKey:(id)key defaultValue:(short)value;
- (int) intForKey:(id)key defaultValue:(int)value;
- (long) longForKey:(id)key defaultValue:(long)value;
- (long long) longLongForKey:(id)key defaultValue:(long long)value;

- (unsigned char) unsignedCharForKey:(id)key defaultValue:(unsigned char)value;
- (unsigned short) unsignedShortForKey:(id)key defaultValue:(unsigned short)value;
- (unsigned int) unsignedIntForKey:(id)key defaultValue:(unsigned int)value;
- (unsigned long) unsignedLongForKey:(id)key defaultValue:(unsigned long)value;
- (unsigned long long) unsignedLongLongForKey:(id)key defaultValue:(unsigned long long)value;

// Floats
- (float) floatForKey:(id)key defaultValue:(float)value;
- (double) doubleForKey:(id)key defaultValue:(double)value;
- (float) nonNegativeFloatForKey:(id)key defaultValue:(float)value;
- (double) nonNegativeDoubleForKey:(id)key defaultValue:(double)value;

// Objects
- (id) objectForKey:(id)key defaultValue:(id)value;
- (id) objectOfClass:(Class)aClass forKey:(id)key defaultValue:(id)value;
- (NSString *) stringForKey:(id)key defaultValue:(NSString *)value;
- (NSArray *) arrayForKey:(id)key defaultValue:(NSArray *)value;
- (NSSet *) setForKey:(id)key defaultValue:(NSSet *)value;
- (NSDictionary *) dictionaryForKey:(id)key defaultValue:(NSDictionary *)value;
- (NSData *) dataForKey:(id)key defaultValue:(NSData *)value;

@end



@interface NSUserDefaults (JAPropertyListAccessors)

// Basic integer and boolean accessors; default 0/NO
- (long) integerForKey:(id)key;
- (unsigned long) unsignedIntegerForKey:(id)key;
- (BOOL) boolForKey:(id)key;

// Specific integer types; default 0
- (char) charForKey:(id)key;
- (short) shortForKey:(id)key;
- (int) intForKey:(id)key;
- (long) longForKey:(id)key;
- (long long) longLongForKey:(id)key;

- (unsigned char) unsignedCharForKey:(id)key;
- (unsigned short) unsignedShortForKey:(id)key;
- (unsigned int) unsignedIntForKey:(id)key;
- (unsigned long) unsignedLongForKey:(id)key;
- (unsigned long long) unsignedLongLongForKey:(id)key;

// Floats; default: 0.0
// - (float) floatForKey:(id)key;		// Defined in framework
- (double) doubleForKey:(id)key;
- (float) nonNegativeFloatForKey:(id)key;
- (double) nonNegativeDoubleForKey:(id)key;

// Objects; default: nil
// - (id) objectForKey:(id)key;			// Defined in framework
- (id) objectOfClass:(Class)aClass forKey:(id)key;
// - (NSString *) stringForKey:(id)key;	// Defined in framework
// - (NSArray *) arrayForKey:(id)key;	// Defined in framework
- (NSSet *) setForKey:(id)key;
// - (NSDictionary *) dictionaryForKey:(id)key;	// Defined in framework
// - (NSData *) dataForKey:(id)key;		// Defined in framework


// Basic integer and boolean accessors
- (long) integerForKey:(id)key defaultValue:(long)value;
- (unsigned long) unsignedIntegerForKey:(id)key defaultValue:(unsigned long)value;
- (BOOL) boolForKey:(id)key defaultValue:(BOOL)value;

// Specific integer types
- (char) charForKey:(id)key defaultValue:(char)value;
- (short) shortForKey:(id)key defaultValue:(short)value;
- (int) intForKey:(id)key defaultValue:(int)value;
- (long) longForKey:(id)key defaultValue:(long)value;
- (long long) longLongForKey:(id)key defaultValue:(long long)value;

- (unsigned char) unsignedCharForKey:(id)key defaultValue:(unsigned char)value;
- (unsigned short) unsignedShortForKey:(id)key defaultValue:(unsigned short)value;
- (unsigned int) unsignedIntForKey:(id)key defaultValue:(unsigned int)value;
- (unsigned long) unsignedLongForKey:(id)key defaultValue:(unsigned long)value;
- (unsigned long long) unsignedLongLongForKey:(id)key defaultValue:(unsigned long long)value;

// Floats
- (float) floatForKey:(id)key defaultValue:(float)value;
- (double) doubleForKey:(id)key defaultValue:(double)value;
- (float) nonNegativeFloatForKey:(id)key defaultValue:(float)value;
- (double) nonNegativeDoubleForKey:(id)key defaultValue:(double)value;

// Objects
- (id) objectForKey:(id)key defaultValue:(id)value;
- (id) objectOfClass:(Class)aClass forKey:(id)key defaultValue:(id)value;
- (NSString *) stringForKey:(id)key defaultValue:(NSString *)value;
- (NSArray *) arrayForKey:(id)key defaultValue:(NSArray *)value;
- (NSSet *) setForKey:(id)key defaultValue:(NSSet *)value;
- (NSDictionary *) dictionaryForKey:(id)key defaultValue:(NSDictionary *)value;
- (NSData *) dataForKey:(id)key defaultValue:(NSData *)value;

// Default: nil
// - (id) objectForKey:(id)key;	// Already defined
- (id) objectOfClass:(Class)aClass forKey:(id)key;
// - (NSString *) stringForKey:(id)key;
// - (NSArray *) arrayForKey:(id)key;
- (NSSet *) setForKey:(id)key;
// - (NSDictionary *) dictionaryForKey:(id)key;
// - (NSData *) dataForKey:(id)key;

@end



@interface NSMutableArray (JAPropertyListAccessors)

- (void) addInteger:(long)value;
- (void) addUnsignedInteger:(unsigned long)value;
- (void) addBool:(BOOL)value;
- (void) addLongLong:(long long)value;
- (void) addUnsignedLongLong:(long long)value;
- (void) addFloat:(double)value;

- (void) insertInteger:(long)value atIndex:(unsigned long)index;
- (void) insertUnsignedInteger:(unsigned long)value atIndex:(unsigned long)index;
- (void) insertBool:(BOOL)value atIndex:(unsigned long)index;
- (void) insertLongLong:(long long)value atIndex:(unsigned long)index;
- (void) insertUnsignedLongLong:(unsigned long long)value atIndex:(unsigned long)index;
- (void) insertFloat:(double)value atIndex:(unsigned long)index;

@end



@interface NSMutableDictionary (JAPropertyListAccessors)

- (void) setInteger:(long)value forKey:(id)key;
- (void) setUnsignedInteger:(unsigned long)value forKey:(id)key;
- (void) setBool:(BOOL)value forKey:(id)key;
- (void) setLongLong:(long long)value forKey:(id)key;
- (void) setUnsignedLongLong:(unsigned long long)value forKey:(id)key;
- (void) setFloat:(double)value forKey:(id)key;

@end



@interface NSMutableSet (JAPropertyListAccessors)

- (void) addInteger:(long)value;
- (void) addUnsignedInteger:(unsigned long)value;
- (void) addBool:(BOOL)value;
- (void) addLongLong:(long long)value;
- (void) addUnsignedLongLong:(long long)value;
- (void) addFloat:(double)value;

@end



// *** Value extraction utilities ***

#ifndef JA_GCC_ATTR
#ifdef __GNUC__
#define JA_GCC_ATTR(x) __attribute__(x)
#else
#define JA_GCC_ATTR(x)
#endif
#define JA_PROPERTY_LIST_ACCESSORS_DEFINED_JA_GCC_ATTR 1
#endif


/*	Utility function to interpret a boolean. May be an NSNumber or any of the
	following strings (case-insensitive):
		yes
		true
		on
		
		no
		false
		off
*/
BOOL JABooleanFromObject(id object, BOOL defaultValue);


float JAFloatFromObject(id object, float defaultValue);
double JADoubleFromObject(id object, double defaultValue);
float JANonNegativeFloatFromObject(id object, float defaultValue);
double JANonNegativeDoubleFromObject(id object, double defaultValue);


static inline long long JAClampInteger(long long value, long long minValue, long long maxValue) JA_GCC_ATTR((always_inline));
long long JALongLongFromObject(id object, long long defaultValue);
unsigned long long JAUnsignedLongLongFromObject(id object, unsigned long long defaultValue);


static inline long long JAClampInteger(long long value, long long minValue, long long maxValue)
{
	return (minValue < value) ? ((value < maxValue) ? value : maxValue) : minValue;
}


/*	Define an inline function to clamp a give type and its unsigned
	counterpart. Example:
	
		JA_DEFINE_CLAMP_PAIR(char, Char, CHAR)
	
	expands to
	
		static inline char JACharFromObject(id object, char defaultValue)
		{
			return JAClampInteger(JALongLongFromObject(object, defaultValue), CHAR_MIN, CHAR_MAX);
		}
		static inline unsigned char JAUnsignedCharFromObject(id object, unsigned char defaultValue)
		{
			return JAClampInteger(JALongLongFromObject(object, defaultValue), 0, UCHAR_MAX);
		}
*/
#define JA_DEFINE_CLAMP(type, typeName, min, max) \
	static inline type JA ## typeName ## FromObject(id object, type defaultValue) \
	{ \
		return JAClampInteger(JALongLongFromObject(object, defaultValue), min, max); \
	}

#define JA_DEFINE_CLAMP_PAIR(type, typeName, minMaxSymb) \
	JA_DEFINE_CLAMP(type, typeName, minMaxSymb ## _MIN, minMaxSymb ## _MAX) \
	JA_DEFINE_CLAMP(unsigned type, Unsigned ## typeName, 0, U ## minMaxSymb ## _MAX)

JA_DEFINE_CLAMP_PAIR(char, Char, CHAR)
JA_DEFINE_CLAMP_PAIR(short, Short, SHRT)

/*	When ints or longs are as large as long longs, we can't do any clamping
	because the clamping code will overflow (unless we add pointless complexity).
	Instead, we alias the long long versions which don't clamp. Inlines are
	used instead of macros so that the functions always have the precise type
	they should; this is necessary for stuff that uses @encode, notably the
	SenTestingKit framework.
*/
#define JA_ALIAS_CLAMP_LONG_LONG(type, typeName) \
static inline type JA##typeName##FromObject(id object, type defaultValue) \
{ \
	return JALongLongFromObject(object, defaultValue); \
}
#define JA_ALIAS_CLAMP_PAIR_LONG_LONG(type, typeName) \
JA_ALIAS_CLAMP_LONG_LONG(type, typeName) \
JA_ALIAS_CLAMP_LONG_LONG(unsigned type, Unsigned##typeName)

#if INT_MAX == LLONG_MAX
//	Should never get here under Mac OS X, but may under GNUstep.
JA_ALIAS_CLAMP_PAIR_LONG_LONG(int, Int)
#else
JA_DEFINE_CLAMP_PAIR(int, Int, INT)
#endif

#if LONG_MAX == LLONG_MAX
JA_ALIAS_CLAMP_PAIR_LONG_LONG(long, Long)
#else
JA_DEFINE_CLAMP_PAIR(long, Long, LONG)
#endif


#undef JA_DEFINE_CLAMP
#undef JA_DEFINE_CLAMP_PAIR
#undef JA_ALIAS_CLAMP_LONG_LONG
#undef JA_ALIAS_CLAMP_PAIR_LONG_LONG
#ifdef JA_PROPERTY_LIST_ACCESSORS_DEFINED_JA_GCC_ATTR
#undef JA_PROPERTY_LIST_ACCESSORS_DEFINED_JA_GCC_ATTR
#undef JA_GCC_ATTR
#endif
