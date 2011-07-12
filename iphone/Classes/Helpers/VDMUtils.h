#import <Foundation/Foundation.h>

void ShowAlert(NSString *title, NSString *message);

// UIView Categegories
@interface UIView (RSTLAditions)
-(void) setOrigin:(CGPoint) newOrigin;
-(void) setSize:(CGSize) newSize;
-(void) setHeight:(float) newHeight;
-(void) setWidth:(float) newWidth;
-(void) setX:(float) newX;
-(void) setY:(float) newY;
-(float) height;
-(float) width;
-(float) x;
-(float) rightX;
-(float) y;
-(float) lowerY;
-(void) addTapGesture:(id) target action:(SEL) action tapCount:(int) tapCount;
-(void) clearGestureRecognizers;
-(void) removeFromSuperviewAnimated;
-(void) addSubviewAnimated:(UIView *)view;
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
