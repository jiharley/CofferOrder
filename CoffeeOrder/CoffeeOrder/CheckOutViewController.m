//
//  CheckOutViewController.m
//  CoffeeOrder
//
//  Created by tj  on 13-5-20.
//  Copyright (c) 2013年 tj . All rights reserved.
//

#import "CheckOutViewController.h"
#import "DropDownCell.h"
#import "TJAppDelegate.h"
#import "Constants.h"
@interface CheckOutViewController ()

@end

@implementation CheckOutViewController
@synthesize addressTableView;
@synthesize addressArray;
@synthesize orderedFoodArray;
@synthesize loadingView;
@synthesize selectedAddress;
@synthesize dropDownOpen;
@synthesize usernameTextField;
@synthesize remarkTextField;
@synthesize phoneNumberLabel;

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
    [self loadAddress];
    addressTableView.delegate = self;
    addressTableView.dataSource = self;
    remarkTextField.tag = 1;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults valueForKey:@"phoneNumber"] == NULL || [defaults valueForKey:@"password"] == NULL) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    TJAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.orderedFoodArray = [appDelegate.orderedList copy];
    if ([orderedFoodArray count] == 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    
    usernameTextField.text = [defaults valueForKey:@"userName"];
    phoneNumberLabel.text = [defaults valueForKey:@"phoneNumber"];
    [self loadAddress];
    [addressTableView reloadData];
}

#pragma asihttprequest delegate
-(void) requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"%@ %d %@", request.responseString, request.responseString.length, request.responseHeaders);
    NSString *statusStr = [request.responseHeaders objectForKey:@"Status"];
    if ([statusStr isEqual:@"success"]) {
        //删除已订购数据
        TJAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate.orderedList removeAllObjects];

        [loadingView removeView];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的订单已收到，我们会尽快向您确认。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        av.tag = 1;
        [av show];
    }
    else {
        [loadingView removeView];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"订单提交失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
    }
}
-(void) requestFailed:(ASIHTTPRequest *)request
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接超时，网络不太给力哦~~~" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [av show];
    [loadingView removeView];
}

//提交订单
- (IBAction)submitOrder:(id)sender {
    if ([self isEmptyOrNull:usernameTextField.text]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入称呼" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
    if (!selectedAddress) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无地址，请切换至'我的账户'添加送餐地址" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
    //获取订购食品信息
    NSString *foodContentString = [[NSString alloc] init];
    for (int i = 0; i < [orderedFoodArray count]; i++) {
        NSDictionary *tmpDic = [orderedFoodArray objectAtIndex:i];
        if ([[tmpDic objectForKey:@"number"] integerValue] != 0) {
            foodContentString = [foodContentString stringByAppendingFormat:@"%@,%@,%@;",[tmpDic objectForKey:@"name"],[tmpDic objectForKey:@"number"],[tmpDic objectForKey:@"price"]];
        }
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //上传至服务器
    NSString *urlString = [NSString stringWithFormat:@"%@/coolzey/new_order.php",serverURL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setPostValue:[defaults objectForKey:@"phoneNumber"] forKey:@"userPhone"];
    [request setPostValue:usernameTextField.text forKey:@"userName"];
    [request setPostValue:selectedAddress forKey:@"orderAddress"];
    [request setPostValue:foodContentString forKey:@"orderContent"];
    [request setPostValue:remarkTextField.text forKey:@"orderRemark"];
    [request setDelegate:self];
    [request setTimeOutSeconds:30];
    [request startAsynchronous];
    
    loadingView = [LoadingView loadingViewInView:self.view withTitle:@"正在提交订单..."];
}

-(void) loadAddress
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filename = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"address.plist"];
    
    addressArray = [[NSArray alloc] initWithContentsOfFile:filename];

//    NSBundle *bundle = [NSBundle mainBundle];
//    NSURL *plistURL = [bundle URLForResource:@"address" withExtension:@"plist"];
//    addressArray = [NSArray arrayWithContentsOfURL:plistURL];
    
//    NSMutableArray *tmpAddressArr = [[NSMutableArray alloc] init];
//    for (int i=0; i<[addressArr count]; i++) {
//        NSString *address = [addressArr objectAtIndex:i];
//        [tmpAddressArr addObject:addressArr];
//    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        [self.tabBarController setSelectedIndex:3];
    }
}

