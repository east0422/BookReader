//
//  SpeechUtil.m
//  BookReader
//
//  Created by dfang on 2020-7-13.
//  Copyright © 2020 east. All rights reserved.
//

#import "SpeechUtil.h"

@interface SpeechUtil ()

// 语音合成器
@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;

// 语速
@property (nonatomic, assign) float rate;
// 音量
@property (nonatomic, assign) float volume;
// 语言类型
@property (nonatomic, strong) AVSpeechSynthesisVoice *voiceType;

// 当前是否正在语音读(内部可读写，外部只读)
@property (nonatomic, assign, readwrite) BOOL isSpeaking;

@end

@implementation SpeechUtil

- (AVSpeechSynthesizer *)synthesizer {
    if (_synthesizer == nil) {
        _synthesizer = [[AVSpeechSynthesizer alloc] init];
    }
    return _synthesizer;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData {
    _rate = AVSpeechUtteranceDefaultSpeechRate;
    _volume = 1;
    _voiceType = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    _isSpeaking = YES;
}

- (void)setDelegate:(id<AVSpeechSynthesizerDelegate>)delegate {
    _delegate = delegate;
    self.synthesizer.delegate = delegate;
}

- (void)startSpeechWithContent:(NSString *)speechContent {
    AVSpeechUtterance *speechUtterance = [[AVSpeechUtterance alloc] initWithString:speechContent];
    speechUtterance.rate = self.rate;
    speechUtterance.volume = self.volume;
    speechUtterance.voice = self.voiceType;
    self.isSpeaking = YES;
    [self.synthesizer speakUtterance:speechUtterance];
}

- (void)stopSpeech {
    self.isSpeaking = NO;
    [self.synthesizer stopSpeakingAtBoundary:(AVSpeechBoundaryImmediate)];
}

@end
