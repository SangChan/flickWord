//
//  UIButton+Custom.m
//  flickWord
//
//  Created by SangChan on 2015. 4. 1..
//  Copyright (c) 2015년 sangchan. All rights reserved.
//

#import "UIButton+Custom.h"
#import "NSString+FontAwesome.h"

@implementation UIButton (Custom)

-(void)defaultStyle
{
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 4.0;
    self.layer.masksToBounds = YES;
    [self setAdjustsImageWhenHighlighted:NO];
    [self setTitleColor:[UIColor colorWithRed:0.05 green:0.58 blue:0.99 alpha:1.0] forState:UIControlStateNormal];
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [[UIColor colorWithRed:0.05 green:0.58 blue:0.99 alpha:1.0] CGColor];
}
-(void)circleStyle
{
    [self defaultStyle];
    self.layer.cornerRadius = self.frame.size.width / 2;
}

-(void)darkCircleStyle
{
    [self defaultStyle];
    self.layer.cornerRadius = self.frame.size.width / 2;
    [self setTitleColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.8] forState:UIControlStateNormal];
    self.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.6];
    self.layer.borderColor = [[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8]CGColor];
}

- (UIImage *) buttonImageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIGraphicsBeginImageContext(CGSizeMake(self.frame.size.width, self.frame.size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

-(void)setAwesomeIcon:(FAIcon)iconID
{
    self.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:self.titleLabel.font.pointSize];
    self.titleLabel.shadowOffset = CGSizeMake(0, -1);
    [self setTitle:[NSString fontAwesomeIconStringForEnum:iconID] forState:UIControlStateNormal];
}

@end
