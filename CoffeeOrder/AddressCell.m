//
//  AddressCell.m
//  CoffeeOrder
//
//  Created by tj  on 13-5-21.
//  Copyright (c) 2013年 tj . All rights reserved.
//

#import "AddressCell.h"

@implementation AddressCell
@synthesize addressLabel;

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
