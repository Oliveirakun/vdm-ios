#import "VDMAddCommentController.h"
#import "RSTLTintedBarButtonItem.h"
#import "ASIFormDataRequest.h"
#import "VDMLoadingView.h"
#import "VDMSettings.h"
#import "GATracker.h"

@implementation VDMAddCommentController
@synthesize entry;

-(void) viewDidLoad {
	[comment becomeFirstResponder];
	self.title = @"Comentar";
	
	self.navigationItem.hidesBackButton = YES;
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Cancelar" 
		style:UIBarButtonItemStyleBordered target:self action:@selector(back)] autorelease];
	
	RSTLTintedBarButtonItem *sendButton = [RSTLTintedBarButtonItem buttonWithText:@"Enviar" andColor:VDMActiveButtonColor];
	[sendButton setAction:@selector(send:) atTarget:self];
	self.navigationItem.rightBarButtonItem = sendButton;
}

-(void) send:(id) sender {
	VDMLoadingView *loading = [VDMLoadingView loadingViewWithSize:CGSizeMake(self.view.width - 100, 100) message:@"Enviando seu comentário..."];
	loading.autoCenterOnScreen = YES;
	[self.view addSubview:loading];
	
	NSURL *url = [[NSString stringWithFormat:@"%@/vdm/%d/comentarios", [[VDMSettings instance] baseURL], entry.entryId] toURL];
	__block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setPostValue:comment.text forKey:@"comment[contents]"];
	[request setPostValue:comment.text forKey:@"comment[nickname]"];
	[request setCompletionBlock:^{
		[GATracker trackEvent:@"comment" action:@"create" label:ToString(entry.entryId) value:0];
		ShowAlert(@"Aviso", @"Seu comentário foi enviado com sucesso");
		[loading removeFromSuperviewAnimated];
		[self performSelector:@selector(back) withObject:nil afterDelay:1.5];
	}];
	[comment resignFirstResponder];	
	[request startAsynchronous];
}

-(void) back {
	[self.navigationController popViewControllerAnimated:YES];
}

-(BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	if ([text isEqualToString:@"\n"]) {
		[self send:nil];
		return NO;
	}

	return YES;
}

- (void)dealloc {
	SafeRelease(comment);
	SafeRelease(username);
	[super dealloc];
}

@end
