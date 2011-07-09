#import <Foundation/Foundation.h>

@interface RSTLTintedBarButtonItem : UIBarButtonItem {

}

-(void) changeColor:(UIColor *) newColor;
+(RSTLTintedBarButtonItem *) buttonWithText:(NSString *) text andColor:(UIColor *) color;

@end
