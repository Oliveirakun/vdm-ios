#import <Foundation/Foundation.h>
#import "VDMEntry.h"

@interface VDMEntryCell : UITableViewCell {
	IBOutlet UITextView *textView;
	IBOutlet UIButton *yourLifeSucks;
	IBOutlet UIButton *youDeservedIt;
	VDMEntry *entry;
}

@property (nonatomic, assign) VDMEntry *entry;
@property (nonatomic, readonly) UITextView *textView;

-(void) setDeserveCount:(int) count;
-(void) setLifeSucksCount:(int) count;

-(IBAction) vote:(UIButton *) sender;

@end
