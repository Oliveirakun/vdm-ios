#import "RSTLRoundedView.h"
#import <QuartzCore/QuartzCore.h>

@implementation RSTLRoundedView
@synthesize cornerRadius;

-(void) setupDefaults {
	[self setCornerRadius:10];
	self.backgroundColor = [UIColor colorWithRed:45.0/255.0 green:45.0/255.0 blue:45.0/255.0 alpha:0.8];
}

-(void) awakeFromNib {
	[self setupDefaults];
}

-(id) init {
	if (self = [super init]) {
		[self setupDefaults];
	}
	
	return self;
}

-(id) initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self setupDefaults];
	}
	
	return self;
}

-(id) initWithRadius:(int) radius andColor:(UIColor *) color {
	if (self = [super init]) {
		[self setCornerRadius:radius];
		self.backgroundColor = color;
	}
	
	return self;
}

-(void) setCornerRadius:(int) radius {
	self.layer.cornerRadius = radius;
}

@end
