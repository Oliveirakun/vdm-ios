#import <Foundation/Foundation.h>

@interface VDMThemeChooserController : UITableViewController {
	RSTLSimpleAction didChooseThemeAction;
	NSArray *themes;
	int selectedThemeId;
}

@property (nonatomic, assign) int selectedThemeId;
@property (nonatomic, copy) RSTLSimpleAction didChooseThemeAction;

@end
