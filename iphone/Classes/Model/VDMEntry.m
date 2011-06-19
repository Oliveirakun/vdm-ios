#import "VDMEntry.h"

@implementation VDMEntry
@synthesize contents, link;

-(void) dealloc {
	SafeRelease(contents);
	SafeRelease(link);
	[super dealloc];
}

@end
