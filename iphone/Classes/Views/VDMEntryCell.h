#import <Foundation/Foundation.h>
#import "VDMEntry.h"

@interface VDMEntryCell : UITableViewCell {
	IBOutlet UITextView *textView;
	IBOutlet UILabel *youDeservedIt;
	IBOutlet UILabel *yourLifeSucks;
	VDMEntry *entry;
}

@property (nonatomic, assign) VDMEntry *entry;
@property (nonatomic, readonly) UITextView *textView;

-(void) setDeserveCount:(int) count;
-(void) setLifeSucksCount:(int) count;

@end
