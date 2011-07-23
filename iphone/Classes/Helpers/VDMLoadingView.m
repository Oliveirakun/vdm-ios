#import "VDMLoadingView.h"
#import "RSTLRoundedView.h"

@implementation VDMLoadingView
@synthesize autoCenterOnScreen;

-(void) didMoveToSuperview {
	if (self.superview && self.autoCenterOnScreen) {
		[self setOrigin:CGPointMake((self.superview.width - self.width) / 2, (self.superview.height - self.height) / 2)];
	}
}

+(VDMLoadingView *) loadingViewWithSize:(CGSize) size message:(NSString *) message {
	RSTLRoundedView *roundedView = [[[RSTLRoundedView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)] autorelease];
	UIActivityIndicatorView *snipping = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
	[snipping setSize:CGSizeMake(24, 24)];
	[snipping startAnimating];
	UIFont *messageFont = [UIFont systemFontOfSize:14];
	float messageWidth = [message sizeWithFont:messageFont constrainedToSize:CGSizeMake(roundedView.width, roundedView.height) lineBreakMode:UILineBreakModeWordWrap].width;
	
	snipping.x = (roundedView.width - (snipping.width + 5 + messageWidth)) / 2;
	snipping.y = (roundedView.height - snipping.height) / 2;
	
	UILabel *messageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(snipping.rightX + 5, (roundedView.height - 20) / 2, messageWidth, 20)] autorelease];
	messageLabel.backgroundColor = [UIColor clearColor];
	messageLabel.textColor = [UIColor whiteColor];
	messageLabel.font = messageFont;
	messageLabel.text = message;
	
	[roundedView addSubview:snipping];
	[roundedView addSubview:messageLabel];
	
	roundedView.autoresizingMask = MASK_FLEXIBLE_MARGINS;
	
	VDMLoadingView *v = [[[VDMLoadingView alloc] init] autorelease];
	v.autoresizingMask = MASK_FLEXIBLE_MARGINS;
	[v setSize:size];
	[v addSubview:roundedView];
	
	return v;
}

@end
