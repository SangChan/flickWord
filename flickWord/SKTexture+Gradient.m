//
//  SKTexture+Gradient.m
//  flickWord
//
//  Created by SangChan on 2015. 3. 27..
//  Copyright (c) 2015년 sangchan. All rights reserved.
//

#import "SKTexture+Gradient.h"

@implementation SKTexture(Gradient)

+(SKTexture*)textureWithVerticalGradientofSize:(CGSize)size topColor:(CIColor*)topColor bottomColor:(CIColor*)bottomColor
{
    CIContext *coreImageContext = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIFilter *gradientFilter = [CIFilter filterWithName:@"CILinearGradient"];
    [gradientFilter setDefaults];
    CIVector *startVector = [CIVector vectorWithX:size.width/2 Y:0];
    CIVector *endVector = [CIVector vectorWithX:size.width/2 Y:size.height];
    [gradientFilter setValue:startVector forKey:@"inputPoint0"];
    [gradientFilter setValue:endVector forKey:@"inputPoint1"];
    [gradientFilter setValue:bottomColor forKey:@"inputColor0"];
    [gradientFilter setValue:topColor forKey:@"inputColor1"];
    CGImageRef cgimg = [coreImageContext createCGImage:[gradientFilter outputImage]
                                              fromRect:CGRectMake(0, 0, size.width, size.height)];
    return [SKTexture textureWithImage:[UIImage imageWithCGImage:cgimg]];
}

@end
