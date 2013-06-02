//
//  TJAppDelegate.h
//  CoffeeOrder
//
//  Created by tj  on 13-4-7.
//  Copyright (c) 2013年 tj . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserGuideViewController.h"
@class DDMenuController;
@interface TJAppDelegate : UIResponder <UIApplicationDelegate>
{
}
@property (strong, nonatomic) DDMenuController *menuController;
@property (strong, nonatomic) UIWindow *window;
@property NSInteger selectedRowNum;
@property NSString *categoryName;
@property (strong, nonatomic) NSMutableArray *orderedList;

@property (strong, nonatomic) UserGuideViewController *userGuideViewController;
@end
