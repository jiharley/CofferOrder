//
//  TJFirstViewController.h
//  CoffeeOrder
//
//  Created by tj  on 13-4-7.
//  Copyright (c) 2013年 tj . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SideViewController.h"

@interface MenuViewController : UIViewController<UITableViewDelegate, UITableViewDelegate>
{
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableView *menuListTableView;

@property (strong, nonatomic) NSArray *dataList;
@property (strong, nonatomic) NSArray *imageList;

- (void) loadDataWithCategoryID:(NSInteger) categoryID;
@end
