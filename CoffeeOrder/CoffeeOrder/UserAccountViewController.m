//
//  UserAccountViewController.m
//  CoffeeOrder
//
//  Created by tj  on 13-4-7.
//  Copyright (c) 2013年 tj . All rights reserved.
//

#import "UserAccountViewController.h"

@interface UserAccountViewController ()

@end

@implementation UserAccountViewController

@synthesize username;
@synthesize password;
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
	// Do any additional setup after loading the view.
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    UIImage *backgroundImage = [UIImage imageNamed:@"navigationBg"];
    if (version >= 5.0) {
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        [self.navigationController.navigationBar insertSubview:[[UIImageView alloc] initWithImage:backgroundImage]atIndex:1];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    username = [defaults valueForKey:@"phoneNumber"];
    password = [defaults valueForKey:@"password"];
    
    if (username == NULL) {
        [self jumpToLoginView];
    }
    else {
        //[self jumpToLoginView];
    }
    
}
- (void) viewWillAppear:(BOOL)animated
{
    NSLog(@"111");
}
- (void) jumpToLoginView
{
    [self performSegueWithIdentifier:@"login" sender:self];
}

- (void) checkPassword
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
