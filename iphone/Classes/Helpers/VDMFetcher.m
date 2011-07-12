#import "VDMFetcher.h"
#import "ASIHTTPRequest.h"
#import "VDMEntryXMLParser.h"

@implementation VDMFetcher

-(void) fetchFromURL:(NSURL *) url withCompletionBlock:(VDMFetcherResultAction) resultAction {
	__block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setCompletionBlock:^{
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
	[request startAsynchronous];
}

@end
