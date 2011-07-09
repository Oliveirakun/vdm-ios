#import "RSTLTintedBarButtonItem.h"

@implementation RSTLTintedBarButtonItem

+(RSTLTintedBarButtonItem *) buttonWithText:(NSString *) text andColor:(UIColor *) color {
	UISegmentedControl *button = [[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:text, nil]] autorelease];
	button.momentary = YES;
	button.segmentedControlStyle = UISegmentedControlStyleBar;
	button.tintColor = color;
	return [[[RSTLTintedBarButtonItem alloc] initWithCustomView:button] autorelease];
}

-(void) setAction:(SEL) action atTarget:(id) target {
	[self.innerButton addTarget:target action:action forControlEvents:UIControlEventValueChanged];
}

-(UISegmentedControl *) innerButton {
	return (UISegmentedControl *)self.customView;
}

-(void) changeColor:(UIColor *) newColor {
	[self.innerButton setTintColor:newColor];
}

@end
