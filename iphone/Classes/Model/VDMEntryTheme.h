#import <Foundation/Foundation.h>

@interface VDMEntryTheme : NSObject {
	int themeId;
	NSString *name;
	NSString *description;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, assign) int themeId;

@end
