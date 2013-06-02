//
//  UserGuideViewController.h
//  CoffeeOrder
//
//  Created by tj  on 13-6-1.
//  Copyright (c) 2013年 tj . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserGuideViewController : UIViewController <UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *goToMainViewBtn;
- (IBAction)goToMainView:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *pageScroll;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@end
