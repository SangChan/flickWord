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
}

@end

@implementation SKViewController
@synthesize word;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"SKViewController"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
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
    [scene setWord:[word word] Description:[word wordDescription]];
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
    [backButton grayCircleStyle];
    [backButton setAwesomeIcon:FAChevronLeft];
    [backButton addTarget:self action:@selector(popThisView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
}


- (void)popThisView
{
    //[self.parentViewController.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)showWordDefinitionViewController
{
    UIReferenceLibraryViewController *referenceLibraryViewController = [[UIReferenceLibraryViewController alloc] initWithTerm:[word word]];
    [self presentViewController:referenceLibraryViewController
                                 animated:YES
                               completion:nil];
}

@end
