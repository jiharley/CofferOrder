//
//  LoginViewController.h
//  CoffeeOrder
//
//  Created by tj  on 13-4-28.
//  Copyright (c) 2013年 tj . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "MD5Addition.h"


@interface LoginViewController : UIViewController <ASIHTTPRequestDelegate>

@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UILabel *errorMsg;

//@property NSString *username;
@property NSString *passwordMD5;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UIButton *registerBtn;
- (IBAction)jumpToReigster:(id)sender;
- (IBAction)login:(id)sender;
@end
