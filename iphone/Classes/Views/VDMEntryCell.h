#import <Foundation/Foundation.h>

@interface VDMEntryCell : UITableViewCell {
	IBOutlet UITextView *textView;
	IBOutlet UILabel *youDeservedIt;
	IBOutlet UILabel *yourLifeSucks;
}

@property (nonatomic, readonly) UITextView *textView;

-(void) setDeserveCount:(int) count;
-(void) setLifeSucksCount:(int) count;

@end
