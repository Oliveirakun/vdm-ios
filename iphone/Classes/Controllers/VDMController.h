#import <UIKit/UIKit.h>
#import "VDMFetcher.h"
#include "WEPopoverController.h"

typedef enum {
	VDMEntryTypeRecent,
	VDMEntryTypeCategory,
	VDMEntryTypeRandom
} VDMEntryType;

@interface VDMController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView *tableView;
	NSMutableArray *entries;
	VDMFetcher *vdmFetcher;
	WEPopoverController *categoriesPopover;
	int currentPage;
	NSString *currentCategory;
	BOOL loadingExtra;
	UIView *loadingExtraMessageView;
	BOOL isFirstLoad;
	VDMEntryType currentEntryType;
}

-(IBAction) recentsDidSelect:(id) sender;
-(IBAction) randomDidSelect:(id) sender;
-(IBAction) categoryDidSelect:(id) sender;

@end
