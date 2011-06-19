#import <Foundation/Foundation.h>

@interface XMLDownloader : NSObject {
	id delegate;
	SEL onDownloadComplete;
	Class xmlParser;
}

@property (nonatomic, assign) Class xmlParser;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL onDownloadComplete;

-(void) fetchContents:(NSURL *) url;

@end
