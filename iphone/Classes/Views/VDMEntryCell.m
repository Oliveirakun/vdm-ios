#import "VDMEntryCell.h"

@implementation VDMEntryCell
@synthesize textView, button1;

-(void) dealloc {
	SafeRelease(textView);
	[super dealloc];
}

-(IBAction) b1:(id) sender {
	NSLog(@"aaa");
}

@end
