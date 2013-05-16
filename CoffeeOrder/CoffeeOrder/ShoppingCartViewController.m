//
//  TJSecondViewController.m
//  CoffeeOrder
//
//  Created by tj  on 13-4-7.
//  Copyright (c) 2013年 tj . All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "TJAppDelegate.h"
#import "ShoppingCartCell.h"
@interface ShoppingCartViewController ()

@end

@implementation ShoppingCartViewController
@synthesize shoppingCartTableView;
@synthesize shoppingCartDataArray;
@synthesize foodImageList;
@synthesize priceSum;
@synthesize priceSumLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    UIImage *backgroundImage = [UIImage imageNamed:@"navigationBg"];
    if (version >= 5.0) {
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        [self.navigationController.navigationBar insertSubview:[[UIImageView alloc] initWithImage:backgroundImage]atIndex:1];
    }
    [self initData];
    shoppingCartTableView.delegate = self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [self initData];
    [shoppingCartTableView reloadData];
    self.priceSumLabel.text = [NSString stringWithFormat:@"%d", priceSum];
}

- (void) plusAction:(id) sender
{
    TJAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    UIButton *thePlusBtn = (UIButton *) sender;
    ShoppingCartCell *theCell = (ShoppingCartCell *)[[thePlusBtn superview] superview];
    NSUInteger theRowNumber = thePlusBtn.tag;
    NSMutableDictionary *theFoodDic = [[NSMutableDictionary alloc]initWithDictionary:[self.shoppingCartDataArray objectAtIndex:theRowNumber]];
    priceSum += [[theFoodDic objectForKey:@"price"] integerValue];
    self.priceSumLabel.text = [NSString stringWithFormat:@"%d", priceSum];
    
    NSUInteger thefoodNum = [[theFoodDic objectForKey:@"number"] integerValue] + 1;
    theCell.foodNumberTextField.text = [NSString stringWithFormat:@"%d", thefoodNum];
    [theFoodDic setObject:[NSString stringWithFormat:@"%d",thefoodNum] forKey:@"number"];
    
    [self.shoppingCartDataArray replaceObjectAtIndex:theRowNumber withObject:theFoodDic];
    appDelegate.orderedList = [self.shoppingCartDataArray mutableCopy];
}

- (void) minusAction:(id) sender
{
    TJAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    UIButton *theMinusBtn = (UIButton *) sender;
    ShoppingCartCell *theCell = (ShoppingCartCell *)[[theMinusBtn superview] superview];
    NSUInteger theRowNumber = theMinusBtn.tag;
    NSMutableDictionary *theFoodDic = [[NSMutableDictionary alloc]initWithDictionary:[self.shoppingCartDataArray objectAtIndex:theRowNumber]];
    
    NSInteger thefoodNum = [[theFoodDic objectForKey:@"number"] integerValue] - 1;
    if (thefoodNum < 0) {
        return;
    }
    //修改tableview cell 中显示的食品数量
    theCell.foodNumberTextField.text = [NSString stringWithFormat:@"%d", thefoodNum];
    //修改全局 已订购食品信息中的值
    [theFoodDic setObject:[NSString stringWithFormat:@"%d",thefoodNum] forKey:@"number"];
    [self.shoppingCartDataArray replaceObjectAtIndex:theRowNumber withObject:theFoodDic];
    appDelegate.orderedList = [self.shoppingCartDataArray mutableCopy];
    //修改总价格
    priceSum -= [[theFoodDic objectForKey:@"price"] integerValue];
    self.priceSumLabel.text = [NSString stringWithFormat:@"%d", priceSum];
    
    

}
//初始化数据，包括已点菜品信息，图片，以及总价格
- (void) initData
{
    TJAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    //全局变量 orderedList 已点菜单列表，复制到shoppingCartDataArray 购物车数据数组
    self.shoppingCartDataArray = [appDelegate.orderedList mutableCopy];
    self.priceSum = 0;
    
    NSMutableArray *tmpImageArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [shoppingCartDataArray count]; i++) {
        NSDictionary *tmpDic = [shoppingCartDataArray objectAtIndex:i];
        
        priceSum += [[tmpDic objectForKey:@"price"] integerValue] * [[tmpDic objectForKey:@"number"] integerValue];
        //构建已订购图片的数组
        NSString *imageUrl = [[NSString alloc] initWithFormat:@"%@.jpg", [tmpDic objectForKey:@"id"]];
        UIImage *image = [UIImage imageNamed:imageUrl];
        [tmpImageArray addObject:image];
    }
    self.foodImageList = [tmpImageArray copy];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger number = [shoppingCartDataArray count];
//    return [shoppingCartDataArray count];
    return number;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *menuCellIdentifier = @"ShoppingCartCellIdentifier";
    ShoppingCartCell *cell = (ShoppingCartCell *)[tableView dequeueReusableCellWithIdentifier:menuCellIdentifier];
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ShoppingCartCell" owner:self options:nil] objectAtIndex:0];
    }
    
    NSUInteger row = [indexPath row];
    NSDictionary *rowData = [self.shoppingCartDataArray objectAtIndex:row];
    
    cell.foodPriceLabel.text = [NSString stringWithFormat:@"%@", [rowData objectForKey:@"price"]];
    cell.foodNameLabel.text = [rowData objectForKey:@"name"];
    cell.foodNumberTextField.text = [rowData objectForKey:@"number"];
    cell.foodImageView.image = [foodImageList objectAtIndex:row];
    cell.foodNumberTextField.delegate = self;
    //添加 加、减 按钮响应时间及按钮标签
    [cell.plusBtn addTarget:self action:@selector(plusAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.plusBtn.tag = row;
    
    [cell.minusBtn addTarget:self action:@selector(minusAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.minusBtn.tag = row;
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    //点击后不弹出键盘
    return NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setShoppingCartTableView:nil];
    [self setPriceSumLabel:nil];
    [super viewDidUnload];
}
@end
