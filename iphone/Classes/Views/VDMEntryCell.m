#import "VDMEntryCell.h"
#import "VDMEntryCellBackground.h"
#import "VDMSettings.h"
#import "ASIHTTPRequest.h"

@implementation VDMEntryCell
@synthesize textView, entry;

-(void) awakeFromNib {
	self.backgroundView = [[[VDMEntryCellBackground alloc] init] autorelease];
	self.selectedBackgroundView = [[[VDMEntryCellBackground alloc] init] autorelease];
	
	[youDeservedIt addTapGesture:self action:@selector(vote:) tapCount:1];
	[yourLifeSucks addTapGesture:self action:@selector(vote:) tapCount:1];
}

-(void) registerVote:(NSString *) type {
	NSURL *url = [[NSString stringWithFormat:@"%@/vdm/%d/vote?which_vote=%@", 
		[VDMSettings instance].baseURL, entry.entryId, type] toURL];
	__block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request addRequestHeader:@"Accept" value:@"text/javascript, application/javascript, */*"];
	[request setRequestMethod:@"POST"];
	[request startAsynchronous];
}

-(void) vote:(UIGestureRecognizer *) gesture {
	UILabel *sender = (UILabel *)gesture.view;
	
	if ((sender == youDeservedIt && entry.deserveVoted) || (sender == yourLifeSucks && entry.agreeVoted)) {
		[UIView animateWithDuration:0.4 animations:^{
			sender.alpha = 0;
		} completion:^(BOOL finished) {
			sender.text = @"Você já votou";
			
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
	youDeservedIt.text = [NSString stringWithFormat:@"Você mereceu (%d)", count];
}

-(void) setLifeSucksCount:(int) count {
	yourLifeSucks.text = [NSString stringWithFormat:@"Sua vida é uma merda (%d)", count];
}

-(void) dealloc {
	SafeRelease(textView);
	SafeRelease(youDeservedIt);
	SafeRelease(yourLifeSucks);
	SafeRelease(textView);
	[super dealloc];
}

@end
