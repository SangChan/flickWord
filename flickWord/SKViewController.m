//
//  ViewController.m
//  flickWord
//
//  Created by SangChan on 2014. 8. 29..
//  Copyright (c) 2014년 sangchan. All rights reserved.
//

#import "SKViewController.h"
#import "MyScene.h"
#import "NSString+FontAwesome.h"
#import "UIButton+Custom.h"
#import "MySpeechObject.h"

@import WebKit;

@interface SKViewController () {
    UIButton *_speakButton;
    UIButton *_pauseButton;
}

@end

@implementation SKViewController
@synthesize word;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Configure the view.
    
    self.title = [word word];
    
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    
    // Create and configure the scene.
    CGFloat originY = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height;
    
    MyScene * scene = [MyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [scene setPhysicsBorderWithOriginY:originY];
    [scene setWord:[word word] Description:[word word_description]];
    // Present the scene.
    [skView presentScene:scene];
    
    [self setButtons];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(popThisView) name:@"popThisView" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"popThisView" object:nil];
    [super viewWillDisappear:animated];
}

/*- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)setButtons
{
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.origin.x + 5, self.view.frame.origin.y + 5 , 35, 35)];
    [backButton darkCircleStyle];
    [backButton setAwesomeIcon:FAChevronLeft];
    [backButton addTarget:self action:@selector(popThisView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];

/*
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    _speakButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 40, self.view.frame.origin.y + 5 , 35, 35)];
    [_speakButton darkCircleStyle];
    [_speakButton setAwesomeIcon:@"fa-play"];
    [_speakButton addTarget:self action:@selector(speakWord) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_speakButton];
#endif
*/
    _pauseButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 40, self.view.frame.origin.y + 5 , 35, 35)];
    [_pauseButton darkCircleStyle];
    [_pauseButton setAwesomeIcon:FAPause];
    [_pauseButton addTarget:self action:@selector(pauseView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_pauseButton];
    
}


- (void)popThisView
{
    [self.parentViewController.navigationController popViewControllerAnimated:YES];
}

-(void)showWordDefinitionViewController
{
    UIReferenceLibraryViewController *referenceLibraryViewController = [[UIReferenceLibraryViewController alloc] initWithTerm:[word word]];
    [self presentViewController:referenceLibraryViewController
                                 animated:YES
                               completion:nil];
}


-(void)pauseView
{
    SKView *skView = (SKView *)self.view;
    skView.paused = !skView.paused;
    [_pauseButton setAwesomeIcon:(skView.paused)?FAPlay:FAPause];
    
//    MySpeechObject *speechObject = [MySpeechObject sharedInstance];
//    [speechObject initSynthesizerWithWord:[word word]];
//    [speechObject play];

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

/*
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance
{
    _speakButton.enabled = NO;
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
    _speakButton.enabled = YES;
}
*/
@end
