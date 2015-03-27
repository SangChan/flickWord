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
#import "SKTexture+Gradient.h"

#define HORIZONTAL_MARGIN 10
#define VERTICAL_MARGIN 10


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
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 62 : 44;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
        if (self.size.width < self.size.height) {
            self.size = CGSizeMake(self.size.height, self.size.width);
        }
        
        /* Setup your scene here */
        self.name = @"MyScene";
        
        [self setBackGroundGradientColor];
        
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(matchLetter) name:@"matchLetter" object:nil];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"matchLetter" object:nil];
}

-(void)setBackGroundGradientColor
{
    CIColor *topColor = [CIColor colorWithRed:0.03 green:0.16 blue:0.31 alpha:1];
    CIColor *middleColor = [CIColor colorWithRed:0.49 green:0.73 blue:0.74 alpha:1];
    CIColor *bottomColor = [CIColor colorWithRed:0.93 green:0.51 blue:0.23 alpha:1];
    
    SKTexture *texture1 = [SKTexture textureWithVerticalGradientofSize:CGSizeMake(self.size.width*2, self.size.height/2) topColor:topColor bottomColor:middleColor];
    SKSpriteNode *bgNode1 = [SKSpriteNode spriteNodeWithTexture:texture1];
    [bgNode1 setPosition:CGPointMake(0, (self.size.height + bgNode1.size.height) * 0.5)];
    [self addChild:bgNode1];
    
    SKTexture *texture2 = [SKTexture textureWithVerticalGradientofSize:CGSizeMake(self.size.width*2, self.size.height/2) topColor:middleColor bottomColor:bottomColor];
    SKSpriteNode *bgNode2 = [SKSpriteNode spriteNodeWithTexture:texture2];
    [bgNode2 setPosition:CGPointMake(0, (self.size.height - bgNode2.size.height) * 0.5)];
    [self addChild:bgNode2];
}

-(void)setPhysicsBorderWithOriginY:(CGFloat)originY
{
    borderRect = CGRectMake(self.frame.origin.x+HORIZONTAL_MARGIN, self.frame.origin.y+VERTICAL_MARGIN, self.size.width-HORIZONTAL_MARGIN*2, self.size.height-originY-VERTICAL_MARGIN);
    SKPhysicsBody *borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:borderRect];
    self.physicsBody = borderBody;
    self.physicsBody.friction = 1.0f;
    
    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity = CGVectorMake(0.0, -4.9);
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
    
    descLabel = [[SKLabelNode alloc]initWithFontNamed:@"Chalkduster"];
    descLabel.text = wordDescription;
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
