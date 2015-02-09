//
//  MyScene.h
//  flickWord
//

//  Copyright (c) 2014년 sangchan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene <SKPhysicsContactDelegate> {
    BOOL touchOn;
    CGPoint touchPos;
}

@end
