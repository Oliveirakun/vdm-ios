#import <UIKit/UIKit.h>
#import "VDMEntry.h"

@interface VDMAddCommentController : UIViewController<UITextViewDelegate> {
	IBOutlet UITextView *comment;
	IBOutlet UITextField *username;
	VDMEntry *entry;
}

@property (nonatomic, assign) VDMEntry *entry;

@end