#pragma address table view data source
//- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"送餐地址";
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 1;
    if ([addressArray count] == 0) {
        number = 0;
    }
    else if (dropDownOpen) {
        number = [addressArray count] + 1;
    }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *DropDownCellIdentifier = @"DropDownCellIdentifier";
    
    NSUInteger row = [indexPath row];
    switch (row) {
        case 0: {
            DropDownCell *cell = (DropDownCell*) [tableView dequeueReusableCellWithIdentifier:DropDownCellIdentifier];
                    
            if (cell == nil){
                NSLog(@"New Cell Made");
                        
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DropDownCell" owner:nil options:nil];
                        
                for(id currentObject in topLevelObjects)
                {
                    if([currentObject isKindOfClass:[DropDownCell class]])
                    {
                        cell = (DropDownCell *)currentObject;
                        break;
                    }
                }
            }
                    
            [[cell textLabel] setText:[addressArray objectAtIndex:row]];
            selectedAddress = cell.textLabel.text;
            // Configure the cell.
            return cell;
            break;
            }
            default: {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                    
                //NSString *label = [NSString stringWithFormat:@"Option %i", [indexPath row]];
                    
                [[cell textLabel] setText:[addressArray objectAtIndex:row - 1]];
                    
                // Configure the cell.
                return cell;
                    
                break;
            }
    }
}

#pragma address table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ([indexPath row]) {
        case 0:
            return 60;
            break;
            
        default:
            return 35;
            break;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    switch ([indexPath row]) {
        case 0:
        {
            DropDownCell *cell = (DropDownCell*) [tableView cellForRowAtIndexPath:indexPath];
            
            NSMutableArray *indexPathArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < [addressArray count]; i++) {
                [indexPathArray addObject:[NSIndexPath indexPathForRow:[indexPath row] + i +1 inSection:[indexPath section]]];
            }
            
            if ([cell isOpen])
            {
                [cell setClosed];
                dropDownOpen = [cell isOpen];
                        
                [tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
            }
            else
            {
                [cell setOpen];
                dropDownOpen = [cell isOpen];
                        
                [tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
            }
                    
            break;
        }
        default:
        {
            selectedAddress = [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text];
                    
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:[indexPath section]];
            DropDownCell *cell = (DropDownCell*) [tableView cellForRowAtIndexPath:path];
                    
            [[cell textLabel] setText:selectedAddress];
                    
            // close the dropdown cell
            NSMutableArray *indexPathArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < [addressArray count]; i++) {
                [indexPathArray addObject:[NSIndexPath indexPathForRow:[path row] + i +1 inSection:[indexPath section]]];
            }       
            
            [cell setClosed];
            dropDownOpen = [cell isOpen];
                    
            [tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
                    
            break;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//解决虚拟键盘挡住输入框的问题

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [usernameTextField resignFirstResponder];
    [remarkTextField resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[[event allTouches] anyObject];
    
    if (touch.tapCount >=1) {
        [usernameTextField resignFirstResponder];
        [remarkTextField resignFirstResponder];
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [usernameTextField resignFirstResponder];
    [remarkTextField resignFirstResponder];                
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 1) {
        NSTimeInterval animationDuration = 1.0f;
        CGRect frame = self.view.frame;
        frame.origin.y -=160;
//        frame.size.height +=216;
        self.view.frame = frame;
        [UIView beginAnimations:@"ResizeView"context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.view.frame = frame;
        [UIView commitAnimations];
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 1) {
        
        NSTimeInterval animationDuration = 1.0f;
        CGRect frame = self.view.frame;
        frame.origin.y +=160;
//        frame.size.height -=216;
        self.view.frame = frame;
        //self.view移回原位置
        [UIView beginAnimations:@"ResizeView"context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.view.frame = frame;
        [UIView commitAnimations];
    }
    [textField resignFirstResponder];
}
- (BOOL) isEmptyOrNull:(NSString *) str
{
    if (!str) {
        return true;
    }
    else{
        NSString *trimedString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (trimedString.length == 0) {
            return true;
        } else {
            return false;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setSubmitBtn:nil];
    [self setAddressTableView:nil];
    [self setUsernameTextField:nil];
    [self setRemarkTextField:nil];
    [self setPhoneNumberLabel:nil];
    [super viewDidUnload];
}
@end
