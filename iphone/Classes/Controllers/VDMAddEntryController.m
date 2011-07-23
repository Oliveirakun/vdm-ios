#import "VDMAddEntryController.h"
#import "RSTLTintedBarButtonItem.h"
#import "ASIHTTPRequest.h"
#import "GATracker.h"
#import "VDMSettings.h"
#import "ASIFormDataRequest.h"
#import "VDMLoadingView.h"

@interface VDMAddEntryController ()
-(void) back;
@end

@implementation VDMAddEntryController

-(void) viewDidLoad {
	self.title = @"Nova VDM";
	textView.font = [UIFont systemFontOfSize:16];
	
	self.navigationItem.hidesBackButton = YES;
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Voltar" 
		style:UIBarButtonItemStyleBordered target:self action:@selector(back)] autorelease];
		
	RSTLTintedBarButtonItem *sendButton = [RSTLTintedBarButtonItem buttonWithText:@"Enviar" andColor:VDMActiveButtonColor];
	[sendButton setAction:@selector(send:) atTarget:self];
	self.navigationItem.rightBarButtonItem = sendButton;
}

-(void) viewWillAppear:(BOOL)animated {
	[textView becomeFirstResponder];
}

-(void) send:(id) sender {
	VDMLoadingView *loading = [VDMLoadingView loadingViewWithSize:CGSizeMake(self.view.width - 100, 100) message:@"Enviando sua VDM..."];
	loading.autoCenterOnScreen = YES;
	[self.view addSubview:loading];

	NSURL *url = [[NSString stringWithFormat:@"%@/vdm", [[VDMSettings instance] baseURL]] toURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setPostValue:textView.text forKey:@"entry[contents]"];
	[request setPostValue:@"3" forKey:@"entry[category_id]"];
	[request setCompletionBlock:^{
		ShowAlert(@"Aviso", @"Obrigado. Sua desgraça foi enviada, e está aguardando avaliação dos outros coitados");
		[loading removeFromSuperviewAnimated];
		[self performSelector:@selector(back) withObject:nil afterDelay:1.5];
	}];
	[textView resignFirstResponder];	
	[request startAsynchronous];
}

-(void) back {
	[self.navigationController popViewControllerAnimated:YES];
}

-(BOOL) hidesBottomBarWhenPushed {
	return YES;
}

- (void)dealloc {
	SafeRelease(textView);
	[super dealloc];
}

#pragma mark -
#pragma mark UITextViewDelegate
-(BOOL)textView:(UITextView *)_textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	return textView.text.length < 300 || range.length > 0;
}

@end
