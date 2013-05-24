//
//  CheckOutViewController.h
//  CoffeeOrder
//
//  Created by tj  on 13-5-20.
//  Copyright (c) 2013年 tj . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import "ASIFormDataRequest.h"

@interface CheckOutViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate, UIScrollViewDelegate,ASIHTTPRequestDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) LoadingView *loadingView;

@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (strong, nonatomic) IBOutlet UIButton *submitBtn;
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *remarkTextField;
@property (strong, nonatomic) IBOutlet UITableView *addressTableView;

@property (strong, nonatomic) NSArray *addressArray;
@property (strong, nonatomic) NSArray *orderedFoodArray;
@property BOOL dropDownOpen;
@property NSString *selectedAddress;

- (IBAction)submitOrder:(id)sender;
@end
