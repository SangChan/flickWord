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
    
    MyScene * scene = [MyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [scene setPhysicsBorderWithOriginY:[UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height];
    [scene setWord:[word word] Description:[word word_description]];
    // Present the scene.
    [skView presentScene:scene];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(popThisView) name:@"popThisView" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    
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

- (void)popThisView
{
    [self.parentViewController.navigationController popViewControllerAnimated:YES];
}

@end
