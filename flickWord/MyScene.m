//
//  MyScene.m
//  flickWord
//
//  Created by SangChan on 2014. 8. 29..
//  Copyright (c) 2014년 sangchan. All rights reserved.
//

#import "MyScene.h"
#import "Bubble.h"

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor blackColor];
        
        SKPhysicsBody *borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsBody = borderBody;
        self.physicsBody.friction = 1.0f;
        
        self.physicsWorld.contactDelegate = self;
        self.physicsWorld.gravity = CGVectorMake(0.0, -9.8);
        [self settingBubbles];
    }
    return self;
}

-(void)settingBubbles {
    Bubble *bubble_a = [Bubble bubbleWithLetter:@"A"];
    bubble_a.position = CGPointMake(self.size.width * 0.5 - 150, self.size.height * 0.5);
    [self addChild:bubble_a];
    
    Bubble *bubble_b = [Bubble bubbleWithLetter:@"B"];
    bubble_b.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5);
    [self addChild:bubble_b];
    
    Bubble *bubble_c = [Bubble bubbleWithLetter:@"C"];
    bubble_c.position = CGPointMake(self.size.width * 0.5 + 150, self.size.height * 0.5);
    [self addChild:bubble_c];
}
//
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    /* Called when a touch begins */
//}
//
-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    for (SKNode *node in [self children]) {
        if ([node isKindOfClass:[Bubble class]]) {
        }
    }
}

@end
