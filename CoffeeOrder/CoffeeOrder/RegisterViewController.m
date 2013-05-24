//
//  RegisterViewController.m
//  CoffeeOrder
//
//  Created by tj  on 13-5-3.
//  Copyright (c) 2013年 tj . All rights reserved.
//

#import "RegisterViewController.h"
#import "Constants.h"

#define usernameTag 1
#define userPhoneTag 2
#define userEmailTag 3
#define passwordTag 4
#define confirmPasswdTag 5

@interface RegisterViewController ()

@end

@implementation RegisterViewController
@synthesize errorMsg;
@synthesize emailText;
@synthesize passwdText;
@synthesize confirmPasswdText;
@synthesize usernameText;
@synthesize phoneNumberText;

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
//    passwdText.secureTextEntry = YES;
//    confirmPasswdText.secureTextEntry = YES;
    usernameText.tag = usernameTag;
    phoneNumberText.tag = userPhoneTag;
    emailText.tag = userEmailTag;
    passwdText.tag = passwordTag;
    confirmPasswdText.tag = confirmPasswdTag;
}

- (IBAction)confirmRegister:(id)sender {
    [usernameText resignFirstResponder];
    [phoneNumberText resignFirstResponder];
    [emailText resignFirstResponder];
    [passwdText resignFirstResponder];
    [confirmPasswdText resignFirstResponder];
    
    if ([self isFill:usernameText.text and:phoneNumberText.text] && [self isValidateEmail:emailText.text] && [self isValidatePasswd:passwdText.text confirmPasswd:confirmPasswdText.text]) {
        errorMsg.text = @"";
        
        NSString *urlString = [NSString stringWithFormat:@"%@/coolzey/register.php",serverURL];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
        
        [request setPostValue:usernameText.text forKey:@"userName"];
        [request setPostValue:phoneNumberText.text forKey:@"phoneNumber"];
        [request setPostValue:emailText.text forKey:@"email"];
        [request setPostValue:[passwdText.text stringFromMD5] forKey:@"password"];
        
        [request setDelegate:self];
        [request setTimeOutSeconds:15];
        [request startAsynchronous];
        //[self.navigationController popViewControllerAnimated:YES];
    }
    else {
        return;
    }
}

- (void) requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"%@ %@", request.responseString, request.responseHeaders);
    NSString *statusStr = [request.responseHeaders objectForKey:@"Status"];
    if ([statusStr isEqual:@"register success"]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:phoneNumberText.text forKey:@"phoneNumber"];
        [defaults setValue:usernameText.text forKey:@"userName"];
        [defaults setValue:emailText.text forKey:@"email"];
        //跳转至登录界面
        UIAlertView *registerSuccessAv = [[UIAlertView alloc]initWithTitle:@"提示" message:@"注册成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        registerSuccessAv.tag = 1;
        [registerSuccessAv show];
//        [NSThread sleepForTimeInterval:1];
//        [self.navigationController popViewControllerAnimated:YES];

    }
    else if ([statusStr isEqual:@"user exists"]) {
         errorMsg.text = @"该号码已注册";
    }
    else {
         errorMsg.text = @"注册失败";
    }
}

- (void) requestFailed:(ASIHTTPRequest *)request
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接超时，网络不太给力哦~~~" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [av show];
    //errorMsg.text = @"注册失败";
}
#pragma alertview delegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma textfield delegate function
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    switch (textField.tag) {
        case usernameTag:
            [phoneNumberText becomeFirstResponder];break;
        case userPhoneTag:
            [emailText becomeFirstResponder];break;
        case userEmailTag:
            [passwdText becomeFirstResponder];break;
        case passwordTag:
            [confirmPasswdText becomeFirstResponder];break;
        case confirmPasswdTag:
            [self confirmRegister:nil];break;
        default:
            break;
    }
    return true;
}
//解决虚拟键盘挡住输入框的问题
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[[event allTouches] anyObject];
    
    if (touch.tapCount >=1) {
        [usernameText resignFirstResponder];
        [phoneNumberText resignFirstResponder];
        [emailText resignFirstResponder];
        [passwdText resignFirstResponder];
        [confirmPasswdText resignFirstResponder];
    }
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if ((textField.tag == passwordTag) || (textField.tag == confirmPasswdTag)) {
        NSTimeInterval animationDuration = 1.0f;
        CGRect frame = self.view.frame;
        frame.origin.y -=50;
        frame.size.height +=50;
        self.view.frame = frame;
        [UIView beginAnimations:@"ResizeView"context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.view.frame = frame;
        [UIView commitAnimations];
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == passwordTag || textField.tag == confirmPasswdTag) {
        
        NSTimeInterval animationDuration = 1.0f;
        CGRect frame = self.view.frame;
        frame.origin.y +=50;
        frame.size. height -=50;
        self.view.frame = frame;
        //self.view移回原位置
        [UIView beginAnimations:@"ResizeView"context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.view.frame = frame;
        [UIView commitAnimations];
    }
    [textField resignFirstResponder];     
}
- (BOOL) isFill:(NSString *) username and:(NSString *)phoneNumber
{
    if ([username isEqual: @""]) {
        errorMsg.text = @"称呼不能为空";
        return FALSE;
    }
    else if ([phoneNumber isEqual:@""]) {
        errorMsg.text = @"手机号不能为空";
        return FALSE;
    }
    else {
        return TRUE;
    }
}

- (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    if ([emailTest evaluateWithObject:email] == FALSE) {
        errorMsg.text = @"email格式不正确";
    }
    return [emailTest evaluateWithObject:email];
}

- (BOOL) isValidatePasswd:(NSString *) passwd confirmPasswd:(NSString *)confirmPasswd
{
    if (passwd.length < 6) {
        errorMsg.text = @"密码长度需不少于6位";
        return FALSE;
    }
    else if (![passwd isEqualToString:confirmPasswd]) {
        errorMsg.text = @"两次输入密码不一致";
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
    [self setConfirmBtn:nil];
    [self setErrorMsg:nil];
    [self setUsernameText:nil];
    [self setPhoneNumberText:nil];
    [self setEmailText:nil];
    [self setPasswdText:nil];
    [self setConfirmPasswdText:nil];
    [super viewDidUnload];
}

@end
