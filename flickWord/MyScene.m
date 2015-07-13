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

static const uint32_t wall = 0x1 << 0;
static const uint32_t bubble = 0x1 << 1;


@interface MyScene () {
    NSString * _word;
    NSString * _wordDescription;
    SKLabelNode *descLabel;
    int matchLetterCount;
    float totalLetterCount;
    SKAction *ppiyongSoundAction;
    SKAction *ppyockSoundAction;
    int timer;
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
        timer = 0;
        self.name = @"MyScene";
        ppiyongSoundAction = [SKAction playSoundFileNamed:@"ppiyong.wav" waitForCompletion:NO];
        ppyockSoundAction = [SKAction playSoundFileNamed:@"ppyock.wav" waitForCompletion:NO];
        [self setBackGroundGradientColor];
        
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(matchLetter) name:@"matchLetter" object:nil];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"matchLetter" object:nil];
}

-(void)didMoveToView:(SKView *)view
{
    [self showWordAndDescription];
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
    borderRect = CGRectMake(self.frame.origin.x+HORIZONTAL_MARGIN, self.frame.origin.y+VERTICAL_MARGIN, self.size.width-HORIZONTAL_MARGIN*2, self.size.height-VERTICAL_MARGIN);
    SKPhysicsBody *borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:borderRect];
    self.physicsBody = borderBody;
    self.physicsBody.friction = 1.0f;
    self.physicsBody.dynamic = NO;
    self.physicsBody.usesPreciseCollisionDetection = YES;
    self.physicsBody.categoryBitMask = wall;
    
    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity = CGVectorMake(0.0, -4.9);
}

-(void)setWord:(NSString *)word Description:(NSString *)wordDescription
{
    _word = word;
    _wordDescription = wordDescription;
}

-(void)showWordAndDescription
{
    CGPoint centerPos = CGPointMake(self.size.width * 0.5, self.size.height * 0.5 );
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
        [self performSelector:@selector(showBubbleAndMagnet:) withObject:dicData afterDelay:0.25f*(i+1)];
    }
    
    descLabel = [[SKLabelNode alloc]initWithFontNamed:@"Chalkduster"];
    descLabel.text = _wordDescription;
    descLabel.fontSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 36 : 24;
    descLabel.fontColor = [UIColor whiteColor];
    descLabel.position = centerPos;
    descLabel.alpha = 0.2f;
    [self addChild:descLabel];

}

-(void)showBubbleAndMagnet:(NSDictionary *)data
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
    
    //Maybe 1 second per 30 count.
    timer++;
}

-(void)matchLetter
{
    matchLetterCount++;
    descLabel.alpha = 0.2f+(matchLetterCount/totalLetterCount)*0.8f;
    if (matchLetterCount == (int)totalLetterCount) {
        //TODO : Matching word is over!
        [self applyBlurToView:self.view withEffectStyle:UIBlurEffectStyleDark andConstraints:YES];
    }
}

- (UIView *)applyBlurToView:(UIView *)view withEffectStyle:(UIBlurEffectStyle)style andConstraints:(BOOL)addConstraints
{
    //only apply the blur if the user hasn't disabled transparency effects
    if(!UIAccessibilityIsReduceTransparencyEnabled())
    {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:style];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = view.bounds;
        
        [view addSubview:blurEffectView];
        
        if(addConstraints)
        {
            //add auto layout constraints so that the blur fills the screen upon rotating device
            [blurEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
            
            [view addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:view
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1
                                                              constant:0]];
            
            [view addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:view
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1
                                                              constant:0]];
            
            [view addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView
                                                             attribute:NSLayoutAttributeLeading
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:view
                                                             attribute:NSLayoutAttributeLeading
                                                            multiplier:1
                                                              constant:0]];
            
            [view addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView
                                                             attribute:NSLayoutAttributeTrailing
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:view
                                                             attribute:NSLayoutAttributeTrailing
                                                            multiplier:1
                                                              constant:0]];
        }
    }
    else
    {
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    }
    
    return view;
}


-(void)didBeginContact:(SKPhysicsContact *)contact
{
    //NSLog(@"collison impulse : %f, contact normal vector.dx : %f , dy : %f",contact.collisionImpulse, contact.contactNormal.dx, contact.contactNormal.dy);
    if (contact.bodyA.categoryBitMask == wall && contact.bodyB.categoryBitMask == bubble) {
        if (contact.collisionImpulse > 90.0) {
            [contact.bodyA.node runAction:ppiyongSoundAction];
        }
    }
    else if (contact.bodyA.categoryBitMask == bubble && contact.bodyA.categoryBitMask == contact.bodyB.categoryBitMask) {
        if (contact.collisionImpulse > 30.0) {
            [contact.bodyA.node runAction:ppyockSoundAction];
        }
    }
}

@end
