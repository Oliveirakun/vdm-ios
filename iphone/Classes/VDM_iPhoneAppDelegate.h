#import <UIKit/UIKit.h>

@interface VDM_iPhoneAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
	UINavigationController *navController;
	NSAutoreleasePool *pool;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navController;

@end
