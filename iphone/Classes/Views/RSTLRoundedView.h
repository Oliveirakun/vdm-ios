#import <Foundation/Foundation.h>

@interface RSTLRoundedView : UIView {
	int cornerRadius;
}

@property (nonatomic, assign) int cornerRadius;

-(id) initWithRadius:(int) radius andColor:(UIColor *) color;

@end
