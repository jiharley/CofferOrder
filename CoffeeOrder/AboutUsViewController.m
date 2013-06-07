//
//  AboutUsViewController.m
//  CoffeeOrder
//
//  Created by tj  on 13-4-7.
//  Copyright (c) 2013年 tj . All rights reserved.
//

#import "AboutUsViewController.h"
#import "AboutUsCell.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController
@synthesize listData;

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
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *plistURL = [bundle URLForResource:@"aboutus" withExtension:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfURL:plistURL];
    
    NSMutableArray *tmpDataArray = [[NSMutableArray alloc] init];
    for (int i=1; i<=[dictionary count]; i++) {
        NSString *key = [[NSString alloc] initWithFormat:@"%i", i];
        NSDictionary *tmpDic = [dictionary objectForKey:key];
        [tmpDataArray addObject:tmpDic];
    }
    self.listData = [tmpDataArray copy];
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *AboutUsIdentifier = @"AboutUsIdentifier";
    
    static BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"AboutUsCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:AboutUsIdentifier];
        nibsRegistered = YES;
    }
    
    AboutUsCell *cell = [tableView dequeueReusableCellWithIdentifier:AboutUsIdentifier];
    
    NSUInteger row = [indexPath row];
    NSDictionary *rowData = [self.listData objectAtIndex:row];
    
    cell.restaurantName.text = [rowData objectForKey:@"name"];
    cell.addressCN.text = [rowData objectForKey:@"addressCN"];
    cell.addressEN.text = [rowData objectForKey:@"addressEN"];
    cell.businessHourAndPhone.text = [rowData objectForKey:@"detail"];
    
    return cell;
}

#pragma mark Table Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110.0;
}

- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
