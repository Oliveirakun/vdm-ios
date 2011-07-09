#import "RSTLTintedBarButtonItem.h"

@implementation RSTLTintedBarButtonItem

+(RSTLTintedBarButtonItem *) buttonWithText:(NSString *) text andColor:(UIColor *) color {
	UISegmentedControl *button = [[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:text, nil]] autorelease];
	button.momentary = YES;
	button.segmentedControlStyle = UISegmentedControlStyleBar;
	button.tintColor = color;
	return [[[RSTLTintedBarButtonItem alloc] initWithCustomView:button] autorelease];
}

-(void) changeColor:(UIColor *) newColor {
	[(UISegmentedControl *)self.customView setTintColor:newColor];
}

@end
