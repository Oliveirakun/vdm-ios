#import "VDMController.h"
#import "VDMEntryCell.h"
#import "VDMEntry.h"
#import "RSTLTintedBarButtonItem.h"
#import "VDMSettings.h"
#import "RSTLRoundedView.h"
#import "VDMCategoriesSelectorController.h"

@interface VDMController()
-(void) fetchEntriesXML:(NSString *) path;
-(void) setActiveButton:(UISegmentedControl *) newActiveButton;
-(void) createToolbarItems;
-(UIView *) createLoadingView;
@end

@implementation VDMController

-(void) viewDidLoad {
	[self fetchEntriesXML:@"/page/1.xml"];
	[self createToolbarItems];
	[self setActiveButton:[(RSTLTintedBarButtonItem *)[self.toolbarItems objectAtIndex:1] innerButton]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)dealloc {
	SafeRelease(tableView);
	SafeRelease(vdmFetcher);
	[super dealloc];
}

-(void) createToolbarItems {
	// Create customizable toolbar items by hands, as Apple loves to make our lives difficult
	RSTLTintedBarButtonItem *recentsButton = [RSTLTintedBarButtonItem buttonWithText:@"Recentes" andColor:[UIColor blackColor]];
	[recentsButton setAction:@selector(recentsDidSelect:) atTarget:self];
	
	RSTLTintedBarButtonItem *randomButton = [RSTLTintedBarButtonItem buttonWithText:@"Aleatórias" andColor:[UIColor blackColor]];
	[randomButton setAction:@selector(randomDidSelect:) atTarget:self];
	
	RSTLTintedBarButtonItem *categoryButton = [RSTLTintedBarButtonItem buttonWithText:@"Categoria" andColor:[UIColor blackColor]];
	[categoryButton setAction:@selector(categoryDidSelect:) atTarget:self];
	
	UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[self setToolbarItems:[NSArray arrayWithObjects:flexibleSpace, recentsButton, randomButton, categoryButton, flexibleSpace, nil]];
}

-(UIView *) createLoadingView {
	RSTLRoundedView *roundedView = [[[RSTLRoundedView alloc] initWithFrame:CGRectMake(0, 0, self.view.width - 100, 100)] autorelease];
	UIActivityIndicatorView *snipping = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
	[snipping setSize:CGSizeMake(32, 32)];
	[snipping startAnimating];
	UIFont *messageFont = [UIFont systemFontOfSize:14];
	NSString *message = @"Carregando VDMs";
	float messageWidth = [message sizeWithFont:messageFont constrainedToSize:CGSizeMake(roundedView.width, roundedView.height) lineBreakMode:UILineBreakModeWordWrap].width;
	
	snipping.x = (roundedView.width - (snipping.width + 5 + messageWidth)) / 2;
	snipping.y = (roundedView.height - snipping.height) / 2;

	UILabel *messageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(snipping.rightX + 5, (roundedView.height - 20) / 2, messageWidth, 20)] autorelease];
	messageLabel.backgroundColor = [UIColor clearColor];
	messageLabel.textColor = [UIColor whiteColor];
	messageLabel.font = messageFont;
	messageLabel.text = message;
	
	[roundedView addSubview:snipping];
	[roundedView addSubview:messageLabel];
	
	roundedView.autoresizingMask = MASK_FLEXIBLE_MARGINS;
	[roundedView setOrigin:CGPointMake((self.view.width - roundedView.width) / 2, (self.view.height - roundedView.height) / 2)];
	
	return roundedView;
}

-(IBAction) recentsDidSelect:(id) sender {
	[self fetchEntriesXML:@"/page/1.xml"];
	[self setActiveButton:sender];
}

-(IBAction) randomDidSelect:(id) sender {
	[self setActiveButton:sender];
}

-(IBAction) categoryDidSelect:(id) sender {
	//[self fetchEntriesXML:@"/trabalho.xml"];
	[self setActiveButton:sender];
	
	__block VDMCategoriesSelectorController *c = [[VDMCategoriesSelectorController alloc] init];
	c.contentSizeForViewInPopover = c.view.frame.size;
	c.onCategorySelect = ^(void *categoryName) {
		[categoriesPopover dismissPopoverAnimated:YES];
		[self fetchEntriesXML:[NSString stringWithFormat:@"/%@.xml", categoryName]];
	};
	
	categoriesPopover = [[WEPopoverController alloc] initWithContentViewController:c];
	[categoriesPopover presentPopoverFromRect:CGRectMake(self.view.width - 100, self.view.height
	, 50, 50) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
	SafeRelease(c);
}

-(void) setActiveButton:(UISegmentedControl *) newActiveButton {
	for (RSTLTintedBarButtonItem *b in self.toolbarItems) {
		if ([b isKindOfClass:[RSTLTintedBarButtonItem class]]) {
			b.innerButton.tintColor = [UIColor blackColor];
		}
	}
	
	newActiveButton.tintColor = VDMActiveButtonColor;
}

#pragma mark -
#pragma mark VDMs download
-(void) removeOldEntries {
	NSMutableArray *indexPaths = [NSMutableArray array];
	
	for (int i = 0; i < entries.count; i++) {
		[indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
	}
	
	SafeRelease(entries);
	[tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationRight];
}

-(void) addNewEntries {
	NSMutableArray *indexPaths = [NSMutableArray array];
	
	for (int i = 0; i < entries.count; i++) {
		[indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
	}

	[tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
}

-(void) fetchEntriesXML:(NSString *) path {
	UIView *loadingView = [self createLoadingView];
	[self.view addSubviewAnimated:loadingView];

	if (!vdmFetcher) {
		vdmFetcher = [[VDMFetcher alloc] init];
	}
	
	[self removeOldEntries];
	
	NSURL *url = [[NSString stringWithFormat:@"%@%@%@bypass_mobile=1", [[VDMSettings instance] baseURL], 
		path, [path contains:@"?"] ? @"&" : @"?"] toURL];
	
	[vdmFetcher fetchFromURL:url
		withCompletionBlock:^(NSString *errorMessage, NSArray *result) {
			if (![NSString isStringEmpty:errorMessage]) {
				ShowAlert(@"Erro", errorMessage);
			}
			else {
				entries = [result retain];
				[self addNewEntries];
			}
			
			[loadingView removeFromSuperviewAnimated];
	}];
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
		cell.textView.font = [UIFont fontWithName:@"Verdana" size:12];
	}

	VDMEntry *entry = [entries objectAtIndex:indexPath.row];
	cell.textView.text = entry.contents;

	return cell;
}

@end
