#import <UIKit/UIKit.h>
#import "VDMEntryTheme.h"

@interface VDMAddEntryController : UIViewController<UITextViewDelegate> {
	IBOutlet UITextView *textView;
	UILabel *counterLabel;
	UILabel *themeLabel;
}

@end
