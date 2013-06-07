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
    NSLog(@"%@ %@", request.responseString, request.responseHeaders);
    NSString *statusStr = [request.responseHeaders objectForKey:@"Status"];
    NSString *responseStr = request.responseString;
    if ([statusStr isEqual: @"login success"]) {
        //对response字符进行解码
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filename = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"address.plist"];
        responseStr = [responseStr substringToIndex:responseStr.length - 1];
        NSArray *responseArray = [responseStr componentsSeparatedByString:@";"];
        NSArray *addressArray = [[NSArray alloc] init];
        if ([responseArray count] == 3) {
            NSString *responseAddress = (NSString *)[responseArray objectAtIndex:2];
            addressArray = [responseAddress componentsSeparatedByString:@"|"];
        }
        if ([addressArray count]) {
            [addressArray writeToFile:filename atomically:YES];
        }
        [defaults setValue:[responseArray objectAtIndex:0] forKey:@"userId"];
        [defaults setValue:[responseArray objectAtIndex:1] forKey:@"userName"];
        [defaults setValue:phoneNumberTextField.text forKey:@"phoneNumber"];
        [defaults setValue:passwordMD5 forKey:@"password"];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        //self.view = nil;
    }
    else if ([statusStr isEqual:@"user does not exist"]){
        //该手机号不存在
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", nil) message:NSLocalizedString(@"phone number hasn't registered", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"confirm", nil) otherButtonTitles:nil, nil];
        [av show];

    }
    else if ([statusStr isEqual:@"wrong password"]){
        //密码错误
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", nil) message:NSLocalizedString(@"wrong password", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"confirm", nil) otherButtonTitles:nil, nil];
        [av show];

    }
    else {
        //未知错误
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", nil) message:NSLocalizedString(@"login failed", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"confirm", nil) otherButtonTitles:nil, nil];
        [av show];
    }
}

- (void) requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"failed");
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", nil) message:NSLocalizedString(@"request failed prompt", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"confirm", nil) otherButtonTitles:nil, nil];
    [av show];
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
        NSString *urlString = [NSString stringWithFormat:@"%@/coolzey/login.php",serverURL];
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
        errorMsg.text = NSLocalizedString(@"please input phone number", nil);
        return FALSE;
    }
    else if ([password isEqual: @""]) {
        errorMsg.text = NSLocalizedString(@"please input password", nil);
        return FALSE;
    }

    else {
        return TRUE;
    }
}

//释放键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[[event allTouches] anyObject];
    
    if (touch.tapCount >=1) {
        [phoneNumberTextField resignFirstResponder];
        [passwordTextField resignFirstResponder];
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
