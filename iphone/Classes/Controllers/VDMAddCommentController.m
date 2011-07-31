#import "VDMAddCommentController.h"
#import "RSTLTintedBarButtonItem.h"
#import "ASIFormDataRequest.h"
#import "VDMLoadingView.h"
#import "VDMSettings.h"
#import "GATracker.h"

@implementation VDMAddCommentController
@synthesize entry;

-(void) viewDidLoad {
	[username becomeFirstResponder];
	self.title = @"Comentar";
	
	UIButton *sendButton = [[[UIButton alloc] init] autorelease];
	[sendButton setBackgroundImage:[UIImage imageNamed:@"red_button.png"] forState:UIControlStateNormal];
	[sendButton setTitle:@"Enviar" forState:UIControlStateNormal];
	[sendButton setSize:CGSizeMake(75, 31)];
	sendButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
	[sendButton addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:sendButton] autorelease];
	
	self.navigationItem.hidesBackButton = YES;
	UIButton *cancelButton = [[[UIButton alloc] init] autorelease];
	[cancelButton setBackgroundImage:[UIImage imageNamed:@"black_button.png"] forState:UIControlStateNormal];
	[cancelButton setTitle:@"Cancelar" forState:UIControlStateNormal];
	[cancelButton setSize:CGSizeMake(75, 31)];
	cancelButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
	[cancelButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:cancelButton] autorelease];
}

-(void) send:(id) sender {
	if ([NSString isStringEmpty:username.text]) {
		ShowAlert(@"Aviso", @"Por favor, informe seu nome ou apelido");
		[username becomeFirstResponder];
		return;
	}

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
		entry.commentsCount++;
	}];
	[comment resignFirstResponder];	
	[username resignFirstResponder];
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
