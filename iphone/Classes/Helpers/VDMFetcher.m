#import "VDMFetcher.h"
#import "VDMEntryXMLParser.h"

@implementation VDMFetcher
@synthesize running;

-(void) fetchFromURL:(NSURL *) url withCompletionBlock:(VDMFetcherResultAction) resultAction {
	[request clearDelegatesAndCancel];
	SafeRelease(request);

	request = [[ASIHTTPRequest requestWithURL:url] retain];
	[request setTimeOutSeconds:30];
	[request setCompletionBlock:^{
		running = NO;
		if ([request error]) {
			resultAction([[request error] localizedDescription], nil);
		}
		else {
			VDMEntryXMLParser *parser = [[VDMEntryXMLParser alloc] init];
			NSArray *entries = [[parser parse:[request responseString]] retain];
			SafeRelease(parser);
			resultAction(nil, entries);
		}
	}];
	running = YES;
	[request startAsynchronous];
}

-(void) dealloc {
	[request clearDelegatesAndCancel];
	SafeRelease(request);
	[super dealloc];
}

@end
