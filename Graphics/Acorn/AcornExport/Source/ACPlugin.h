#import <Cocoa/Cocoa.h>

// pass in -DDEBUG to gcc in development builds to see some output when you 
// don't feel like using a debugger.

#ifdef DEBUG
    #define debug(...) NSLog(__VA_ARGS__)
#else
    #define debug(...)
#endif

enum ACLayerType {
    ACBitmapLayer = 1,
    ACShapeLayer = 2,
} ACLayerType;

@protocol ACPluginManager

- (BOOL) addFilterMenuTitle:(NSString*)menuTitle
         withSuperMenuTitle:(NSString*)superMenuTitle
                     target:(id)target
                     action:(SEL)selector
              keyEquivalent:(NSString*)keyEquivalent
  keyEquivalentModifierMask:(unsigned int)mask
                 userObject:(id)userObject;

 - (BOOL) addActionMenuTitle:(NSString*)menuTitle
          withSuperMenuTitle:(NSString*)superMenuTitle
                      target:(id)target
                      action:(SEL)selector
               keyEquivalent:(NSString*)keyEquivalent
   keyEquivalentModifierMask:(unsigned int)mask
                  userObject:(id)userObject;

@end

@protocol ACPlugin 

/*
    This will create an instance of our plugin.  You really shouldn't need to
    worry about this at all.
*/
+ (id) plugin;

/*
    This gets called right before the plugin manager registers your plugin.
    I'm honestly not sure what you would use it for, but it seemed like a good
    idea at the time.
*/
- (void) willRegister:(id<ACPluginManager>)thePluginManager;

/*
    didRegister is called right after your plugin is all ready to go.
*/
- (void) didRegister;

@end

@protocol ACLayer <NSObject>
/* There are currently two types of layers.  "Bitmap" layers which contain pixels,
and "Shape" layers which contain Text.  And maybe other things eventually.

Check out the ACLayerType enum for the constants to tell which is which.
*/
- (int) layerType;
@end

@protocol ACShapeLayer <NSObject>
// nothing to currently see here.
@end

@protocol ACBitmapLayer <ACLayer>

// set a CIImage on the layer, to be a "preview".  Make sure to set it to nil when you are
// done with whatever it is you are doing.
- (void) setPreviewCIImage:(CIImage*)img;

// apply a ciimage to the layer.
- (void) applyCIImageFromFilter:(CIImage*)img;

// grab a CIImage representation of the layer.
- (CIImage*)CIImage;
@end

@protocol ACDocument <NSObject>

// grab an array of layers in the document.
- (NSArray*) layers;

// grab the current layer.
- (id<ACLayer>) currentLayer;

@end





/*
CTGradient is in Acorn, it's just got a different name- "TSGradient".
For more info on CTGradient, visit here:
http://blog.oofn.net/2006/01/15/gradients-in-cocoa/

You can use it like so:
id fade = [NSClassFromString(@"TSGradient") gradientWithBeginningColor:[NSColor clearColor] endingColor:[NSColor blackColor]];
*/
@interface NSObject (TSGradientTrustMeItsThere)
+ (id)gradientWithBeginningColor:(NSColor *)begin endingColor:(NSColor *)end;
- (void)fillRect:(NSRect)rect angle:(float)angle;
@end

@interface CIImage (TSNSImageAdditions)
- (NSImage *)NSImageFromRect:(CGRect)r;
- (NSImage *)NSImage;
@end
