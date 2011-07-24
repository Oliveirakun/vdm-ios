#import <Foundation/Foundation.h>

@interface VDMEntry : NSObject {
	NSString *contents;
	int entryId;
	int agreeCount;
	int deserveCount;
	int commentsCount;
	BOOL agreeVoted;
	BOOL deserveVoted;
}

@property (nonatomic, assign) BOOL deserveVoted;
@property (nonatomic, assign) BOOL agreeVoted;
@property (nonatomic, assign) int entryId;
@property (nonatomic, assign) int commentsCount;
@property (nonatomic, assign) int agreeCount;
@property (nonatomic, assign) int deserveCount;
@property (nonatomic, retain) NSString *contents;

@end
