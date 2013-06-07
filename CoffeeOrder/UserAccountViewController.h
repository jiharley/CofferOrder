//
//  UserAccountViewController.h
//  CoffeeOrder
//
//  Created by tj  on 13-4-7.
//  Copyright (c) 2013年 tj . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "AddressProcessView.h"
@interface UserAccountViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, ASIHTTPRequestDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *userAddressTableView;
@property (strong, nonatomic) IBOutlet UIButton *logoutBtn;
@property (strong, nonatomic) IBOutlet UIButton *addAddressBtn;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (strong, nonatomic) IBOutlet UIButton *editAddressBtn;
@property (strong, nonatomic) NSMutableArray *userAddressArray;
@property (strong, nonatomic) NSMutableArray *selectedAddressArray;
@property (strong, nonatomic) AddressProcessView *processView;
- (IBAction)logOut:(id)sender;
- (IBAction)addAddress:(id)sender;
- (IBAction)editBtnPressed:(id)sender;
@property NSString *username;
@property NSString *password;
@property NSString *addressToAdd;
@end
