//
//  MySpeachObject.m
//  flickWord
//
//  Created by SangChan on 2015. 7. 10..
//  Copyright (c) 2015년 sangchan. All rights reserved.
//

#import "MySpeechObject.h"

@implementation MySpeechObject

static MySpeechObject *sharedMyObject = nil;
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyObject = [[super alloc] init];
    });
    return sharedMyObject;
}

- (void)initSynthesizerWithWord:(NSString *)word {
    _synthesizer = [[AVSpeechSynthesizer alloc]init];
    [_synthesizer setDelegate:self];
    _utterance = [AVSpeechUtterance speechUtteranceWithString:word];
    [_utterance setVoice:[AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"]];
    [_utterance setRate:0.1f];
    [_utterance setPreUtteranceDelay:0.0];
}

-(void)play {
    if (![_synthesizer isSpeaking]) {
        [_synthesizer speakUtterance:_utterance];
    }

}

@end
