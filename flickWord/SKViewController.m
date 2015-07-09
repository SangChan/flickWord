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

@import WebKit;

@interface SKViewController () {
    AVSpeechSynthesizer *_synthesizer;
    AVSpeechUtterance *_utterance;
    UIButton *_speakButton;
    UIButton *_pauseButton;
}

@end

@implementation SKViewController
@synthesize word;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^{
        _synthesizer = [[AVSpeechSynthesizer alloc]init];
        [_synthesizer setDelegate:self];
        _utterance = [AVSpeechUtterance speechUtteranceWithString:[word word]];
        [_utterance setVoice:[AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"]];
        [_utterance setRate:0.1f];
        [_utterance setPreUtteranceDelay:0.0];
    });

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

-(void)speakWord
{
    if (![_synthesizer isSpeaking]) {
        [_synthesizer speakUtterance:_utterance];
    }
}

-(void)pauseView
{
    SKView *skView = (SKView *)self.view;
    skView.paused = !skView.paused;
    [_pauseButton setAwesomeIcon:(skView.paused)?FAPlay:FAPause];
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance
{
    _speakButton.enabled = NO;
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
    _speakButton.enabled = YES;
}

@end
