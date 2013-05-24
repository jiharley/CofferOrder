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
//@property (strong, nonatomic) UITableView *tableView;
@property (retain, nonatomic) UITableView *menuListTableView;

@property (strong, nonatomic) NSArray *dataList;
@property (strong, nonatomic) NSArray *imageList;
@property (strong, nonatomic) NSArray *foodIdList;
@property (strong, nonatomic) NSMutableArray *orderedIdList;

-(void) loadDataWithCategoryName:(NSString *)categoryName;
@end
