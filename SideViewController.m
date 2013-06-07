//
//  TestViewController.m
//  CoffeeOrder
//
//  Created by tj  on 13-4-8.
//  Copyright (c) 2013年 tj . All rights reserved.
//

#import "SideViewController.h"
#import "TJAppDelegate.h"
#import "MenuViewController.h"
#import "DDMenuController.h"
#import "ShoppingCartViewController.h"
#import "UserAccountViewController.h"
#import "AboutUsViewController.h"
@interface SideViewController ()

@end

@implementation SideViewController
@synthesize categoryList;

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
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *deviceLang = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
    NSURL *plistURL = nil;
    if ([deviceLang isEqual:@"zh-Hans"] || [deviceLang isEqual:@"zh-Hant"])
    {
        plistURL = [bundle URLForResource:@"categoryList" withExtension:@"plist"];
    }
    else {
        plistURL = [bundle URLForResource:@"categoryList_en" withExtension:@"plist"];
    }
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfURL:plistURL];
    
    NSMutableArray *tmpDataArray = [[NSMutableArray alloc] init];
    for (int i=0; i<[dictionary count]; i++) {
        NSString *key = [[NSString alloc] initWithFormat:@"%i", i+1];
        NSDictionary *tmpDic = [dictionary objectForKey:key];
        [tmpDataArray addObject:tmpDic];
    }
    self.categoryList = [tmpDataArray copy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [categoryList count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [[categoryList objectAtIndex:row] objectForKey:@"name"];
    
    return cell;
    
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
    return NSLocalizedString(@"category list", nil);
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // set the root controller
    DDMenuController *menuController = (DDMenuController*)((TJAppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    UITabBarController *tabController = nil;
    if ([[menuController getRootViewController] isKindOfClass:[UITabBarController class]]) {
         tabController = (UITabBarController*)[menuController getRootViewController];
    }
    tabController.delegate = self;
//    menuController = nil;
//    menuController = [[DDMenuController alloc] init];
    MenuViewController *controller0 = [[MenuViewController alloc] init];
//    ShoppingCartViewController *controller2 = [[ShoppingCartViewController alloc] init];
//    UserAccountViewController *controller3 = [[UserAccountViewController alloc] init];
//    AboutUsViewController *controller4 = [[AboutUsViewController alloc] init];
//
    
    UINavigationController *navController0 = [[UINavigationController alloc] initWithRootViewController:controller0];
//    UINavigationController *navController0 = nil;
    UINavigationController *navController1 = nil;
    UINavigationController *navController2 = nil;
    UINavigationController *navController3 = nil;
    if ([[tabController.viewControllers objectAtIndex:0] isKindOfClass:[UINavigationController class]]) {
        UINavigationController *tempNavController = [tabController.viewControllers objectAtIndex:0];
//        navController0.navigationController.navigationItem.title = NSLocalizedString(@"menu", nil);
        navController0.tabBarItem = tempNavController.tabBarItem;
        
        [navController0.navigationBar setBarStyle:UIBarStyleBlack];
    }
    if ([[tabController.viewControllers objectAtIndex:1] isKindOfClass:[UINavigationController class]]) {
        navController1 = [tabController.viewControllers objectAtIndex:1];
    }
    if ([[tabController.viewControllers objectAtIndex:2] isKindOfClass:[UINavigationController class]]) {
        navController2 = [tabController.viewControllers objectAtIndex:2];
    }
    if ([[tabController.viewControllers objectAtIndex:3] isKindOfClass:[UINavigationController class]]) {
        navController3 = [tabController.viewControllers objectAtIndex:3];
    }

    tabController.viewControllers = [NSArray arrayWithObjects:navController0, navController1, navController2, navController3, nil];
    
    [menuController setRootController:tabController animated:YES];
    
    NSUInteger row = [indexPath row];
    TJAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.selectedRowNum = indexPath.row;
    appDelegate.categoryName = [[categoryList objectAtIndex:row] objectForKey:@"content"];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma tabbarcontroller delegate
-(BOOL) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    UINavigationController *nav = nil;
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        nav = (UINavigationController *) viewController;
    }
    if (([nav.viewControllers count]>1)&& tabBarController.selectedViewController == viewController) {
        return NO;
    }
    return YES;
}
@end
