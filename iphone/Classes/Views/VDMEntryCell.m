#import "VDMEntryCell.h"
#import "VDMEntryCellBackground.h"
#import "VDMSettings.h"
#import "ASIHTTPRequest.h"

@implementation VDMEntryCell
@synthesize textView, entry;

-(void) awakeFromNib {
	self.backgroundView = [[[VDMEntryCellBackground alloc] init] autorelease];
	self.selectedBackgroundView = [[[VDMEntryCellBackground alloc] init] autorelease];
}

-(void) registerVote:(NSString *) type {
	NSURL *url = [[NSString stringWithFormat:@"%@/vdm/%d/vote?which_vote=%@", 
		[VDMSettings instance].baseURL, entry.entryId, type] toURL];
	__block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request addRequestHeader:@"Accept" value:@"text/javascript, application/javascript, */*"];
	[request setRequestMethod:@"POST"];
	[request startAsynchronous];
}

-(IBAction) vote:(UIButton *) sender {
	if ((sender == youDeservedIt && entry.deserveVoted) || (sender == yourLifeSucks && entry.agreeVoted)) {
		[UIView animateWithDuration:0.4 animations:^{
			sender.alpha = 0;
		} completion:^(BOOL finished) {
			[sender setTitle:@"Você já votou" forState:UIControlStateNormal];
			
			[UIView animateWithDuration:0.4 animations:^{
				sender.alpha = 1;
			} completion:^(BOOL finished) {
				[UIView animateWithDuration:0.4 delay:2 options:0 animations:^{
					sender.alpha = 0;
				} completion:^(BOOL finished) {
					[self setDeserveCount:entry.deserveCount];
					[self setLifeSucksCount:entry.agreeCount];
					
					[UIView animateWithDuration:0.4 animations:^{
						sender.alpha = 1;
					}];
				}];
			}];
		}];
	}
	else {
		[UIView animateWithDuration:0.4 animations:^{
			sender.alpha = 0;
		} completion:^(BOOL finished) {
			if (sender == youDeservedIt) {
				entry.deserveCount++;
				entry.deserveVoted = YES;
				[self setDeserveCount:entry.deserveCount];
				[self registerVote:@"deserved"];
			}
			else {
				entry.agreeCount++;
				entry.agreeVoted = YES;
				[self setLifeSucksCount:entry.agreeCount];
				[self registerVote:@"agree"];
			}
		
			[UIView animateWithDuration:0.4 animations:^{
				sender.alpha = 1;
			}];
		}];
	}
}

-(void) setDeserveCount:(int) count {
	[youDeservedIt setTitle:[NSString stringWithFormat:@"Você mereceu (%d)", count] forState:UIControlStateNormal];
}

-(void) setLifeSucksCount:(int) count {
	[yourLifeSucks setTitle:[NSString stringWithFormat:@"Sua vida é uma merda (%d)", count] forState:UIControlStateNormal];
}

-(void) dealloc {
	SafeRelease(textView);
	SafeRelease(youDeservedIt);
	SafeRelease(yourLifeSucks);
	SafeRelease(textView);
	[super dealloc];
}

@end
