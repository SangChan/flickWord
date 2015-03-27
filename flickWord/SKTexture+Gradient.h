//
//  SKTexture+Gradient.h
//  flickWord
//
//  Created by SangChan on 2015. 3. 27..
//  Copyright (c) 2015년 sangchan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKTexture(Gradeint)

+(SKTexture*)textureWithVerticalGradientofSize:(CGSize)size topColor:(CIColor*)topColor bottomColor:(CIColor*)bottomColor;

@end
