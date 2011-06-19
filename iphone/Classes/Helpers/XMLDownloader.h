#import <Foundation/Foundation.h>
#import "XMLParser.h"

@interface XMLDownloader : NSObject {
	id delegate;
	SEL onDownloadComplete;
	Class<XMLParser> xmlParser;
}

@property (nonatomic, assign) Class<XMLParser> xmlParser;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL onDownloadComplete;

-(void) fetchContents:(NSURL *) url;

@end
