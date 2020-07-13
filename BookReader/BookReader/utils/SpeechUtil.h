//
//  SpeechUtil.h
//  BookReader
//
//  Created by dfang on 2020-7-13.
//  Copyright © 2020 east. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpeechUtil : NSObject

// 语音合成代理
@property(nonatomic, weak) id<AVSpeechSynthesizerDelegate> delegate;

// 当前是否正在语音读
@property (nonatomic, assign, readonly) BOOL isSpeaking;

// 开始语音读speechContent内容
- (void)startSpeechWithContent:(NSString *)speechContent;
// 停止语音
- (void)stopSpeech;

@end

NS_ASSUME_NONNULL_END
