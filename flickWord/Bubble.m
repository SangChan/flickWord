//
//  Bubble.m
//  flickWord
//
//  Created by SangChan on 2015. 2. 6..
//  Copyright (c) 2015년 sangchan. All rights reserved.
//

#import "Bubble.h"

@implementation Bubble

+(instancetype)bubbleWithLetter:(NSString *)letter
{
    return [[Bubble alloc]initWithLetter:letter];
}

-(instancetype)initWithLetter:(NSString *)letter
{
    self = [super init];
    if (!self) return nil;
    SKSpriteNode *circle = [SKSpriteNode spriteNodeWithImageNamed:@"bubble"];
    [self addChild:circle];
    
    SKLabelNode *letterLabel = [SKLabelNode labelNodeWithText:letter];
    letterLabel.fontName = @"Chalkduster";
    letterLabel.fontSize = 48;
    letterLabel.fontColor = [UIColor whiteColor];
    [self addChild:letterLabel];
    
    SKPhysicsBody *body = [SKPhysicsBody bodyWithCircleOfRadius:circle.size.width * 0.5 center:CGPointZero];
    body.dynamic = YES;
    body.density = 1.0f;
    body.friction = 0.5f;
    body.collisionBitMask = 2;
    
    self.physicsBody = body;
    
    return self;
}

@end
