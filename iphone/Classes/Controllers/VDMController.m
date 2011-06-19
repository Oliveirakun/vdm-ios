#import "VDMController.h"

@implementation VDMController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)didReceiveMemoryWarning {
}

- (void)dealloc {
	SafeRelease(tableView);
	[super dealloc];
}

#pragma mark -
#pragma mark UITableViewDelegate
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
}

#pragma mark -
#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 0;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

@end
