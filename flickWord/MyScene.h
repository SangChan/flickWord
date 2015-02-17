//
//  MyScene.h
//  flickWord
//

//  Copyright (c) 2014년 sangchan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene <SKPhysicsContactDelegate> {
    NSString * _word;
    NSString * _wordDescription;
}

-(void)setWord:(NSString *)word Description:(NSString *)wordDescription;


@end
