#import <Foundation/Foundation.h>

@interface VDMLoadingView : UIView {
	BOOL autoCenterOnScreen;
}

@property (nonatomic, assign) BOOL autoCenterOnScreen;

+(VDMLoadingView *) loadingViewWithSize:(CGSize) size message:(NSString *) message;

@end
