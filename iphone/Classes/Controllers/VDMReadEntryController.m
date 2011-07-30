#import "VDMReadEntryController.h"
#import "ASIHTTPRequest.h"
#import "VDMSettings.h"
#import "VDMAddCommentController.h"

@interface VDMReadEntryController ()
-(void) loadComments;
@end

@implementation VDMReadEntryController
@synthesize entry;

-(void) viewDidLoad {
	comments.backgroundColor = [UIColor whiteColor];
	[comments disableScrollShadow];
	self.title = [NSString stringWithFormat:@"VDM #%d", entry.entryId];	
	
	UIFont *font = [UIFont fontWithName:@"Verdana" size:12];
	contents.text = [NSString stringWithFormat:@"\"%@\"", entry.contents];
	contents.font = font;
	
	CGSize textSize = [contents.text sizeWithFont:font
	   constrainedToSize:CGSizeMake(contents.width, 1000) 
	   lineBreakMode:UILineBreakModeWordWrap];
	[contents setHeight:textSize.height + 30];
	
	UIImageView *commentsBar = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comments_bar.png"]] autorelease];
	[commentsBar setY:contents.lowerY + 5];
	commentsLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 0, commentsBar.width, commentsBar.height)] autorelease];
	commentsLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
	commentsLabel.textColor = [UIColor colorWithRed:2.0/255.0 green:39.0/255.0 blue:102.0/255.0 alpha:1];
	commentsLabel.shadowColor = [UIColor whiteColor];
	commentsLabel.backgroundColor = [UIColor clearColor];
	commentsLabel.shadowOffset = CGSizeMake(1, 1);
	[commentsBar addSubview:commentsLabel];
	[self.view addSubview:commentsBar];
	
	[comments setY:commentsBar.lowerY + 10];
	[comments setHeight:self.view.height - commentsBar.lowerY - 20];
	
	[self loadComments];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Comentar" 
		style:UIBarButtonItemStyleBordered target:self action:@selector(addComment)] autorelease];
}

-(void) viewWillAppear:(BOOL)animated {
	[self loadComments];
}

-(void) addComment {
	VDMAddCommentController *c = [[VDMAddCommentController alloc] init];
	c.entry = self.entry;
	[self.navigationController pushViewController:c animated:YES];
	SafeRelease(c);
}

-(void) loadComments {
	commentsLabel.text = @"Carregando comentários...";
	
	NSURL *url = [[NSString stringWithFormat:@"%@/vdm/%d/comentarios.json", [VDMSettings instance].baseURL, entry.entryId] toURL];
	__block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request addRequestHeader:@"User-Agent" value:@"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_8; de-at) AppleWebKit/533.21.1 (KHTML, like Gecko) Version/5.0.5 Safari/533.21.1"];
	[request setCompletionBlock:^{
		if ([request error]) {
			ShowAlert(@"Erro", [request.error localizedDescription]);
		}
		else {
			NSMutableString *s = [NSMutableString stringWithContentsOfFile:ResourcePath(@"/comments.html") encoding:NSUTF8StringEncoding error:nil];
			[s replace:@"${comments}" with:[request responseString]];
			
			[comments loadHTMLString:s baseURL:nil];
			commentsLabel.text = [NSString stringWithFormat:@"Comentários (%d)", entry.commentsCount];
		}
	}];
	[request startAsynchronous];
}

-(BOOL) hidesBottomBarWhenPushed {
	return YES;
}

- (void)dealloc {
	SafeRelease(comments);
	SafeRelease(contents);
	[super dealloc];
}

@end
