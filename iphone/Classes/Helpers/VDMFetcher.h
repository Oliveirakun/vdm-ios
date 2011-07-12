#import <Foundation/Foundation.h>

typedef void (^VDMFetcherResultAction)(NSString *, NSArray *);

@interface VDMFetcher : NSObject {

}

-(void) fetchFromURL:(NSURL *) url withCompletionBlock:(VDMFetcherResultAction) resultAction;

@end
