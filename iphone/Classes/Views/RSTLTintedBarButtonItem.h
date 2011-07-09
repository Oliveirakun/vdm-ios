#import <Foundation/Foundation.h>

@interface RSTLTintedBarButtonItem : UIBarButtonItem {

}

-(void) changeColor:(UIColor *) newColor;
-(void) setAction:(SEL) action atTarget:(id) target;
-(UISegmentedControl *) innerButton;
+(RSTLTintedBarButtonItem *) buttonWithText:(NSString *) text andColor:(UIColor *) color;

@end
