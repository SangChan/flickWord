//
//  Magnet.h
//  flickWord
//
//  Created by SangChan on 2015. 2. 11..
//  Copyright (c) 2015년 sangchan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Magnet : SKNode {
    BOOL _active;
    float _force;
    float _radius;
    NSString *_letter;
}

@property (nonatomic) NSString* letter;

+ (instancetype)magnetWithLetter:(NSString *)letter;
+ (instancetype)magnetWithForce:(float)force Radius:(float)raidus Letter:(NSString *)letter;
- (instancetype)initWithForce:(float)force Radius:(float)raidus Letter:(NSString *)letter;
- (void)update;

@end
