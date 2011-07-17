#import "VDMEntryCellBackground.h"

// Check http://www.raywenderlich.com/2033/core-graphics-101-lines-rectangles-and-gradients

void RSTLDrawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor) {
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	float locations[] = { 0.0, 1.0 };
	NSArray *colors = [NSArray arrayWithObjects:(id)startColor, (id)endColor, nil];
	CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)colors, locations);
	
	CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
	CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
	
	CGContextSaveGState(context);
	CGContextAddRect(context, rect);
	CGContextClip(context);
	CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
	CGContextRestoreGState(context);
	
	CGGradientRelease(gradient);
	CGColorSpaceRelease(colorSpace);
}

@implementation VDMEntryCellBackground

-(void) drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGColorRef whiteColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor; 
	CGColorRef lightGrayColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
	RSTLDrawLinearGradient(context, self.bounds, whiteColor, lightGrayColor);
}

@end
