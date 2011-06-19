#import "VDMController.h"
#import "VDMEntryCell.h"
#import "VDMRSSParser.h"
#import "VDMEntry.h"
#import "ASIHTTPRequest.h"

@interface VDMController()
-(void) fetchRSS;
@end

@implementation VDMController

-(void) viewDidLoad {
	[self fetchRSS];
}

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
#pragma mark VDMs download
-(void) fetchRSS {
	__block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://feeds.feedburner.com/vidademerda?format=xml"]];
	[request setCompletionBlock:^{
		if ([request error]) {
			ShowAlert(@"Erro", [[request error] localizedDescription]);
		}
		else {
			VDMRSSParser *parser = [[VDMRSSParser alloc] init];
			entries = [[parser parse:[request responseString]] retain];
			SafeRelease(parser);
			
			[tableView reloadData];
		}
	}];
	
	[request startAsynchronous];
}

#pragma mark -
#pragma mark UITableViewDelegate
-(void) tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	VDMEntry *entry = [entries objectAtIndex:indexPath.row];
	return [entry.contents sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(tableView.width, 250) lineBreakMode:UILineBreakModeWordWrap].height + 50;
}

#pragma mark -
#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return entries.count;
}

-(UITableViewCell *) tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellId = @"CellId";
	
	VDMEntryCell *cell = (VDMEntryCell *)[tableView dequeueReusableCellWithIdentifier:CellId];
	
	if (!cell) {
		cell = LoadViewNib(@"VDMEntryCell");
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.textView.font = [UIFont systemFontOfSize:14];
	}

	VDMEntry *entry = [entries objectAtIndex:indexPath.row];
	cell.textView.text = entry.contents;

	return cell;
}

@end
