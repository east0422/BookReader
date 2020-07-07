//
//  BookPageViewController.h
//  BookReader
//
//  Created by dfang on 2020-7-3.
//  Copyright © 2020 east. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BookPageViewController : UIViewController

// 内容视图attributedText
@property (nonatomic, strong) NSMutableAttributedString *content;
// 内容视图text
@property (nonatomic, copy) NSString *text;

// 更新UI
- (void)updateUI;
// 以传递过来的颜色参数更新UI
- (void)updateUIBgColor:(UIColor *)bgColor withContentColor:(UIColor *)contentColor andTextColor:(UIColor *)textColor;
// 更改PageViewController页码索引
- (void)setCurPage:(NSInteger)curPage totalPages:(NSInteger)totalPages;

@end

NS_ASSUME_NONNULL_END
