#import "VDMEntryCell.h"
#import "VDMEntryCellBackground.h"

@implementation VDMEntryCell
@synthesize textView;

-(void) awakeFromNib {
	self.backgroundView = [[[VDMEntryCellBackground alloc] init] autorelease];
	self.selectedBackgroundView = [[[VDMEntryCellBackground alloc] init] autorelease];
}

-(void) setDeserveCount:(int) count {
	youDeservedIt.text = [NSString stringWithFormat:@"Você mereceu (%d)", count];
}

-(void) setLifeSucksCount:(int) count {
	yourLifeSucks.text = [NSString stringWithFormat:@"Sua vida é uma merda (%d)", count];
}

-(void) dealloc {
	SafeRelease(textView);
	SafeRelease(youDeservedIt);
	SafeRelease(yourLifeSucks);
	SafeRelease(textView);
	[super dealloc];
}

@end
