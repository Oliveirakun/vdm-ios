#import <Foundation/Foundation.h>

@interface VDMSettings : NSObject {
	NSMutableDictionary *entries;
}

@property (nonatomic, readonly) NSMutableDictionary *entries;
+(VDMSettings *) instance;
-(NSString *) baseURL;

@end
