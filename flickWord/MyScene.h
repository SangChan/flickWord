//
//  MyScene.h
//  flickWord
//

//  Copyright (c) 2014년 sangchan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MyScene : SKScene <SKPhysicsContactDelegate> {
    NSString * _word;
    NSString * _wordDescription;
}

@property (nonatomic, readonly) CGRect borderRect;

-(void)setPhysicsBorderWithOriginY:(CGFloat)originY;
-(void)setWord:(NSString *)word Description:(NSString *)wordDescription;


@end
