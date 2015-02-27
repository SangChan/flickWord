//
//  Bubble.h
//  flickWord
//
//  Created by SangChan on 2015. 2. 6..
//  Copyright (c) 2015년 sangchan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Bubble : SKNode {
    BOOL _grabbed;
    NSString* _letter;
    CGPoint _previousPos;
    CGPoint _previousVelocity;

}

@property (nonatomic) BOOL grabbed;
@property (nonatomic) NSString* letter;

+ (instancetype)bubbleWithLetter:(NSString *)letter;
- (instancetype)initWithLetter:(NSString *)letter;
- (void)update;
@end
