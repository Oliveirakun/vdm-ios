#import <Foundation/Foundation.h>

@interface VDMEntryCell : UITableViewCell {
	IBOutlet UITextView *textView;
	IBOutlet UIButton *button1;
}

@property (nonatomic, readonly) UIButton *button1;
@property (nonatomic, readonly) UITextView *textView;

-(IBAction) b1:(id) sender;

@end
