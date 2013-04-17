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
    return 4;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    /*
     * Content in this cell should be inset the size of kMenuOverlayWidth
     */
    
    cell.textLabel.text = [NSString stringWithFormat:@"Cell %i", indexPath.row];
    
    return cell;
    
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
    return @"菜品类别";
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // set the root controller
    DDMenuController *menuController = (DDMenuController*)((TJAppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    UITabBarController *tabController = nil;
    if ([[menuController getRootViewController] isKindOfClass:[UITabBarController class]]) {
         tabController = (UITabBarController*)[menuController getRootViewController];
    }
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
    TJAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.selectedRowNum = indexPath.row;
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end