//
//  Bubble.m
//  flickWord
//
//  Created by SangChan on 2015. 2. 6..
//  Copyright (c) 2015년 sangchan. All rights reserved.
//

#import "Bubble.h"
#import "ConstFunc.h"

@implementation Bubble

+(instancetype)bubbleWithLetter:(NSString *)letter
{
    return [[Bubble alloc]initWithLetter:letter];
}

-(instancetype)initWithLetter:(NSString *)letter
{
    self = [super init];
    if (!self) return nil;
    self.name = letter;
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
    body.mass = 100;
    body.density = 3;
    //body.friction = 0.3f;
    body.restitution = 0.3f;
    //body.collisionBitMask = 2;
    
    self.physicsBody = body;
    
    self.userInteractionEnabled = YES;
    _grabbed=NO;
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //_grabbed=YES;
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self.parent];
    
    SKNode *touchNode = [self.parent nodeAtPoint:location];
    if (touchNode != nil && [touchNode.parent isEqual:self]) {
        _grabbed = YES;
        _previousPos =location;
        [self.physicsBody setAffectedByGravity:NO];
        NSLog(@"%@ touchBegan YES: %@ , pos : %@",self.name, touchNode, NSStringFromCGPoint(location));
    }
    else {
        NSLog(@"%@ touchBegan NO : %@ , pos : %@",self.name, touchNode, NSStringFromCGPoint(location));
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_grabbed) {
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInNode:self.parent];
    
        _previousVelocity = ccpMult(ccpSub(location, _previousPos),5);
        _previousPos =location;
        self.position = location;
        [self.physicsBody setAffectedByGravity:NO];
        NSLog(@"%@ touchMoved pos : %@",self.name, NSStringFromCGPoint(location));
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_grabbed) {
        _grabbed=NO;
        [self.physicsBody setAffectedByGravity:YES];
        [self.physicsBody applyImpulse:CGVectorMake(_previousVelocity.x, _previousVelocity.y)];
        NSLog(@"%@ touchEnded pos",self.name);
    }
}

@end
