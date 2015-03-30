//
//  ViewController.m
//  flickWord
//
//  Created by SangChan on 2014. 8. 29..
//  Copyright (c) 2014년 sangchan. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
@import WebKit;

@implementation ViewController
@synthesize word;

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

- (BOOL)shouldAutorotate
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)setButtons
{
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.origin.x + 5, self.view.frame.origin.y + 5 , 50, 50)];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popThisView) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f]];
    [self.view addSubview:backButton];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    UIButton *speakButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 65, self.view.frame.origin.y + 5 , 55, 50)];
    [speakButton setTitle:@"Speak" forState:UIControlStateNormal];
    [speakButton addTarget:self action:@selector(speakWord) forControlEvents:UIControlEventTouchUpInside];
    [speakButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f]];
    [self.view addSubview:speakButton];
#endif
    
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
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc]init];
    [synthesizer setDelegate:self];
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:[word word]];
    [utterance setVoice:[AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"]];
    [utterance setRate:0.2f];
    [synthesizer speakUtterance:utterance];
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
}

@end
