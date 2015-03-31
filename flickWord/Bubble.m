//
//  Bubble.m
//  flickWord
//
//  Created by SangChan on 2015. 2. 6..
//  Copyright (c) 2015년 sangchan. All rights reserved.
//

#import "Bubble.h"
#import "ConstFunc.h"
#import "MyScene.h"

@implementation Bubble
@synthesize grabbed = _grabbed;
@synthesize letter = _letter;

static const uint32_t wall = 0x1 << 0;
static const uint32_t bubble = 0x1 << 1;

+ (instancetype)bubbleWithLetter:(NSString *)letter
{
    return [[Bubble alloc]initWithLetter:letter];
}

- (instancetype)initWithLetter:(NSString *)letter
{
    self = [super init];
    if (!self) return nil;
    self.name = letter;
    SKSpriteNode *circle = [SKSpriteNode spriteNodeWithImageNamed:@"bubble"];
    [self addChild:circle];
    
    _letter = letter;
    
    SKLabelNode *letterLabel = [[SKLabelNode alloc]initWithFontNamed:@"Chalkduster"];
    letterLabel.text = _letter;
    letterLabel.fontSize = 48;
    letterLabel.fontColor = [UIColor whiteColor];
    letterLabel.position = CGPointMake(self.position.x, self.position.y-15);
    
    [self addChild:letterLabel];
    
    SKPhysicsBody *body = [SKPhysicsBody bodyWithCircleOfRadius:circle.size.width * 0.5 center:CGPointZero];
    body.dynamic = YES;
    body.density = 2;
    body.restitution = 0.3f;
    body.usesPreciseCollisionDetection = YES;
    body.categoryBitMask = bubble;
    body.collisionBitMask = wall | bubble;
    body.contactTestBitMask = wall | bubble;
    self.physicsBody = body;
    self.userInteractionEnabled = YES;
    _grabbed=NO;
    
    self.xScale = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 1.0f : 0.7f;
    self.yScale = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 1.0f : 0.7f;
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self.parent];
    
    SKNode *touchNode = [self.parent nodeAtPoint:location];
    if (touchNode != nil && [touchNode.parent isEqual:self]) {
        _grabbed = YES;
        _previousPos =([self isOKToMove:location])? location : _previousPos;
        [self.physicsBody setAffectedByGravity:NO];
        NSLog(@"%@ touchBegan YES: %@ , pos : %@",self.name, touchNode, NSStringFromCGPoint(location));
    }
    else {
        NSLog(@"%@ touchBegan NO : %@ , pos : %@",self.name, touchNode, NSStringFromCGPoint(location));
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.physicsBody.dynamic && _grabbed) {
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInNode:self.parent];
    
        _previousVelocity = ccpMult(ccpSub(location, _previousPos),5);
        _previousPos =([self isOKToMove:location])? location : _previousPos;
        NSLog(@"%@ touchMoved pos : %@",self.name, NSStringFromCGPoint(location));
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.physicsBody.dynamic && _grabbed) {
        _grabbed=NO;
        [self.physicsBody setAffectedByGravity:YES];
        if (ccpLength(_previousVelocity) > 90) {
            [self runAction:[SKAction playSoundFileNamed:@"hwick.wav" waitForCompletion:NO]];
        }
        
        [self.physicsBody applyImpulse:CGVectorMake(_previousVelocity.x, _previousVelocity.y)];
        NSLog(@"%@ touchEnded pos : vector_length = %f",self.name,ccpLength(_previousVelocity));
    }
}

- (void)update
{
    if (self.physicsBody.dynamic && _grabbed)
    {
        self.position = _previousPos;
        self.physicsBody.velocity = CGVectorMake(0.0,0.0);
    }
}

- (BOOL)isOKToMove:(CGPoint)newPoint
{
    CGRect borderRect = [(MyScene *)self.parent borderRect];
    return (newPoint.x > borderRect.origin.x && newPoint.x < borderRect.size.width && newPoint.y > borderRect.origin.y && newPoint.y < borderRect.size.height);
}


@end
