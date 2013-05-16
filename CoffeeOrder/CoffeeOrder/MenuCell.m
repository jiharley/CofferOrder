//
//  MenuCell.m
//  CoffeeOrder
//
//  Created by tj  on 13-5-4.
//  Copyright (c) 2013年 tj . All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell
@synthesize foodImageView;
@synthesize priceLabel;
@synthesize foodNameLabel;
@synthesize foodMaterialLabel;
@synthesize addCartBtn;

@synthesize foodName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        foodImageView.userInteractionEnabled = YES;
//        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoom:)];
//        [foodImageView addGestureRecognizer:singleTap];
    }
    return self;
}

- (void)zoom
{
    [foodImageView setFrame:CGRectMake(0, 0, 320, 640)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
