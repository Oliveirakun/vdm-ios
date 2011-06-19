#import "VDMController.h"
#import "VDMEntryCell.h"
#import "VDMRSSParser.h"
#import "VDMEntry.h"
#import "ASIHTTPRequest.h"

@implementation VDMController

-(void) viewDidLoad {
	entries = [[NSMutableArray alloc] initWithObjects:@"Conteudo 1 Conteudo 1 Conteudo 1 Conteudo 1 Conteudo 1 Conteudo 1 Conteudo 1 Conteudo 1 Conteudo 1 Conteudo 1 ", @"Conteudo 2 Conteudo 2 Conteudo 2 Conteudo 2 ", @"Conteudo 3", @"Conteudo 4", nil];
	[self performSelectorInBackground:@selector(fetchRSS) withObject:nil];
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
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://feeds.feedburner.com/vidademerda?format=xml"]];
	[request startSynchronous];
	
	if ([request error]) {
		NSLog(@"Error fetching rss: %@", [[request error] localizedDescription]);
	}
	else {
		VDMRSSParser *parser = [[VDMRSSParser alloc] init];
		NSArray *items = [parser parse:[request responseString]];
		
		for (VDMEntry *entry in items) {
			NSLog(@"%@\n", entry.contents);
		}
		
		SafeRelease(parser);
	}
	
	[pool drain];
}

#pragma mark -
#pragma mark UITableViewDelegate
-(void) tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *s = [entries objectAtIndex:indexPath.row];
	return [s sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(tableView.width, 200) lineBreakMode:UILineBreakModeWordWrap].height + 60;
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
		cell.textView.font = [UIFont systemFontOfSize:17];
	}

	cell.textView.text = [entries objectAtIndex:indexPath.row];

	return cell;
}

@end
