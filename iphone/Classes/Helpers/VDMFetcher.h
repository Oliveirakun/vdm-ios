#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

typedef void (^VDMFetcherResultAction)(NSString *, NSArray *);

@interface VDMFetcher : NSObject {
	ASIHTTPRequest *request;
	BOOL running;
}

@property (nonatomic, readonly) BOOL running;
-(void) fetchFromURL:(NSURL *) url withCompletionBlock:(VDMFetcherResultAction) resultAction;

@end
