//
//  AddAddressView.h
//  CoffeeOrder
//
//  Created by tj  on 13-5-23.
//  Copyright (c) 2013年 tj . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressProcessView : UIView

- (id)initWithMessage:(NSString *)msg;
-(void) onlyShowMsg:(NSString *)msg;
- (void)removeView;
@property (strong, nonatomic) UILabel *messageLabel;
@end
