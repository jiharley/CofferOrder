//
//  UserAccountViewController.m
//  CoffeeOrder
//
//  Created by tj  on 13-4-7.
//  Copyright (c) 2013年 tj . All rights reserved.
//

#import "UserAccountViewController.h"
#import "AddressCell.h"
#import "Constants.h"

#define logoutAlert 0
#define addAddressView 1
#define addAddressRequestTag 1
#define deleteAddressRequestTag 2
@interface UserAccountViewController ()

@end

@implementation UserAccountViewController
@synthesize userAddressTableView;
@synthesize userAddressArray;
@synthesize selectedAddressArray;
@synthesize phoneNumberLabel;
@synthesize username;
@synthesize password;
@synthesize addressToAdd;
@synthesize processView;
@synthesize editAddressBtn;

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
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    UIImage *backgroundImage = [UIImage imageNamed:@"navigationBg"];
    if (version >= 5.0) {
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        [self.navigationController.navigationBar insertSubview:[[UIImageView alloc] initWithImage:backgroundImage]atIndex:1];
    }
    self.selectedAddressArray = [[NSMutableArray alloc] init];
    self.userAddressTableView.userInteractionEnabled = YES;
    
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTableViewCellLongPressed:)];
//    longPress.delegate = self;
//    longPress.minimumPressDuration = 1;
//    [userAddressTableView addGestureRecognizer:longPress];
    
}
-(void) loadUserAddress
{
//    NSBundle *bundle = [NSBundle mainBundle];
//    NSURL *plistURL = [bundle URLForResource:@"address" withExtension:@"plist"];
//    userAddressArray = [NSArray arrayWithContentsOfURL:plistURL];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filename = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"address.plist"];
    
    userAddressArray = [[NSMutableArray alloc] initWithContentsOfFile:filename];
}

- (void) viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    username = [defaults valueForKey:@"phoneNumber"];
    password = [defaults valueForKey:@"password"];
    
    if (username == NULL || password == NULL) {
        [self jumpToLoginView];
    }
    else {
        [self loadUserAddress];
        self.phoneNumberLabel.text = [defaults valueForKey:@"phoneNumber"];
    }

    self.phoneNumberLabel.text = [defaults valueForKey:@"phoneNumber"];
    [self loadUserAddress];
    [userAddressTableView reloadData];
}

- (void) jumpToLoginView
{
    [self performSegueWithIdentifier:@"login" sender:self];
}

- (void) checkPassword
{
    
}
- (IBAction)logOut:(id)sender {
    UIAlertView *logoutAv = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要退出吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    logoutAv.tag = logoutAlert;
    [logoutAv show];
    
}

-(void) handleTableViewCellLongPressed:(UILongPressGestureRecognizer *) gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:userAddressTableView];
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"UIGestureRecognizerStateBegan");
        [userAddressTableView setEditing:YES animated:YES];
        NSIndexPath *indexPath = [userAddressTableView indexPathForRowAtPoint:p];
//        AddressCell *cell = (AddressCell *)[userAddressTableView cellForRowAtIndexPath:indexPath];
//        cell.backgroundColor = [UIColor blackColor];
        [userAddressTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    else if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"UIGestureRecognizerStateEnded");
    }
    else if(gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        NSLog(@"UIGestureRecognizerStateChanged");
    }
