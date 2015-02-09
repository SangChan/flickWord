//
//  Bubble.h
//  flickWord
//
//  Created by SangChan on 2015. 2. 6..
//  Copyright (c) 2015년 sangchan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Bubble : SKNode {
    BOOL touchOn;
    CGPoint touchPos;

}


+(instancetype)bubbleWithLetter:(NSString *)letter;
-(instancetype)initWithLetter:(NSString *)letter;
-(void)update:(CFTimeInterval)dt;
@end