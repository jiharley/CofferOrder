//
//  DropDownCell.m
//  DropDownTest
//
//  Created by Florian Krüger on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DropDownCell.h"


@implementation DropDownCell

@synthesize textLabel, arrow_up, arrow_down;

- (void) setCellOpenImage 
{
    arrow_down.image = [UIImage imageNamed:@"arrow_up.png"];
//    [arrow_down setHidden:YES];
//    [arrow_up setHidden:NO];
//    [self setIsOpen:YES];
}

- (void) setCellClosedImage
{
    arrow_down.image = [UIImage imageNamed:@"arrow_down.png"];
//    [arrow_down setHidden:NO];
//    [arrow_up setHidden:YES];
//    [self setIsOpen:NO];
}

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

//- (void)dealloc
//{
//    [super dealloc];
//}

@end
