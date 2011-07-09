#import <UIKit/UIKit.h>

@interface VDMController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView *tableView;
	NSMutableArray *entries;
}

-(IBAction) recentsDidSelect:(id) sender;
-(IBAction) randomDidSelect:(id) sender;
-(IBAction) categoryDidSelect:(id) sender;

@end
