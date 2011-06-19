#import <UIKit/UIKit.h>

@protocol XMLParser<NSObject>
-(NSArray *) parse:(NSString *)xmlContents;
@end
