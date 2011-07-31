#import "VDM_iPhoneAppDelegate.h"
#import "GANTracker.h"
#import "GATracker.h"
#import "Appirater.h"

@implementation VDM_iPhoneAppDelegate
@synthesize window, navController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	pool = [[NSAutoreleasePool alloc] init];
	
	[[GANTracker sharedTracker] startTrackerWithAccountID:@"UA-7709214-3" dispatchPeriod:30 delegate:nil];
	
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
	
	[GATracker trackPageView:@"/app_start"];
	[Appirater appLaunched];

    return YES;
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[pool drain];
	pool = [[NSAutoreleasePool alloc] init];
}

- (void)dealloc {
	[[GANTracker sharedTracker] stopTracker];
    [navController release];
    [window release];
    [super dealloc];
}

@end

