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

@interface MenuViewController ()

@end

@implementation MenuViewController
@synthesize menuListTableView;
@synthesize tableView = _tableView;
@synthesize dataList;
@synthesize imageList;

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
   
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.delegate = (id<UITableViewDelegate>)self;
        tableView.dataSource = (id<UITableViewDataSource>)self;
        [self.view addSubview:tableView];
        self.menuListTableView = tableView;
    }
    
    TJAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [self loadDataWithCategoryID:appDelegate.selectedRowNum];
}

-(void) loadDataWithCategoryID:(NSInteger)categoryID
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *plistURL = [bundle URLForResource:@"risotto" withExtension:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfURL:plistURL];
    
    NSMutableArray *tmpDataArray = [[NSMutableArray alloc] init];
    NSMutableArray *tmpImageArray = [[NSMutableArray alloc] init];
    for (int i=0; i<[dictionary count]; i++) {
        NSString *key = [[NSString alloc] initWithFormat:@"%i", i+1];
        NSDictionary *tmpDic = [dictionary objectForKey:key];
        [tmpDataArray addObject:tmpDic];
        
        NSString *imageUrl = [[NSString alloc] initWithFormat:@"%@.jpg", [tmpDic objectForKey:@"id"]];
        UIImage *image = [UIImage imageNamed:imageUrl];
        [tmpImageArray addObject:image];
    }
    self.dataList = [tmpDataArray copy];
    self.imageList = [tmpImageArray copy];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataList count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    TJAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    static NSString *menuCellIdentifier = @"MenuCellIdentifier";
    
    static BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"MenuCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:menuCellIdentifier];
        nibsRegistered = YES;
    }
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCellIdentifier];
    if(cell == nil) {
        cell = [[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:menuCellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    NSDictionary *rowData = [self.dataList objectAtIndex:row];
    
    cell.priceLabel.text = [NSString stringWithFormat:@"%@", [rowData objectForKey:@"price"]];
    cell.foodNameLabel.text = [rowData objectForKey:@"name"];
    cell.foodMaterialLabel.text = [rowData objectForKey:@"material"];
    cell.foodImage.image = [imageList objectAtIndex:row];
//    cell.textLabel.text = [NSString stringWithFormat:@"Feed %i Cell %i",appDelegate.selectedRowNum, indexPath.row];
    
    return cell;
    
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
