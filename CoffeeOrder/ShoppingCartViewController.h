//
//  TJSecondViewController.h
//  CoffeeOrder
//
//  Created by tj  on 13-4-7.
//  Copyright (c) 2013年 tj . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingCartViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray *shoppingCartDataArray;
@property (strong, nonatomic) IBOutlet UITableView *shoppingCartTableView;
@property (strong, nonatomic) NSArray *foodImageList;
@property (strong, nonatomic) IBOutlet UILabel *priceSumLabel;
@property (strong, nonatomic) IBOutlet UIButton *chectoutBtn;
- (IBAction)goToCheckout:(id)sender;
@property NSUInteger priceSum;
@end
