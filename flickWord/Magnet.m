//
//  Magnet.m
//  flickWord
//
//  Created by SangChan on 2015. 2. 11..
//  Copyright (c) 2015년 sangchan. All rights reserved.
//

#import "Magnet.h"
#import "Bubble.h"
#import "ConstFunc.h"

@implementation Magnet

@synthesize letter = _letter;

+ (instancetype)magnetWithLetter:(NSString *)letter
{
    return [[Magnet alloc] initWithForce:5000000 Radius:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 250 : 100 Letter:(NSString *)letter];
}

+ (instancetype)magnetWithForce:(float)force Radius:(float)raidus Letter:(NSString *)letter
{
    return [[Magnet alloc] initWithForce:force Radius:raidus Letter:(NSString *)letter];
}

- (instancetype)initWithForce:(float)force Radius:(float)raidus Letter:(NSString *)letter
{
    self = [super init];
    if (!self) return(nil);
    _active = YES;
    _force = force;
    _radius = raidus;
    _letter = letter;
    
    SKLabelNode *addedLabel = [SKLabelNode labelNodeWithText:letter];
    addedLabel.fontName = @"Chalkduster";
    addedLabel.fontSize = 48;
    addedLabel.fontColor = [UIColor whiteColor];
    addedLabel.position = CGPointMake(self.position.x, self.position.y-15);
    addedLabel.alpha = 0.7f;
    [self addChild:addedLabel];
    self.xScale = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 1.0f : 0.7f;
    self.yScale = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 1.0f : 0.7f;
    
    return self;
}

- (void)update
{
    // update needs not to be scheduled anymore. Just overriding update:, will automatically cause it to be called
    
    // if the sphere is grabbed, force it into position, and update its velocity.
    
    if (_active) {
        for (SKNode *node in [self.parent children]) {
            if ([node isKindOfClass:[Bubble class]]) {
                Bubble *bubbleBody = (Bubble *)node;
                CGPoint distance = ccpSub(self.position, bubbleBody.position);
                CGFloat r = ccpDistance(self.position, bubbleBody.position);
                if (r <= _radius && [[bubbleBody letter] isEqualToString:_letter]) {
                    CGPoint magneticForce = ccpMult(ccpNormalize(distance), _force/(r*r));
                    [bubbleBody.physicsBody applyForce:CGVectorMake(magneticForce.x, magneticForce.y)];
                    if (r < 20 && bubbleBody.physicsBody.dynamic) {
                        bubbleBody.position = self.position;
                        bubbleBody.physicsBody.velocity = CGVectorMake(0.0, 0.0);
                        bubbleBody.physicsBody.angularVelocity = 0.0;
                        [bubbleBody.physicsBody setDynamic:NO];
                        [bubbleBody.physicsBody setResting:YES];
                        [bubbleBody.physicsBody setAffectedByGravity:NO];
                        SKAction *rotateAction = [SKAction rotateToAngle:0.0 duration:0.7f];
                        [bubbleBody runAction:rotateAction completion:^{
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"matchLetter" object:nil];
                        }];
                    }
                }
            }
        }
    }
    
}



@end
