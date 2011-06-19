#import "GATracker.h"
#import "GANTracker.h"

@implementation GATracker

+(void) trackPageView:(NSString *) path {
	NSError *error = nil;
	
	if (![[GANTracker sharedTracker] trackPageview:path withError:&error]) {
		NSLog(@"Error tracking GA: %@", [error localizedDescription]);
		
		if ([[error localizedDescription] rangeOfString:@"GANPersistentEventStoreError"].location != NSNotFound) {
			// Sometimes the .sqlite file gets corrupted, so erase it to start over again
			[[NSFileManager defaultManager] removeItemAtPath:[DocumentsDirectoryPath stringByAppendingPathComponent:@"googleanalytics.sql"] error:nil];
		}
	}
}

+(void) trackEvent:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSInteger)value {
	NSLog(@"track event category %@ action %@ label %@ value %d", category, action, label, value);

	NSError *error = nil;

	if (![[GANTracker sharedTracker] trackEvent:category action:action label:label value:value withError:&error]) {
		NSLog(@"Error tracking GA event: %@", [error localizedDescription]);
	}
}

@end
