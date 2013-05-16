//
//  TestViewController.h
//  CoffeeOrder
//
//  Created by tj  on 13-4-8.
//  Copyright (c) 2013年 tj . All rights reserved.
//

#import <UIKit/UIKit.h>
//@protocol DDMenuDelegate;
@interface SideViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
//    id<DDMenuDelegate> delegate;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *categoryList;

@end
