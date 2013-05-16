//
//  AboutUsCell.h
//  CoffeeOrder
//
//  Created by 史 丹青 on 13-5-9.
//  Copyright (c) 2013年 tj . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutUsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *restaurantName;
@property (strong, nonatomic) IBOutlet UILabel *addressCN;
@property (strong, nonatomic) IBOutlet UILabel *addressEN;
@property (strong, nonatomic) IBOutlet UILabel *businessHourAndPhone;
@end
