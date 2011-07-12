#import <UIKit/UIKit.h>
#import "VDMFetcher.h"

@interface VDMController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView *tableView;
	NSMutableArray *entries;
	VDMFetcher *vdmFetcher;
}

-(IBAction) recentsDidSelect:(id) sender;
-(IBAction) randomDidSelect:(id) sender;
-(IBAction) categoryDidSelect:(id) sender;

@end
