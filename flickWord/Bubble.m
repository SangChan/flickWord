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
    letterLabel.position = CGPointMake(self.position.x, self.position.y-15);
    [self addChild:letterLabel];
    
    SKPhysicsBody *body = [SKPhysicsBody bodyWithCircleOfRadius:circle.size.width * 0.5 center:CGPointZero];
    body.dynamic = YES;
    //body.density = 1.0f;
    body.friction = 0.4f;
    body.restitution = 0.6f;
    body.collisionBitMask = 2;
    
    self.physicsBody = body;
    
    self.userInteractionEnabled = YES;
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    touchOn=YES;
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self.parent];
    touchPos =location;
    [self.physicsBody setVelocity:CGVectorMake(0, 0)];
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    touchOn=YES;
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self.parent];
    touchPos =location;
    self.position = touchPos;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    touchOn=NO;
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    touchOn=NO;
}
-(void)update:(CFTimeInterval)dt{
    if (touchOn) {
        CGVector vector = CGVectorMake((touchPos.x-self.position.x)/dt, (touchPos.y-self.position.y)/dt);
        self.physicsBody.velocity=vector;
    }
}
@end
