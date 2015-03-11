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
        self.physicsWorld.gravity = CGVectorMake(0.0, -4.9);
    }
    return self;
}

-(void)setWord:(NSString *)word Description:(NSString *)wordDescription
{
    CGPoint centerPos = CGPointMake(self.size.width * 0.5, self.size.height * 0.5 );
    _word = word;
    _wordDescription = wordDescription;
    
    int widthPerBall = self.size.width / BALL_SIZE;
    int heightPerBall = self.size.height / BALL_SIZE;
    int wordLength = (int)[_word length];
    int letter_limit = (widthPerBall > wordLength) ? wordLength : widthPerBall;
    
    for (int i = 0; i < wordLength; i++) {
        NSDictionary *dicData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSString stringWithFormat:@"%C", [_word characterAtIndex:i]], @"character",
                                 [NSNumber numberWithFloat:centerPos.x - (BALL_SIZE/2 * (letter_limit/2)) + (BALL_SIZE/2 *(i%letter_limit))],@"bubble_x",
                                 [NSNumber numberWithFloat:centerPos.y - BALL_SIZE],@"bubble_y",
                                 [NSNumber numberWithFloat:centerPos.x - (BALL_SIZE * (letter_limit/2)) + (BALL_SIZE *(i%letter_limit))],@"magnet_x",
                                 [NSNumber numberWithFloat:centerPos.y + (BALL_SIZE * (heightPerBall/3)) - (BALL_SIZE * (i/letter_limit))],@"magnet_y",
                                 nil];
        [self performSelector:@selector(setBubbleAndMagnet:) withObject:dicData afterDelay:0.25f*(i+1)];
    }
    
    SKLabelNode *descLabel = [SKLabelNode labelNodeWithText:_wordDescription];
    descLabel.fontName = @"Chalkduster";
    descLabel.fontSize = 36;
    descLabel.fontColor = [UIColor grayColor];
    descLabel.position = centerPos;
    descLabel.alpha = 0.7f;
    [self addChild:descLabel];
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
    [self addChild:magnet];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    for (SKNode *childNode in [self children]) {
        if ([childNode respondsToSelector:@selector(update)]) {
            [childNode performSelector:@selector(update)];
        }
    }
}

@end
