#import "VDMReadEntryController.h"
#import "ASIHTTPRequest.h"
#import "VDMSettings.h"

@interface VDMReadEntryController ()
-(void) loadComments;
@end

@implementation VDMReadEntryController
@synthesize entry;

-(void) viewDidLoad {
	comments.backgroundColor = [UIColor whiteColor];
	[comments disableScrollShadow];
}

-(void) viewWillAppear:(BOOL)animated {
	self.title = [NSString stringWithFormat:@"VDM #%d", entry.entryId];	
	youDeserved.text = [NSString stringWithFormat:@"Você mereceu (%d)", entry.deserveCount];
	yourLifeSucks.text = [NSString stringWithFormat:@"É, sua vida é uma merda (%d)", entry.agreeCount];
	contents.text = entry.contents;
	contents.font = [UIFont fontWithName:@"Verdana" size:16];
	[self loadComments];
}

-(void) loadComments {
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
		}
	}];
	[request startAsynchronous];
}

-(BOOL) hidesBottomBarWhenPushed {
	return YES;
}

- (void)dealloc {
	SafeRelease(youDeserved);
	SafeRelease(yourLifeSucks);
	SafeRelease(comments);
	SafeRelease(contents);
	[super dealloc];
}

@end
