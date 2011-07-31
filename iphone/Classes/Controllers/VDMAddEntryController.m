#import "VDMAddEntryController.h"
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
	
	UIButton *backButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 75, 31)] autorelease];
	[backButton setBackgroundImage:[UIImage imageNamed:@"black_button.png"] forState:UIControlStateNormal];
	[backButton setTitle:@"Voltar" forState:UIControlStateNormal];
	backButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
	[backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
		
	UIButton *sendButton = [[[UIButton alloc] init] autorelease];
	[sendButton setBackgroundImage:[UIImage imageNamed:@"red_button.png"] forState:UIControlStateNormal];
	[sendButton setTitle:@"Enviar" forState:UIControlStateNormal];
	[sendButton setSize:CGSizeMake(75, 31)];
	sendButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
	[sendButton addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:sendButton] autorelease];

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
	if (![[textView.text uppercaseString] hasSuffix:@"VDM"]) {
		ShowAlert(@"Aviso", @"A sua história precisa terminar com VDM");
		return;
	}

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

	if (textView.text.length > 2) {
		char minus1 = [textView.text characterAtIndex:textView.text.length - 1];
		char minus2 = [textView.text characterAtIndex:textView.text.length - 2];
		
		if (textView.text.length > 3 && [[text uppercaseString] isEqualToString:@"M"] 
			&& (minus1 == 'D' || minus1 == 'd')
			&& (minus2 == 'V' || minus2 == 'v')) {
			textView.text = [NSString stringWithFormat:@"%@ VDM", [textView.text substringToIndex:textView.text.length - 3]];
			return NO;
		}
	}

	return textView.text.length < 300 || range.length > 0;
}

@end
