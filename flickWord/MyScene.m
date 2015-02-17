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

#define BALL_SIZE 62


-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor blackColor];
        
        SKPhysicsBody *borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(self.frame.origin.x, self.frame.origin.y+20, self.frame.size.width, self.frame.size.height-20)];
        self.physicsBody = borderBody;
        self.physicsBody.friction = 1.0f;
        
        self.physicsWorld.contactDelegate = self;
        self.physicsWorld.gravity = CGVectorMake(0.0, -9.8);
        //[self settingBubbles];
    }
    return self;
}

-(void)setWord:(NSString *)word Description:(NSString *)wordDescription
{
    CGPoint centerPos = CGPointMake(self.size.width * 0.5, self.size.height * 0.5 );
    int letter_limit = self.size.width / BALL_SIZE;
    _word = word;
    _wordDescription = wordDescription;
    for (int i = 0; i < [_word length]; i++) {
        //[array addObject:];
        //NSLog(@"%@",[NSString stringWithFormat:@"%C", [_word characterAtIndex:i]]);
        NSDictionary *dicData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSString stringWithFormat:@"%C", [_word characterAtIndex:i]], @"character",
                                 [NSNumber numberWithFloat:centerPos.x - (BALL_SIZE/2 * (letter_limit/2)) + (BALL_SIZE/2 *(i%letter_limit))],@"bubble_x",
                                 [NSNumber numberWithFloat:centerPos.y],@"bubble_y",
                                 [NSNumber numberWithFloat:centerPos.x - (BALL_SIZE * (letter_limit/2)) + (BALL_SIZE *(i%letter_limit))],@"magnet_x",
                                 [NSNumber numberWithFloat:centerPos.y + 220 - (BALL_SIZE * (i/letter_limit))],@"magnet_y",
                                 nil];
        [self performSelector:@selector(setBubbleAndMagnet:) withObject:dicData afterDelay:(4.0f/[_word length])*(i+1)];
    }
}

-(void)setBubbleAndMagnet:(NSDictionary *)data
{
    NSString *character = [[data objectForKey:@"character"] uppercaseString];
    CGPoint bubblePos = CGPointMake([[data objectForKey:@"bubble_x"] floatValue], [[data objectForKey:@"bubble_y"] floatValue]);
    CGPoint magnetPos = CGPointMake([[data objectForKey:@"magnet_x"] floatValue], [[data objectForKey:@"magnet_y"] floatValue]);
    Bubble *bubble = [Bubble bubbleWithLetter:character];
    bubble.position = bubblePos;
    [self addChild:bubble];
    
    Magnet *magnet = [Magnet magnetWithLetter:character];
    magnet.position = magnetPos;
    [magnet.magnetBodyList addObject:bubble];
    [self addChild:magnet];
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
        if ([childNode respondsToSelector:@selector(update)]) {
            [childNode performSelector:@selector(update)];
        }
    }
}

@end