//    else if(gestureRecognizer.state == UIGestureRecognizerStateCancelled)
//    {
//        NSLog(@"UIGestureRecognizerStateCancelled");
//    }
//    else if(gestureRecognizer.state ==UIGestureRecognizerStateFailed )
//    {
//        NSLog(@"UIGestureRecognizerStateFailed");
//    }
}
- (IBAction)addAddress:(id)sender {
    
    UIAlertView *addAddressAv = [[UIAlertView alloc]initWithTitle:@"添加地址" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"添加", nil];
    addAddressAv.tag = addAddressView;
    addAddressAv.alertViewStyle = UIAlertViewStylePlainTextInput;
    [addAddressAv show];
}
//编辑，删除用户送餐地址
- (IBAction)editBtnPressed:(id)sender {
    if ([editAddressBtn.titleLabel.text isEqual: @"编辑"]) {
        [userAddressTableView setEditing:YES animated:YES];
        [editAddressBtn setTitle:@"删除" forState:UIControlStateNormal];
    }
    else {
        [editAddressBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [userAddressTableView setEditing:NO animated:YES];
        if([selectedAddressArray count] > 0)
        {
            NSString *selectedAddressStr = @"";
            for(int i = 0;i < [selectedAddressArray count];i++)
            {
                NSString *tmp = [userAddressArray objectAtIndex:[[selectedAddressArray objectAtIndex:i] row]];
                selectedAddressStr = [selectedAddressStr stringByAppendingFormat:@"%@;",tmp];
            }
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *urlString = [NSString stringWithFormat:@"%@/coolzey/delete_address.php",serverURL];
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
            request.tag = deleteAddressRequestTag;
            [request setPostValue:selectedAddressStr forKey:@"userAddress"];
            [request setPostValue:[defaults objectForKey:@"userId"] forKey:@"userId"];
            [request setTimeOutSeconds:15];
            request.delegate = self;
            [request startAsynchronous];
            
            if(processView){
                [processView removeFromSuperview];
                processView = nil;
            }
            processView = [[AddressProcessView alloc] initWithMessage:@"正在删除..."];
            [self.view addSubview:processView];
        }
    }
}

#pragma ASIHTTPRequest delegate
-(void) requestFinished:(ASIHTTPRequest *)request
{
    if (request.tag == addAddressRequestTag) {
        NSString *statusStr = [request.responseHeaders objectForKey:@"Status"];
        if ([statusStr isEqual:@"success"]) {
            //成功上传至服务器，将地址添加到plist中
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *filename = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"address.plist"];
            NSMutableArray *data = [[NSMutableArray alloc] init];
            NSArray *tmpArray = [[NSArray alloc] initWithContentsOfFile:filename];
            [data addObject:self.addressToAdd];
            [data addObjectsFromArray:tmpArray];
            [data writeToFile:filename atomically:YES];
            
            [self loadUserAddress];
            [self.userAddressTableView reloadData];
            
            [processView onlyShowMsg:@"添加成功！"];
        }
        else {
            [processView onlyShowMsg:@"地址添加失败！"];
        }
    }
    if (request.tag == deleteAddressRequestTag) {
        NSLog(@"%@",request.responseHeaders);
        NSString *statusStr = [request.responseHeaders objectForKey:@"Status"];
        if ([statusStr isEqual:@"success"]) {
            //成功删除地址，更新table和plist
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *filename = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"address.plist"];
            NSMutableIndexSet *deleteSet = [NSMutableIndexSet indexSet];
            for(int i = 0;i < [selectedAddressArray count];i++)
            {
                NSInteger row = [[selectedAddressArray objectAtIndex:i] row];
                [deleteSet addIndex:row];
                
            }
            [userAddressArray removeObjectsAtIndexes:deleteSet];
            [userAddressArray writeToFile:filename atomically:YES];
            
            [self loadUserAddress];
            [self.userAddressTableView reloadData];
            
            [processView onlyShowMsg:@"删除成功！"];
            [self.selectedAddressArray removeAllObjects];
        }
        else {
            [processView onlyShowMsg:@"地址删除失败！"];
            [self.selectedAddressArray removeAllObjects];
        }
    }
}
-(void) requestFailed:(ASIHTTPRequest *)request
{
    if (request.tag == addAddressRequestTag) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接超时，地址添加失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [av show];
    }
    if (request.tag == deleteAddressRequestTag) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接超时，地址删除失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [av show];
        [self.selectedAddressArray removeAllObjects];
    }
}
#pragma mark alertview delegate and function
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case logoutAlert:
            //退出时的操作
            if (buttonIndex == 1) {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults removeObjectForKey:@"password"];
                [defaults removeObjectForKey:@"userName"];
                [defaults removeObjectForKey:@"email"];
                [defaults removeObjectForKey:@"userId"];
                //删除地址文件
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *filename = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"address.plist"];
//                NSMutableArray *tempData = [[NSMutableArray alloc] initWithContentsOfFile:filename];
//                [tempData removeAllObjects];
//                [tempData writeToFile:filename atomically:YES];
                [fileManager removeItemAtPath:filename error:nil];
                
                
                [self jumpToLoginView];
            }
            break;
        case addAddressView:
            //添加地址的操作
            if (buttonIndex == 1) {
                UITextField *addressTextFIeld = [[UITextField alloc]init];
                for (UIView *view in alertView.subviews) {
                    if ([view isKindOfClass:[UITextField class]]) {
                        addressTextFIeld = (UITextField *) view;
                    }
                }
                addressToAdd = addressTextFIeld.text;
                if ([self isValid:addressToAdd]) {
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    NSString *urlString = [NSString stringWithFormat:@"%@/coolzey/new_address.php",serverURL];
                    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
                    request.tag = addAddressRequestTag;
                    [request setPostValue:addressToAdd forKey:@"userAddress"];
                    [request setPostValue:[defaults objectForKey:@"userId"] forKey:@"userId"];
                    [request setPostValue:[defaults objectForKey:@"phoneNumber"] forKey:@"userPhone"];
                    [request setTimeOutSeconds:15];
                    request.delegate = self;
                    [request startAsynchronous];
                    
                    if(processView){
                        [processView removeFromSuperview];
                        processView = nil;
                    }
                     processView = [[AddressProcessView alloc] initWithMessage:@"正在添加..."];
                    [self.view addSubview:processView];
                }
                else {
                    return;
                }
//                NSMutableArray *data1 = [[NSMutableArray alloc] initWithContentsOfFile:filename];
//                NSLog(@"%@", data1); 
            }
            break;
        default:
            break;
    }
}

