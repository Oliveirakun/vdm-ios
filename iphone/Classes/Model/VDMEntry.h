#import <Foundation/Foundation.h>

@interface VDMEntry : NSObject {
	NSString *contents;
	int entryId;
	int aggreeCount;
	int deserveCount;
	int commentsCount;
}

@property (nonatomic, assign) int entryId;
@property (nonatomic, assign) int commentsCount;
@property (nonatomic, assign) int aggreeCount;
@property (nonatomic, assign) int deserveCount;
@property (nonatomic, retain) NSString *contents;

@end
