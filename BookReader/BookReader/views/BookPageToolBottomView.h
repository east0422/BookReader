//
//  BookPageToolBottomView.h
//  BookReader
//
//  Created by dfang on 2020-7-4.
//  Copyright © 2020 east. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    BookPageChangeFontIncrease,
    BookPageChangeFontDecrease,
} BookPageChangeFontType;

@protocol BookPageToolBottomViewDelegate <NSObject>

// 点击阅读模式按钮
- (void)readModeClicked:(UIButton *)btn;
// 点击章节列表按钮
- (void)chapterListClicked:(UIButton *)btn;
// 字体按钮
- (void)changeFontToSize:(NSInteger)fontSize;

@end

@interface BookPageToolBottomView : UIView

@property (nonatomic, weak) id<BookPageToolBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
