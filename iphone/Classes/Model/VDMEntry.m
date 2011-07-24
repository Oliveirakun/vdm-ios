#import "VDMEntry.h"

@implementation VDMEntry
@synthesize contents, entryId, agreeCount, deserveCount, commentsCount, 
	agreeVoted, deserveVoted;

-(void) dealloc {
	SafeRelease(contents);
	[super dealloc];
}

@end
