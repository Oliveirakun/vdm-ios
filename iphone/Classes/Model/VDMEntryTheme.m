#import "VDMEntryTheme.h"

@implementation VDMEntryTheme
@synthesize themeId, name, description;

-(void) dealloc {
	SafeRelease(name);
	SafeRelease(description);
	[super dealloc];
}
@end
