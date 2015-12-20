//
//  ViewController.h
//  flickWord
//

//  Copyright (c) 2014년 sangchan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Google/Analytics.h>
#import "EnglishWord.h"

@interface SKViewController : UIViewController <AVSpeechSynthesizerDelegate>

@property (nonatomic) EnglishWord *word;

@end
