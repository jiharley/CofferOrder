//
//  TJAppDelegate.m
//  CoffeeOrder
//
//  Created by tj  on 13-4-7.
//  Copyright (c) 2013年 tj . All rights reserved.
//

#import "TJAppDelegate.h"
#import "DDMenuController.h"
#import "MenuViewController.h"
#import "SideViewController.h"


@implementation TJAppDelegate
@synthesize selectedRowNum;
@synthesize categoryName;
@synthesize orderedList;
@synthesize menuController = _menuController;
@synthesize userGuideViewController;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
//    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
//    NSString* preferredLang = [languages objectAtIndex:0];
    NSString *deviceLang = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
    if ([deviceLang isEqual:@"zh-Hans"] || [deviceLang isEqual:@"zh-Hant"]) {
        categoryName = @"salad";
    }
    else {
        categoryName = @"salad_en";
    }
    orderedList = [[NSMutableArray alloc] init];
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    
    // Override point for customization after application launch.
    
    UITabBar *tabBar = [tabBarController tabBar];
    if ([tabBar respondsToSelector:@selector(setBackgroundImage:)])
    {
        // ios 5.x
        [tabBar setBackgroundImage:[UIImage imageNamed:@"tabBarBg"]];
    }
    else
    {
        // ios 4.x
        CGRect frame = CGRectMake(0, 0, 320, 49);
        UIView *tabbg_view = [[UIView alloc] initWithFrame:frame];
        UIImage *tabbag_image = [UIImage imageNamed:@"tabBarBg"];
        UIColor *tabbg_color = [[UIColor alloc] initWithPatternImage:tabbag_image];
        tabbg_view.backgroundColor = tabbg_color;
        [tabBar insertSubview:tabbg_view atIndex:0];
    }
    DDMenuController *rootController = [[DDMenuController alloc] initWithRootViewController:tabBarController];
    _menuController = rootController;
    
    SideViewController *sideController = [[SideViewController alloc] init];
    rootController.leftViewController = sideController;
    
    _menuController = rootController;
    tabBarController.delegate = sideController;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"] == false) {
        userGuideViewController = [[UserGuideViewController alloc] initWithNibName:@"UserGuideViewController" bundle:nil];
        [userGuideViewController.goToMainViewBtn addTarget:self action:@selector(goToMain:) forControlEvents:UIControlEventTouchUpInside];
        self.window.rootViewController = userGuideViewController;
    }
    else{
        self.window.rootViewController = rootController;
        self.window.backgroundColor = [UIColor whiteColor];
    }
    [self.window makeKeyAndVisible];
    return YES;
}
//-(void) goToMain:(id) sender {
//    [userGuideViewController.pageScroll setHidden:YES];
//    [userGuideViewController.pageControl setHidden:YES];
//    self.window.rootViewController = _menuController;
//    [self.window makeKeyAndVisible];
//}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
