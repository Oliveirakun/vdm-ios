#import <UIKit/UIKit.h>

@interface VDMCategoriesSelectorController : UIViewController {
	RSTLSimpleAction onCategorySelect;
}

@property (nonatomic, copy) RSTLSimpleAction onCategorySelect;

-(void) setSelectedCategory:(NSString *) value;
-(IBAction) selectCategory:(id) sender;

@end
