#import <UIKit/UIKit.h>
#import "VDMEntry.h"

@interface VDMReadEntryController : UIViewController {
	IBOutlet UIWebView *comments;
	IBOutlet UITextView *contents;
	VDMEntry *entry;
	UILabel *commentsLabel;
}

@property (nonatomic, assign) VDMEntry *entry;

@end
