#import <UIKit/UIKit.h>

@interface VDMController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView *tableView;
	NSMutableArray *entries;
}

@end
