//
//  MySpeachObject.h
//  flickWord
//
//  Created by SangChan on 2015. 7. 10..
//  Copyright (c) 2015년 sangchan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface MySpeechObject : NSObject <AVSpeechSynthesizerDelegate>{
    AVSpeechSynthesizer *_synthesizer;
    AVSpeechUtterance *_utterance;
}

+(instancetype)sharedInstance;
-(void)initSynthesizerWithWord:(NSString *)word;
-(void)play;

@end
