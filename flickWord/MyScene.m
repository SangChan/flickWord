//
//  MyScene.m
//  flickWord
//
//  Created by SangChan on 2014. 8. 29..
//  Copyright (c) 2014년 sangchan. All rights reserved.
//

#import "MyScene.h"
#import "Bubble.h"
#import "Magnet.h"

@interface MyScene () {
    
}

@end

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor blackColor];
        
        SKPhysicsBody *borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(self.frame.origin.x, self.frame.origin.y+20, self.frame.size.width, self.frame.size.height-20)];
        self.physicsBody = borderBody;
        self.physicsBody.friction = 1.0f;
        
        self.physicsWorld.contactDelegate = self;
        self.physicsWorld.gravity = CGVectorMake(0.0, -9.8);
        [self settingBubbles];
    }
    return self;
}

-(void)settingBubbles {
    CGPoint centerPos = CGPointMake(self.size.width * 0.5, self.size.height * 0.5 );
    Bubble *bubble_a = [Bubble bubbleWithLetter:@"A"];
    bubble_a.position = CGPointMake(centerPos.x - 100, centerPos.y);
    [self addChild:bubble_a];
    
    Magnet *magnet_a = [Magnet magnetWithLetter:@"A"];
    magnet_a.position = CGPointMake(centerPos.x-100, centerPos.y+180);
    [magnet_a.magnetBodyList addObject:bubble_a];
    [self addChild:magnet_a];
    
    Bubble *bubble_b = [Bubble bubbleWithLetter:@"B"];
    bubble_b.position = CGPointMake(centerPos.x, centerPos.y);
    [self addChild:bubble_b];
    
    Magnet *magnet_b = [Magnet magnetWithLetter:@"B"];
    magnet_b.position = CGPointMake(centerPos.x, centerPos.y+180);
    [magnet_b.magnetBodyList addObject:bubble_b];
    [self addChild:magnet_b];
    
    Bubble *bubble_c = [Bubble bubbleWithLetter:@"C"];
    bubble_c.position = CGPointMake(centerPos.x + 100, centerPos.y);
    [self addChild:bubble_c];
    
    Magnet *magnet_c = [Magnet magnetWithLetter:@"C"];
    magnet_c.position = CGPointMake(centerPos.x+100, centerPos.y+180);
    [magnet_c.magnetBodyList addObject:bubble_c];
    [self addChild:magnet_c];

}
//
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    /* Called when a touch begins */
//}
//
-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    for (SKNode *childNode in [self children]) {
        if ([childNode respondsToSelector:@selector(update:)] && [childNode isKindOfClass:[Magnet class]]) {
            [(Magnet *)childNode update:currentTime];
        }
    }
}

@end
