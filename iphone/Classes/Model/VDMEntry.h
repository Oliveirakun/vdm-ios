#import <Foundation/Foundation.h>

@interface VDMEntry : NSObject {
	NSString *contents;
	NSString *link;
}

@property (nonatomic, retain) NSString *contents;
@property (nonatomic, retain) NSString *link;

@end