- (BOOL) isValid:(NSString *) str
{
    if (!str) {
        return false;
    }
    else{
        NSString *trimedString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSString *trimedCharString = [str stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@";|"]];
        if (trimedCharString.length < str.length) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能包含非法字符" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
            return false;
        }
        if (trimedString.length == 0) {
            return false;
        } else {
            return true;
        }
    }
}
//alertview即将消失时，更新userAddressArray，并重新载入表格
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == addAddressView) {
        if (buttonIndex == 1) {
//            [self loadUserAddress];
//            [userAddressTableView reloadData];
        }
    }
}
#pragma userAddressTableView data source
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [userAddressArray count];
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *addressCellIdentifier = @"addressCellIdentifier";
    AddressCell *cell = (AddressCell *)[tableView dequeueReusableCellWithIdentifier:addressCellIdentifier];
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AddressCell" owner:self options:nil] objectAtIndex:0];
    }
    NSUInteger row = [indexPath row];
    cell.addressLabel.text = [userAddressArray objectAtIndex:row];
    cell.addressLabel.textColor = [UIColor blackColor];
    
    return cell;
}

#pragma userAddressTableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (userAddressTableView.isEditing) {
        [self.selectedAddressArray addObject:indexPath];
    }
    else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)tableView:(UITableView*)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (userAddressTableView.isEditing) {
        [self.selectedAddressArray removeObject:indexPath];
    }
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return
    UITableViewCellEditingStyleDelete
    |
    UITableViewCellEditingStyleInsert;
}
//- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//    return YES;
//}
//-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete || editingStyle == UITableViewCellEditingStyleInsert) {
//        //[self deleteAddressAtIndexPath:indexPath];
//    }
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setUserAddressTableView:nil];
    [self setLogoutBtn:nil];
    [self setPhoneNumberLabel:nil];
    [self setAddAddressBtn:nil];
    [self setEditAddressBtn:nil];
    [super viewDidUnload];
}
@end
