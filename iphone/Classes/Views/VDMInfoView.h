#import <Foundation/Foundation.h>

@interface VDMInfoView : UIView {
	UIView *contentView;
	float originalY;
	IBOutlet UITextView *appDescription;
}

-(IBAction) close:(id) sender;

@end
