//
//  ViewController.h
//  flickWord
//

//  Copyright (c) 2014년 sangchan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>
#import "WordDictionary.h"

@interface ViewController : UIViewController <AVSpeechSynthesizerDelegate>

@property (nonatomic) WordDictionary *word;

@end
