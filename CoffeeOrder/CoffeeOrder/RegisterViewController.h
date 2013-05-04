//
//  RegisterViewController.h
//  CoffeeOrder
//
//  Created by tj  on 13-5-3.
//  Copyright (c) 2013年 tj . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "MD5Addition.h"

@interface RegisterViewController : UIViewController <ASIHTTPRequestDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *confirmBtn;
- (IBAction)confirmRegister:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *errorMsg;

@property (strong, nonatomic) IBOutlet UITextField *usernameText;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberText;
@property (strong, nonatomic) IBOutlet UITextField *emailText;
@property (strong, nonatomic) IBOutlet UITextField *passwdText;
@property (strong, nonatomic) IBOutlet UITextField *confirmPasswdText;

- (BOOL)isValidateEmail:(NSString *)email;
- (BOOL) isValidatePasswd:(NSString *) passwd confirmPasswd:(NSString *)confirmPasswd;

@end
