//
//  AboutUsViewController.h
//  CoffeeOrder
//
//  Created by tj  on 13-4-7.
//  Copyright (c) 2013年 tj . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutUsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *listData;

@end
