//
//  ShopCartCell.m
//  CoffeeOrder
//
//  Created by tj  on 13-5-15.
//  Copyright (c) 2013年 tj . All rights reserved.
//

#import "ShoppingCartCell.h"

@implementation ShoppingCartCell
@synthesize plusBtn;
@synthesize minusBtn;
@synthesize foodNameLabel;
@synthesize foodPriceLabel;
@synthesize foodImageView;
@synthesize foodNumberTextField;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
