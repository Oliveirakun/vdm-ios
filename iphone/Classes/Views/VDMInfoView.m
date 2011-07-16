#import "VDMInfoView.h"
#import <QuartzCore/QuartzCore.h>

@implementation VDMInfoView

-(void) awakeFromNib {
	self.layer.cornerRadius = 8;
	self.alpha = 0;
	contentView = [self.subviews objectAtIndex:0];
	contentView.layer.cornerRadius = 8;
	originalY = contentView.y;
	[contentView setY:self.height];
	appDescription.font = [UIFont systemFontOfSize:13];
}

-(void) didMoveToSuperview {
	if (self.superview) {
		[UIView animateWithDuration:0.3 animations:^{
			self.alpha = 1;
		} completion:^(BOOL finished) {
			// Bounce the content view
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDelay:0.2];
			[UIView setAnimationDuration:0.2];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
			[contentView setY:originalY];
			[UIView commitAnimations];
			
			CABasicAnimation *bounceAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
			bounceAnimation.duration = 0.2;
			bounceAnimation.fromValue = [NSNumber numberWithInt:0];
			bounceAnimation.toValue = [NSNumber numberWithInt:20];
			bounceAnimation.repeatCount = 2;
			bounceAnimation.autoreverses = YES;
			bounceAnimation.fillMode = kCAFillModeForwards;
			bounceAnimation.removedOnCompletion = NO;
			bounceAnimation.additive = YES;
			[contentView.layer addAnimation:bounceAnimation forKey:@"bounceAnimation"];
		}];
	}
}

-(IBAction) close:(id) sender {
	[UIView animateWithDuration:0.3 animations:^{
		self.alpha = 0;
	} completion:^(BOOL finished) {
		[self removeFromSuperview];
	}];
}

@end
