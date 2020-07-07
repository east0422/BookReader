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

@end

@interface BookPageToolTopView : UIView

@property (nonatomic, weak) id<BookPageToolTopViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
