//
//  MyScene.h
//  flickWord
//

//  Copyright (c) 2014년 sangchan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>

@interface MyScene : SKScene <SKPhysicsContactDelegate> {
    NSString * _word;
    NSString * _wordDescription;
}

@property (nonatomic, readonly) CGRect borderRect;
@property (strong) CMMotionManager* motionManager;

-(void)setPhysicsBorderWithOriginY:(CGFloat)originY;
-(void)setWord:(NSString *)word Description:(NSString *)wordDescription;


@end
