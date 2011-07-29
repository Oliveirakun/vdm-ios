#import "VDMAddEntryController.h"
#import "RSTLTintedBarButtonItem.h"
#import "ASIHTTPRequest.h"
#import "GATracker.h"
#import "VDMSettings.h"
#import "ASIFormDataRequest.h"
#import "VDMLoadingView.h"
#import "VDMThemeChooserController.h"

@interface VDMAddEntryController ()
-(void) back;
-(void) updateCounterLabel;
-(void) showRulesMessage;
@end

@implementation VDMAddEntryController

-(void) viewDidLoad {
	[super viewDidLoad];
	
	self.title = @"Nova VDM";
	textView.font = [UIFont systemFontOfSize:16];
	
	self.navigationItem.hidesBackButton = YES;
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Voltar" 
		style:UIBarButtonItemStyleBordered target:self action:@selector(back)] autorelease];
		
	RSTLTintedBarButtonItem *sendButton = [RSTLTintedBarButtonItem buttonWithText:@"Enviar" andColor:VDMActiveButtonColor];
	[sendButton setAction:@selector(send:) atTarget:self];
	self.navigationItem.rightBarButtonItem = sendButton;

	[textView becomeFirstResponder];
	extraBar = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add_keyboard_bar.png"]] autorelease];
	[extraBar setY:189];
	extraBar.userInteractionEnabled = YES;
	[self.view addSubview:extraBar];
	
	selectedThemeId = 9;
	themeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, extraBar.height)] autorelease];
	themeLabel.text = @"tema: Geral";
	themeLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13];
	themeLabel.backgroundColor = [UIColor clearColor];
	themeLabel.textColor = [UIColor whiteColor];
	themeLabel.shadowColor = [UIColor blackColor];
	themeLabel.shadowOffset = CGSizeMake(0, 1);
	themeLabel.userInteractionEnabled = YES;
	[themeLabel addTapGesture:self action:@selector(selectTheme) tapCount:1];
	[extraBar addSubview:themeLabel];
	
	counterLabel = [[[UILabel alloc] initWithFrame:CGRectMake(extraBar.rightX - 50, 0, 50, extraBar.height)] autorelease];
	counterLabel.font = themeLabel.font;
	counterLabel.backgroundColor = [UIColor clearColor];
	counterLabel.textColor = themeLabel.textColor;
	counterLabel.shadowColor = themeLabel.shadowColor;
	counterLabel.shadowOffset = themeLabel.shadowOffset;
	[extraBar addSubview:counterLabel];
	[self updateCounterLabel];
	
	[self performSelector:@selector(showRulesMessage) withObject:nil afterDelay:0.5];
}

-(void) selectTheme {
	VDMThemeChooserController *c = [[VDMThemeChooserController alloc] init];
	c.selectedThemeId = selectedThemeId;
	c.didChooseThemeAction = ^(void *context) {
		VDMEntryTheme *t = context;
		themeLabel.text = [NSString stringWithFormat:@"tema: %@", t.description];
		selectedThemeId = t.themeId;
		[UIView animateWithDuration:0.43 animations:^{ [extraBar setY:189]; }];
	};
	
	[UIView animateWithDuration:0.3 animations:^{ [extraBar setY:self.view.height]; }];
	[self presentModalViewController:c animated:YES];
	SafeRelease(c);
}

-(void) updateCounterLabel {
	counterLabel.text = [NSString stringWithFormat:@"%d/300", textView.text.length];
}

-(void) send:(id) sender {
	[UIView animateWithDuration:0.3 animations:^{
		[extraBar setY:self.view.height];
	}];

	VDMLoadingView *loading = [VDMLoadingView loadingViewWithSize:CGSizeMake(self.view.width - 100, 100) message:@"Enviando sua VDM..."];
	loading.autoCenterOnScreen = YES;
	[self.view addSubview:loading];

	NSURL *url = [[NSString stringWithFormat:@"%@/vdm", [[VDMSettings instance] baseURL]] toURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setPostValue:textView.text forKey:@"entry[contents]"];
	[request setPostValue:ToString(selectedThemeId) forKey:@"entry[category_id]"];
	[request setCompletionBlock:^{
		[GATracker trackEvent:@"entry" action:@"create" label:@"" value:0];
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

-(void) showRulesMessage {
	ShowAlert(@"Regras", @"Uma história sempre começa com 'Hoje' e termina com 'VDM'. Sinta-se livre para se expressar como achar melhor, mas escreva em bom português.");
}

#pragma mark -
#pragma mark UITextViewDelegate
-(void) textViewDidChange:(UITextView *)textView {
	[self updateCounterLabel];
}

-(BOOL)textView:(UITextView *)_textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	if ([text isEqualToString:@"\n"]) {
		[self send:nil];
		return NO;
	}

	return textView.text.length < 300 || range.length > 0;
}

@end
