//
//  UserGuideViewController.m
//  CoffeeOrder
//
//  Created by tj  on 13-6-1.
//  Copyright (c) 2013年 tj . All rights reserved.
//

#import "UserGuideViewController.h"
#import "TJAppDelegate.h"
@interface UserGuideViewController ()

@end

@implementation UserGuideViewController
@synthesize imageView;
@synthesize pageControl;
@synthesize pageScroll;
@synthesize goToMainViewBtn;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    pageControl.numberOfPages = 7;
    pageControl.currentPage = 0;
    pageScroll.delegate = self;
    
    pageScroll.contentSize = CGSizeMake(self.view.frame.size.width * 7, self.view.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setImageView:nil];
    [self setGoToMainViewBtn:nil];
    [self setPageScroll:nil];
    [self setPageControl:nil];
    [super viewDidUnload];
}
- (IBAction)goToMainView:(id)sender {
//    self.view = nil;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
    TJAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [self.pageScroll setHidden:YES];
    [self.pageControl setHidden:YES];
    UIViewController *mainController = (UIViewController *) appDelegate.menuController;
    [self presentModalViewController:mainController animated:YES];
}
#pragma UIScrollView delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.view.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
}

@end
