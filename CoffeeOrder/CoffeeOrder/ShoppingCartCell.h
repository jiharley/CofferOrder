//
//  ShopCartCell.h
//  CoffeeOrder
//
//  Created by tj  on 13-5-15.
//  Copyright (c) 2013年 tj . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingCartCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *foodNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *foodPriceLabel;

@property (strong, nonatomic) IBOutlet UIButton *plusBtn;
@property (strong, nonatomic) IBOutlet UIButton *minusBtn;

@property (strong, nonatomic) IBOutlet UITextField *foodNumberTextField;
@property (strong, nonatomic) IBOutlet UIImageView *foodImageView;
@end
