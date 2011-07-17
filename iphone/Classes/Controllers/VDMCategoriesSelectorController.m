#import "VDMCategoriesSelectorController.h"

@interface VDMCategoriesSelectorController ()
-(NSString *) normalizeCategoryName:(NSString *) value;
@end

@implementation VDMCategoriesSelectorController
@synthesize onCategorySelect;

-(void) setSelectedCategory:(NSString *) value {
	if ([NSString isStringEmpty:value]) {
		return;
	}
	
	value = [self normalizeCategoryName:value];

	for (UIButton *b in self.view.subviews) {
		if ([b isKindOfClass:[UIButton class]]) {
			if ([[self normalizeCategoryName:[b.titleLabel.text lowercaseString]] isEqualToString:value]) {
				b.backgroundColor = VDMActiveButtonColor;
				b.titleLabel.textColor = [UIColor whiteColor];
				break;
			}
		}
	}
}

-(NSString *) normalizeCategoryName:(NSString *) value {
	if ([value isEqualToString:@"solidão"]) {
		value = @"solidao";
	}
	else if ([value isEqualToString:@"família"]) {
		value = @"familia";
	}
	
	return value;
}

-(IBAction) selectCategory:(id) sender {
	UIButton *b = sender;
	
	for (UIButton *v in self.view.subviews) {
		if ([v isKindOfClass:[UIButton class]]) {
			v.backgroundColor = [UIColor whiteColor];
			v.titleLabel.textColor = [UIColor colorWithRed:50.0/255.0 green:79.0/255.0 blue:133.0/255.0 alpha:1];
		}
	}
	
	[UIView beginAnimations:nil context:b];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView setAnimationDuration:0.07];
	[UIView setAnimationRepeatAutoreverses:YES];
	[UIView setAnimationRepeatCount:4];
	b.backgroundColor = VDMActiveButtonColor;
	[UIView commitAnimations];
}

-(void) animationDidStop:(NSString *) animationId finished:(BOOL) finished context:(void *) context {
	UIButton *b = context;
	b.titleLabel.textColor = [UIColor whiteColor];
	
	if (onCategorySelect) {
		NSString *s = [self normalizeCategoryName:[b.titleLabel.text lowercaseString]];
		onCategorySelect(s);
	}
}

- (void)dealloc {
	SafeRelease(onCategorySelect);
	[super dealloc];
}

@end
