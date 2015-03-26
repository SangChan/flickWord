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
    SKLabelNode *descLabel;
    int matchLetterCount;
    float totalLetterCount;
}

@end

@implementation MyScene
@synthesize borderRect;

-(int)getBallSize
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 62 : 43;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.name = @"MyScene";
        borderRect = CGRectMake(self.frame.origin.x+5, self.frame.origin.y+5, size.width-5, size.height-5);
        
        self.backgroundColor = [SKColor grayColor];
        
        SKPhysicsBody *borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:borderRect];
        self.physicsBody = borderBody;
        self.physicsBody.friction = 1.0f;
        
        self.physicsWorld.contactDelegate = self;
        self.physicsWorld.gravity = CGVectorMake(0.0, -4.9);
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(matchLetter) name:@"matchLetter" object:nil];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"matchLetter" object:nil];
}

-(void)setWord:(NSString *)word Description:(NSString *)wordDescription
{
    CGPoint centerPos = CGPointMake(self.size.width * 0.5, self.size.height * 0.5 );
    _word = word;
    _wordDescription = wordDescription;
    
    matchLetterCount = 0;
    totalLetterCount = [_word length];
    int ballSize = [self getBallSize];
    
    int widthPerBall = self.size.width / ballSize;
    int heightPerBall = self.size.height / ballSize;
    int wordLength = (int)[_word length];
    int letter_limit = (widthPerBall > wordLength) ? wordLength : widthPerBall;
    
    for (int i = 0; i < wordLength; i++) {
        NSDictionary *dicData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSString stringWithFormat:@"%C", [_word characterAtIndex:i]], @"character",
                                 [NSNumber numberWithFloat:centerPos.x - (ballSize/2 * (letter_limit/2)) + (ballSize/2 *(i%letter_limit))],@"bubble_x",
                                 [NSNumber numberWithFloat:centerPos.y - ballSize],@"bubble_y",
                                 [NSNumber numberWithFloat:centerPos.x - (ballSize * (letter_limit/2)) + (ballSize *(i%letter_limit))],@"magnet_x",
                                 [NSNumber numberWithFloat:centerPos.y + (ballSize * (heightPerBall/3)) - (ballSize * (i/letter_limit))],@"magnet_y",
                                 nil];
        [self performSelector:@selector(setBubbleAndMagnet:) withObject:dicData afterDelay:0.25f*(i+1)];
    }
    
    descLabel = [SKLabelNode labelNodeWithText:_wordDescription];
    descLabel.fontName = @"Chalkduster";
    descLabel.fontSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 36 : 24;
    descLabel.fontColor = [UIColor whiteColor];
    descLabel.position = centerPos;
    descLabel.alpha = 0.2f;
    [self addChild:descLabel];
}

-(void)setBubbleAndMagnet:(NSDictionary *)data
{
    NSString *character = [[data objectForKey:@"character"] uppercaseString];
    if ([character isEqualToString:@" "]) {
        totalLetterCount -= 1.0;
        return;
    }
    CGPoint bubblePos = CGPointMake([[data objectForKey:@"bubble_x"] floatValue], [[data objectForKey:@"bubble_y"] floatValue]);
    CGPoint magnetPos = CGPointMake([[data objectForKey:@"magnet_x"] floatValue], [[data objectForKey:@"magnet_y"] floatValue]);
    Bubble *bubble = [Bubble bubbleWithLetter:character];
    bubble.position = bubblePos;
    [self addChild:bubble];
    
    Magnet *magnet = [Magnet magnetWithLetter:character];
    magnet.position = magnetPos;
    [self addChild:magnet];
}

-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
    for (SKNode *childNode in [self children]) {
        if ([childNode respondsToSelector:@selector(update)]) {
            [childNode performSelector:@selector(update)];
        }
    }
}

-(void)matchLetter
{
    matchLetterCount++;
    descLabel.alpha = 0.2f+(matchLetterCount/totalLetterCount)*0.8f;
    if (matchLetterCount == (int)totalLetterCount) {
        [self speakWord:_word];
    }
}

-(void)speakWord:(NSString *)thisWord
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc]init];
    [synthesizer setDelegate:self];
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:thisWord];
    [utterance setVoice:[AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"]];
    [utterance setRate:0.2f];
    [synthesizer speakUtterance:utterance];
#else
    [self popThisView];
#endif
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
    [self popThisView];
}

- (void)popThisView
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"popThisView" object:nil];
}

@end
