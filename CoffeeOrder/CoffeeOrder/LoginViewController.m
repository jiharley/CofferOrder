//
//  LoginViewController.m
//  CoffeeOrder
//
//  Created by tj  on 13-4-28.
//  Copyright (c) 2013年 tj . All rights reserved.
//

#import "LoginViewController.h"
#import "Constants.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize phoneNumberTextField;
@synthesize passwordTextField;
@synthesize passwordMD5;
@synthesize errorMsg;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;//隐藏导航栏返回键
    passwordTextField.secureTextEntry = YES;
    
}

- (void) requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"%@", request.responseString);
    NSString *responseStr = request.responseString;
    if ([responseStr isEqual: @"login success"]) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setValue:phoneNumberTextField.text forKey:@"phoneNumber"];
        [defaults setValue:passwordMD5 forKey:@"password"];
        [self.navigationController popToRootViewControllerAnimated:YES];
        //self.view = nil;
    }
    else if ([responseStr isEqual:@"user does not exist"]){
        //该手机号不存在
    }
    else if ([responseStr isEqual:@"wrong password"]){
        //密码错误
    }
    else {
        //未知错误
    }
}

- (void) requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"failed");
}

- (void) viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [phoneNumberTextField setText:[defaults valueForKey:@"phoneNumber"]];
}

- (IBAction)jumpToReigster:(id)sender {
    [self performSegueWithIdentifier:@"register" sender:self];
}

- (IBAction)login:(id)sender {
    if ([self isFill:passwordTextField.text and:phoneNumberTextField.text]) {
        NSString *urlString = [NSString stringWithFormat:@"%@/cafeOrder/login.php",serverURL];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
        passwordMD5 = [passwordTextField.text stringFromMD5];
        [request setPostValue:phoneNumberTextField.text forKey:@"phoneNumber"];
        [request setPostValue:passwordMD5 forKey:@"password"];
        
        [request setDelegate:self];
        [request setTimeOutSeconds:15];
        [request startAsynchronous];
    }
    else {
        return;
    }
    
}

- (BOOL) isFill:(NSString *) password and:(NSString *)phoneNumber
{
    if ([phoneNumber isEqual:@""]) {
        errorMsg.text = @"请输入手机号";
        return FALSE;
    }
    else if ([password isEqual: @""]) {
        errorMsg.text = @"请输入密码";
        return FALSE;
    }

    else {
        return TRUE;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPhoneNumberTextField:nil];
    [self setPasswordTextField:nil];
    [self setLoginBtn:nil];
    [self setRegisterBtn:nil];
    [self setErrorMsg:nil];
    [super viewDidUnload];
}

@end
