#import <UIKit/UIKit.h>

@protocol XMLParser<NSObject>
-(BOOL) parse:(NSString *)xmlContents;
-(NSArray *) items;
@end
