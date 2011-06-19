#import <Foundation/Foundation.h>

@interface GATracker : NSObject {

}

+(void) trackPageView:(NSString *) path;
+(void) trackEvent:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSInteger)value;

@end
