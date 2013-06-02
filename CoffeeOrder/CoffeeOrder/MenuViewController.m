//
//  TJFirstViewController.m
//  CoffeeOrder
//
//  Created by tj  on 13-4-7.
//  Copyright (c) 2013年 tj . All rights reserved.
//

#import "MenuViewController.h"
#import "TJAppDelegate.h"
#import "MenuCell.h"
#import "GGFullscreenImageViewController.h"
@interface MenuViewController ()

@end

@implementation MenuViewController
@synthesize menuListTableView;
@synthesize dataList;
@synthesize imageList;
@synthesize foodIdList;
@synthesize orderedIdList;
@synthesize userGuideView;
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
        //    if (!tableView) {
        menuListTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        menuListTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        menuListTableView.delegate = (id<UITableViewDelegate>)self;
        menuListTableView.dataSource = (id<UITableViewDataSource>)self;
        [self.view addSubview:menuListTableView];
        //self.menuListTableView = tableView;
        //    }
        TJAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [self loadDataWithCategoryName:appDelegate.categoryName];//载入数据
        //构建已经加入购物车的菜品id的数组
        orderedIdList = [[NSMutableArray alloc] init];
}

-(void) viewWillAppear:(BOOL)animated
{
    [orderedIdList removeAllObjects];
    TJAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSArray *tmpOrderedDataArray = [appDelegate.orderedList copy];
    for (int i = 0; i < [tmpOrderedDataArray count]; i++) {
        NSDictionary *tmpDictionary = [tmpOrderedDataArray objectAtIndex:i];
        [orderedIdList addObject:[tmpDictionary objectForKey:@"id"]];
    }
    [menuListTableView reloadData];
}
//-(void) getIdArray:(NSMutableArray *) orderedDataArray{
//    
//}

//载入tableview所需的数据，从Plist中读取菜品数据，图片根据名称直接读取
-(void) loadDataWithCategoryName:(NSString *)categoryName
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *plistURL = [bundle URLForResource:categoryName withExtension:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfURL:plistURL];
    
    NSMutableArray *tmpDataArray = [[NSMutableArray alloc] init];
    NSMutableArray *tmpImageArray = [[NSMutableArray alloc] init];
    NSMutableArray *tmpIdArray = [[NSMutableArray alloc] init];
    for (int i=0; i<[dictionary count]; i++) {
        NSString *key = [[NSString alloc] initWithFormat:@"%i", i+1];
        //构建菜品信息字典的数组
        NSDictionary *tmpDic = [dictionary objectForKey:key];
        [tmpDataArray addObject:tmpDic];
        //构建菜品id的数组
        [tmpIdArray addObject:[tmpDic objectForKey:@"id"]];
        //构建菜品图片的数组
        NSString *imageUrl = [[NSString alloc] initWithFormat:@"%@.jpg", [tmpDic objectForKey:@"id"]];
        UIImage *image = [UIImage imageNamed:imageUrl];
        [tmpImageArray addObject:image];
    }
    self.dataList = [tmpDataArray copy];
    self.imageList = [tmpImageArray copy];
    self.foodIdList = [tmpIdArray copy];
}

