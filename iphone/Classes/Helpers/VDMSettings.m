#import "VDMSettings.h"

@implementation VDMSettings
@synthesize entries;

-(id) init {
	if (self = [super init]) {
		NSString *path = ResourcePath(@"VDMSettings.plist");
		entries = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
	}
	
	return self;
}

-(NSString *) baseURL {
	return [entries objectForKey:@"baseURL"];
}

+(VDMSettings *) instance {
	static VDMSettings *instance;
	
	if (!instance) {
		instance = [[VDMSettings alloc] init];
	}
	
	return instance;
}

-(void) dealloc {
	SafeRelease(entries);
	[super dealloc];
}

@end
