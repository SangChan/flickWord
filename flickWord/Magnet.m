//
//  Magnet.m
//  flickWord
//
//  Created by SangChan on 2015. 2. 11..
//  Copyright (c) 2015년 sangchan. All rights reserved.
//

#import "Magnet.h"
#import "ConstFunc.h"

@implementation Magnet

@synthesize magnetBodyList;

+ (instancetype)magnetWithLetter:(NSString *)letter
{
    return [[Magnet alloc] initWithForce:5000000 Radius:150 Letter:(NSString *)letter];
}

+ (instancetype)magnetWithForce:(float)force Radius:(float)raidus Letter:(NSString *)letter
{
    return [[Magnet alloc] initWithForce:force Radius:raidus Letter:(NSString *)letter];
}

- (instancetype)initWithForce:(float)force Radius:(float)raidus Letter:(NSString *)letter
{
    self = [super init];
    if (!self) return(nil);
    
    magnetBodyList = [NSMutableArray array];
    _active = YES;
    _force = force;
    _radius = raidus;
    _letter = letter;
    
    SKLabelNode *addedLabel = [SKLabelNode labelNodeWithText:letter];
    addedLabel.fontName = @"Chalkduster";
    addedLabel.fontSize = 48;
    addedLabel.fontColor = [UIColor whiteColor];
    addedLabel.position = CGPointMake(self.position.x, self.position.y-15);
    [self addChild:addedLabel];
    
    return self;
}

- (void)update:(CFTimeInterval)currentTime
{
    // update needs not to be scheduled anymore. Just overriding update:, will automatically cause it to be called
    
    // if the sphere is grabbed, force it into position, and update its velocity.
    
    if (_active) {
        for (SKNode *magnetBody in magnetBodyList) {
            CGPoint distance = ccpSub(self.position, magnetBody.position);
            CGFloat r = ccpDistance(self.position, magnetBody.position);
            NSLog(@"name : %@ , distance : %f",magnetBody.name, r);
            if (r <= _radius) {
                if (r < 20) {
                    magnetBody.position = self.position;
                    magnetBody.physicsBody.velocity = CGVectorMake(0.0, 0.0);
                    magnetBody.physicsBody.angularVelocity = 0.0;
                    [magnetBody.physicsBody setResting:YES];
                    //CCActionRotateTo *rotateTo = [CCActionRotateTo actionWithDuration:1.0f angle:0.0];
                    //[magnetBody runAction:[CCActionRepeatForever actionWithAction:rotateTo]];
                }
                else {
                    CGPoint magneticForce = ccpMult(ccpNormalize(distance), _force/(r*r));
                    [magnetBody.physicsBody applyForce:CGVectorMake(magneticForce.x, magneticForce.y)];
                }
            }
        }
    }
    
}



@end