- (void) addToCart:(UITapGestureRecognizer *) sender
{
    UIImageView *theImageView = (UIImageView *) sender.self.view;
//    UIButton *selectedBtn = (UIButton *) sender;
//    NSUInteger selectedRow = selectedBtn.tag;
    NSUInteger selectedRow = theImageView.tag;
    NSDictionary *selectedDataDic = [self.dataList objectAtIndex:selectedRow];
    TJAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSString *selectedFoodId = [selectedDataDic objectForKey:@"id"];
    NSUInteger selectedFoodIdIndex = [orderedIdList indexOfObject:selectedFoodId];
    if ([orderedIdList containsObject:selectedFoodId]) { //已在购物车中，从购物车中删除
        theImageView.image = [UIImage imageNamed:@"addCart"];
//        [selectedBtn setBackgroundImage:[UIImage imageNamed:@"addCart"] forState:UIControlStateNormal];
        
        [appDelegate.orderedList removeObjectAtIndex:selectedFoodIdIndex];
        
        //从idList中删除选中食物的id
        [orderedIdList removeObjectAtIndex:selectedFoodIdIndex];
    }
    else{  //未在购物车中，加入购物车
//        [selectedBtn setBackgroundImage:[UIImage imageNamed:@"inCart"] forState:UIControlStateNormal];
        theImageView.image = [UIImage imageNamed:@"inCart"];
        NSMutableDictionary *tempSelectedDic = [[NSMutableDictionary alloc] init];
        [tempSelectedDic setObject:[selectedDataDic objectForKey:@"id"] forKey:@"id"];
        [tempSelectedDic setObject:[selectedDataDic objectForKey:@"name"] forKey:@"name"];
        [tempSelectedDic setObject:[selectedDataDic objectForKey:@"price"] forKey:@"price"];
        [tempSelectedDic setObject:@"1" forKey:@"number"];
        [appDelegate.orderedList addObject:tempSelectedDic];
        
        //添加选中食物的id到orderedIdList中
        [orderedIdList addObject:selectedFoodId];
    }
}

- (void) zoomImage:(UITapGestureRecognizer *) sender
{
    UIImageView *theImageView = (UIImageView *)sender.self.view;
//    NSUInteger theRow = theView.tag;
////    UIView *screenView = [[UIView alloc] initWithFrame:self.view.bounds];
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    imageView.image = [imageList objectAtIndex:theRow];
//    [self.view addSubview:imageView];
//    [self.view bringSubviewToFront:imageView];
    MenuCell *theCell = (MenuCell *)[[theImageView superview] superview];
    theImageView.contentMode = UIViewContentModeScaleAspectFit;
    GGFullscreenImageViewController *vc = [[GGFullscreenImageViewController alloc] init];
    vc.liftedImageView = theImageView;
    vc.foodDetail = theCell.foodMaterialLabel.text;
    [self presentViewController:vc animated:YES completion:nil];

}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataList count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *menuCellIdentifier = @"MenuCellIdentifier";
    MenuCell *cell = (MenuCell *)[tableView dequeueReusableCellWithIdentifier:menuCellIdentifier];
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MenuCell" owner:self options:nil] objectAtIndex:0];
    }
    
    NSUInteger row = [indexPath row];
    NSDictionary *rowData = [self.dataList objectAtIndex:row];
    
    cell.priceLabel.text = [NSString stringWithFormat:@"%@", [rowData objectForKey:@"price"]];
    cell.foodNameLabel.text = [rowData objectForKey:@"name"];
    cell.foodMaterialLabel.text = [rowData objectForKey:@"material"];
    cell.foodImageView.image = [imageList objectAtIndex:row];
    
    
    //添加imageView点击事件
    cell.foodImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomImage:)];
    [cell.foodImageView addGestureRecognizer:singleTap];
    cell.foodImageView.tag = row;
    
    //加入购物车图片点击事件
    cell.addCartImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *oneClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addToCart:)];
    [cell.addCartImageView addGestureRecognizer:oneClick];
    cell.addCartImageView.tag = row;
    
    
    if ([orderedIdList containsObject:[rowData objectForKey:@"id"]]) {
        cell.addCartImageView.image = [UIImage imageNamed:@"inCart"];
    }
    else {
        cell.addCartImageView.image = [UIImage imageNamed:@"addCart"];
    }

    //设置添加购物车按钮响应事件并对按钮绑定tag
//    [cell.addCartBtn addTarget:self action:@selector(addToCart:) forControlEvents:UIControlEventTouchUpInside];
//    cell.addCartBtn.tag = row;
//    if ([orderedIdList containsObject:[rowData objectForKey:@"id"]]) {
//        [cell.addCartBtn setBackgroundImage:[UIImage imageNamed:@"inCart"] forState:UIControlStateNormal];
//    }
//    else {
//        [cell.addCartBtn setBackgroundImage:[UIImage imageNamed:@"addCart"] forState:UIControlStateNormal];
//    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.0;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMenuListTableView:nil];
    [super viewDidUnload];
}

@end
