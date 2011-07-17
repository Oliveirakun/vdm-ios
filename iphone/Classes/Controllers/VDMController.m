#import "VDMController.h"
#import "VDMEntryCell.h"
#import "VDMEntry.h"
#import "RSTLTintedBarButtonItem.h"
#import "VDMSettings.h"
#import "RSTLRoundedView.h"
#import "VDMCategoriesSelectorController.h"
#import "VDMInfoView.h"

#define RECENTS_VDMS_PATH [NSString stringWithFormat:@"/page/%d.xml", currentPage]
#define CATEGORY_VDMS_PATH [NSString stringWithFormat:@"/%@.xml?page=%d", currentCategory, currentPage]

@interface VDMController()
-(void) fetchEntriesXML:(NSString *) path;
-(void) setActiveButton:(UISegmentedControl *) newActiveButton;
-(void) createToolbarItems;
-(UIView *) createLoadingView;
-(void) removeOldEntries;
-(void) addNavigationButtons;
@end

@implementation VDMController

-(void) viewDidLoad {
	currentPage = 1;
	isFirstLoad = YES;
	[self createToolbarItems];
	[self setActiveButton:[(RSTLTintedBarButtonItem *)[self.toolbarItems objectAtIndex:1] innerButton]];
	[self addNavigationButtons];
	[self fetchEntriesXML:RECENTS_VDMS_PATH];
}

-(void) addNavigationButtons {
	// Logo
	self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vdm_logo_small.png"]] autorelease];
	
	// Application info
	UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight]; 
	[infoButton addTarget:self action:@selector(infoButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:infoButton] autorelease];
}

-(void) infoButtonTouch:(id) sender {
	VDMInfoView *infoView = LoadViewNib(@"VDMInfoView");
	infoView.center = self.view.center;
	[self.view addSubview:infoView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
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
	
	RSTLTintedBarButtonItem *categoryButton = [RSTLTintedBarButtonItem buttonWithText:@"Temas" andColor:[UIColor blackColor]];
	[categoryButton setAction:@selector(categoryDidSelect:) atTarget:self];
	
	UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[self setToolbarItems:[NSArray arrayWithObjects:flexibleSpace, recentsButton, randomButton, categoryButton, flexibleSpace, nil]];
}

-(UIView *) createLoadingView {
	float height = isFirstLoad ? 100 : 50;
	RSTLRoundedView *roundedView = [[[RSTLRoundedView alloc] initWithFrame:CGRectMake(0, 0, self.view.width - 100, height)] autorelease];
	UIActivityIndicatorView *snipping = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
	[snipping setSize:CGSizeMake(24, 24)];
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
	float y = isFirstLoad ? (self.view.height - roundedView.height) / 2 : 10;
	[roundedView setOrigin:CGPointMake((self.view.width - roundedView.width) / 2, y)];
	
	return roundedView;
}

-(IBAction) recentsDidSelect:(id) sender {
	currentPage = 1;
	isFirstLoad = YES;
	[self removeOldEntries];
	[self fetchEntriesXML:RECENTS_VDMS_PATH];
	[self setActiveButton:sender];
}

-(IBAction) randomDidSelect:(id) sender {
	[self setActiveButton:sender];
}

-(IBAction) categoryDidSelect:(id) sender {
	[self setActiveButton:sender];
	
	__block VDMCategoriesSelectorController *c = [[VDMCategoriesSelectorController alloc] init];
	c.contentSizeForViewInPopover = c.view.frame.size;
	c.onCategorySelect = ^(void *categoryName) {
		[categoriesPopover dismissPopoverAnimated:YES];
		currentCategory = [(NSString *)categoryName retain];
		currentPage = 1;
		isFirstLoad = YES;
		[self removeOldEntries];
		[self fetchEntriesXML:CATEGORY_VDMS_PATH];
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

-(void) addNewEntries:(BOOL) animated {
	NSMutableArray *indexPaths = [NSMutableArray array];
	
	for (int i = [tableView numberOfRowsInSection:0]; i < entries.count; i++) {
		NSLog(@"Adicionando %d", i);
		[indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
	}

	[tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:animated ? UITableViewRowAnimationLeft : UITableViewRowAnimationNone];
}

-(void) fetchEntriesXML:(NSString *) path {
	UIView *loadingView = [self createLoadingView];
	[self.view addSubviewAnimated:loadingView];

	if (!vdmFetcher) {
		vdmFetcher = [[VDMFetcher alloc] init];
	}
	
	NSURL *url = [[NSString stringWithFormat:@"%@%@%@bypass_mobile=1", [[VDMSettings instance] baseURL], 
		path, [path contains:@"?"] ? @"&" : @"?"] toURL];
		
	NSLog(@"Buscando VDMs do endereço %@", [url absoluteString]);
	
	[vdmFetcher fetchFromURL:url
		withCompletionBlock:^(NSString *errorMessage, NSArray *result) {
			if (![NSString isStringEmpty:errorMessage]) {
				ShowAlert(@"Erro", errorMessage);
			}
			else {
				if (entries) {
					[entries addObjectsFromArray:result];
					[self addNewEntries:NO];
				}
				else {
					entries = [result retain];
					[self addNewEntries:YES];
				}
			}
			
			[loadingView removeFromSuperviewAnimated];
			isFirstLoad = NO;
			loadingExtra = NO;
	}];
}

#pragma mark -
#pragma mark UITableViewDelegate
-(void) tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	VDMEntry *entry = [entries objectAtIndex:indexPath.row];
	return [entry.contents sizeWithFont:[UIFont systemFontOfSize:16] 
		constrainedToSize:CGSizeMake(tableView.width, 250) 
		lineBreakMode:UILineBreakModeWordWrap].height + 30;
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
		cell.textView.font = [UIFont fontWithName:@"Verdana" size:12];
	}

	VDMEntry *entry = [entries objectAtIndex:indexPath.row];
	cell.textView.text = entry.contents;
	[cell setDeserveCount:entry.deserveCount];
	[cell setLifeSucksCount:entry.aggreeCount];
	
	if ((float)indexPath.row / (float)entries.count >= 0.8 && !loadingExtra && !isFirstLoad) {
		loadingExtra = YES;
		currentPage++;
		NSLog(@"Carregando adicionais. Próxima pagina: %d", currentPage);
		
		[self fetchEntriesXML:RECENTS_VDMS_PATH];
	}

	return cell;
}

@end
