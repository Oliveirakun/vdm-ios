#import <UIKit/UIKit.h>

@interface VDMCategoriesSelectorController : UIViewController {
	RSTLSimpleAction onCategorySelect;
}

@property (nonatomic, copy) RSTLSimpleAction onCategorySelect;

-(IBAction) selectCategory:(id) sender;

@end
