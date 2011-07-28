#import <UIKit/UIKit.h>
#import "VDMEntry.h"

@interface VDMReadEntryController : UIViewController {
	IBOutlet UIWebView *comments;
	IBOutlet UITextView *contents;
	IBOutlet UILabel *yourLifeSucks;
	IBOutlet UILabel *youDeserved;
	VDMEntry *entry;
}

@property (nonatomic, assign) VDMEntry *entry;

@end
