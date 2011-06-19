#import <Foundation/Foundation.h>

// UIView Categegories
@interface UIView (FrameAditions)
-(void) setOrigin:(CGPoint) newOrigin;
-(void) setSize:(CGSize) newSize;
-(void) setHeight:(float) newHeight;
-(void) setWidth:(float) newWidth;
-(void) setX:(float) newX;
-(void) setY:(float) newY;
-(float) height;
-(float) width;
-(float) x;
-(float) y;
-(float) lowerY;
-(void) addTapGesture:(id) target action:(SEL) action tapCount:(int) tapCount;
-(void) clearGestureRecognizers;
@end

// NSString Categories
@interface NSString (Additions) 
+(BOOL) isStringEmpty:(NSString *)s;
-(NSURL *) toURL;
-(NSURL *) toFileURL;
-(BOOL) containsString:(NSString *) s;
@end

// UIResponder Categories
@interface UIResponder (Additions)
-(UIViewController *) parentController;
-(UIViewController *) findControllerWithNavigationController;
-(UIViewController *) findTopRootViewController;
@end

// UIWebView Categories
@interface UIWebView (Additions)
-(void) disableScrollShadow;
-(void) disableBounce;
@end
