//
//  MenuCell.h
//  CoffeeOrder
//
//  Created by tj  on 13-5-4.
//  Copyright (c) 2013年 tj . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *foodImage;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *foodNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *foodMaterialLabel;
@property (strong, nonatomic) IBOutlet UIButton *addCartBtn;
@end
