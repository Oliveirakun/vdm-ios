// Executes a code withing an animation block
#define ANIMATE(...) {\
	[UIView beginAnimations:nil context:nil];\
	__VA_ARGS__\
	[UIView commitAnimations];\
}

#define MASK_FLEXIBLE_SIZE UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth
#define MASK_FLEXIBLE_MARGINS UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin

// Full path to application's root directory
#define BUNDLE_PATH [[NSBundle mainBundle] bundlePath]

// Documents directory full path
#define DocumentsDirectoryPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

// Given a resource name, returns its fullpath 
#define ResourcePath(__RP__) [[NSBundle mainBundle] pathForResource:__RP__ ofType:nil]

// Loads a view from a xib file
#define LoadViewNib(__NIBNAME__) [[[NSBundle mainBundle] loadNibNamed:__NIBNAME__ owner:self options:nil] objectAtIndex:0]

// Create NSNumber's from primivite types
#define ToLong(__N__) [NSNumber numberWithLong:__N__]
#define ToInteger(__N__) [NSNumber numberWithInt:__N__]
#define ToBoolean(__N__) [NSNumber numberWithBool:__N__]
#define ToString(__N__) [NSString stringWithFormat:@"%d", __N__]

// Releases an object and sets it to nil
#define SafeRelease(__POINTER) { [__POINTER release]; __POINTER = nil; }

#define VDMActiveButtonColor [UIColor colorWithRed:207.0/225.0 green:19.0/225.0 blue:67.0/225.0 alpha:1]
