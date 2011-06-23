#import "VDMEntry.h"

@implementation VDMEntry
@synthesize contents, entryId, aggreeCount, deserveCount, commentsCount;

-(void) dealloc {
	SafeRelease(contents);
	[super dealloc];
}

@end
