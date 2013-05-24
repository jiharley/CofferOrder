//
//  AddAddressView.m
//  CoffeeOrder
//
//  Created by tj  on 13-5-23.
//  Copyright (c) 2013年 tj . All rights reserved.
//

#import "AddressProcessView.h"
#import <QuartzCore/QuartzCore.h>


@implementation AddressProcessView
@synthesize messageLabel;

- (id)initWithMessage:(NSString *)msg
{
    CGRect viewFrame = CGRectMake(90, 45, 160, 30);
    self = [super initWithFrame:viewFrame];
    self.backgroundColor = [UIColor grayColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
                            UIViewAutoresizingFlexibleTopMargin;
    CGRect labelFrame = CGRectMake(10, 0, self.frame.size.width/2+40, self.frame.size.height);
    messageLabel = [[UILabel alloc] initWithFrame:labelFrame];
    messageLabel.text = msg;
    messageLabel.backgroundColor = [UIColor grayColor];
    messageLabel.textColor = [UIColor whiteColor];
    [self addSubview:messageLabel];
    
    UIActivityIndicatorView *activityIndicatorView =[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    CGRect activityIndicatorRect = activityIndicatorView.frame;
    activityIndicatorRect.origin.x = messageLabel.frame.origin.x + messageLabel.frame.size.width;
    activityIndicatorRect.origin.y = 6;
    activityIndicatorView.frame = activityIndicatorRect;
    [self addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    // Set up the fade-in animation
    CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionFade];
	[[self.superview layer] addAnimation:animation forKey:@"layerAnimation"];

    return self;
}

- (void)onlyShowMsg:(NSString *)msg
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIActivityIndicatorView class]]) {
            [view removeFromSuperview];
        }
    }
    self.messageLabel.text = msg;
    [self performSelector:@selector(removeView) withObject:nil afterDelay:1];
}
//
// removeView
//
// Animates the view out from the superview. As the view is removed from the
// superview, it will be released.
//
- (void)removeView
{
	UIView *aSuperview = [self superview];
	[super removeFromSuperview];
    
	// Set up the animation
	CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionFade];
	
	[[aSuperview layer] addAnimation:animation forKey:@"layerAnimation"];
}

//
// drawRect:
//
// Draw the view.
//
- (void)drawRect:(CGRect)rect
{
    
    //create view at center
    //rect = CGRectMake(CGRectGetMidX(rect)-75, CGRectGetMidY(rect)-50, 150, 130);
    rect = CGRectMake(CGRectGetMidX(rect)-30, CGRectGetMidY(rect)-180, 60, 30);
	
    //set rounded corner
	const CGFloat ROUND_RECT_CORNER_RADIUS = 5.0;
	CGPathRef roundRectPath = NewPathWithRoundRect(rect, ROUND_RECT_CORNER_RADIUS);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    //set grey transclucent background
	const CGFloat BACKGROUND_OPACITY = 0.75;
	CGContextSetRGBFillColor(context, 0, 0, 0, BACKGROUND_OPACITY);
	CGContextAddPath(context, roundRectPath);
	CGContextFillPath(context);
    
    //set transclucent white boreder line
	const CGFloat STROKE_OPACITY = 0.25;
	CGContextSetRGBStrokeColor(context, 1, 1, 1, STROKE_OPACITY);
	CGContextAddPath(context, roundRectPath);
	CGContextStrokePath(context);
	
	CGPathRelease(roundRectPath);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
