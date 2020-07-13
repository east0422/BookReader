//
//  BookPageToolTopView.h
//  BookReader
//
//  Created by dfang on 2020-7-4.
//  Copyright © 2020 east. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class BookPageToolTopView;

@protocol BookPageToolTopViewDelegate <NSObject>

// 点击返回按钮响应事件
- (void)backInBookPageToolTopView:(BookPageToolTopView *)topView;
// 点击语音按钮响应事件，对文本进行开始读或停止读(isSpeech为YES开始读，NO停止读)
- (void)speechInBookPageToolTopView:(BOOL)isSpeech;

@end

@interface BookPageToolTopView : UIView

@property (nonatomic, weak) id<BookPageToolTopViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
