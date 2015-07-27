//
//  UIButton+Custom.h
//  flickWord
//
//  Created by SangChan on 2015. 4. 1..
//  Copyright (c) 2015년 sangchan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+FontAwesome.h"
@interface UIButton (Custom)

-(void)defaultStyle;
-(void)circleStyle;
-(void)grayCircleStyle;
-(void)darkCircleStyle;
-(void)setAwesomeIcon:(FAIcon)iconID;

@end
