//
//  AboutUsCell.m
//  CoffeeOrder
//
//  Created by 史 丹青 on 13-5-9.
//  Copyright (c) 2013年 tj . All rights reserved.
//

#import "AboutUsCell.h"

@implementation AboutUsCell
@synthesize restaurantName;
@synthesize addressCN;
@synthesize addressEN;
@synthesize businessHourAndPhone;

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
