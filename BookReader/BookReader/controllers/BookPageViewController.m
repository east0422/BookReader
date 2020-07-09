//
//  BookPageViewController.m
//  BookReader
//
//  Created by dfang on 2020-7-3.
//  Copyright © 2020 east. All rights reserved.
//

#import "BookPageViewController.h"
#import "UserDefaultUtil.h"
#import <Masonry/Masonry.h>

@interface BookPageViewController ()
// 显示章节内容文本视图
@property (nonatomic, strong) UITextView *contentView;
// 显示当前阅读章节页数和当前章节总页数进度标签
@property (nonatomic, strong) UILabel *pageLabel;
// 当前阅读章节页数
@property (nonatomic, assign) NSInteger curPage;
// 当前章节总页数
@property (nonatomic, assign) NSInteger totalPages;

@end

@implementation BookPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(20);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(60);
        make.width.mas_equalTo(self.view.mas_width).mas_offset(-40);
        make.height.mas_equalTo(self.view.mas_height).mas_offset(-100);
    }];
    [self.pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-20);
        make.top.mas_equalTo(self.view.mas_bottom).mas_offset(-30);
        make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.5);
        make.height.mas_equalTo(20);
    }];
}

- (void)initUI {
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.pageLabel];
    self.view.backgroundColor = [UIColor colorWithRed:250/255.0 green:244/255.0 blue:233/255.0 alpha:1];
}

- (void)updateUIBgColor:(UIColor *)bgColor withContentColor:(UIColor *)contentColor andTextColor:(UIColor *)textColor {
    self.view.backgroundColor = bgColor;
    [self.content addAttribute:NSForegroundColorAttributeName value:contentColor range:NSMakeRange(0, self.content.length)];
    self.contentView.attributedText = self.content;
    self.pageLabel.textColor = textColor;
}

- (void)updateUI {
    UIColor *bgColor = [UIColor colorWithRed:250/255.0 green:244/255.0 blue:233/255.0 alpha:1];
    UIColor *contentColor = [UIColor darkGrayColor];
    UIColor *textColor = [UIColor grayColor];
    
    if ([UserDefaultUtil isReadModeNight]) {
        bgColor = [UIColor colorWithRed:109/255.0 green:109/255.0 blue:111/255.0 alpha:1];
        contentColor = [UIColor lightTextColor];
        textColor = [UIColor lightTextColor];
    }
    
    [self updateUIBgColor:bgColor withContentColor:contentColor andTextColor:textColor];
}

- (void)setCurPage:(NSInteger)curPage totalPages:(NSInteger)totalPages {
    self.curPage = curPage;
    self.totalPages = totalPages;
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)self.curPage + 1, (long)self.totalPages];
}

- (void)setContent:(NSMutableAttributedString *)content {
    _content = content;
    [self updateUI];
}

- (void)setText:(NSString *)text {
    _text = text;
    self.contentView.text = text;
}

- (UITextView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UITextView alloc] init];
        _contentView.font = [UIFont fontWithName:@"PingFang SC" size:20];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.textColor = [UIColor darkGrayColor];
        _contentView.editable = NO;
        _contentView.scrollEnabled = NO;
        _contentView.selectable = NO;
        // 一定要设置为0，不然计算出的文字不能全部显示出来
        _contentView.textContainerInset = UIEdgeInsetsZero;
        // scrollerView作为controller的view的第一个subview时，系统会自动加20像素的安全距离 adjustedContentInset: {20, 0, 0, 0}
//        _contentView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
        // 使用CoreTextUtil类方法getPageContentsWithAttrStr::需要将该属性设为0或计算宽度减去改值的两倍，否则文字不能显示完全
//        _contentView.textContainer.lineFragmentPadding = 0;
    }
    return _contentView;
}

- (UILabel *)pageLabel {
    if (_pageLabel == nil) {
        _pageLabel = [[UILabel alloc] init];
        _pageLabel.textAlignment = NSTextAlignmentRight;
        _pageLabel.textColor = [UIColor grayColor];
        _pageLabel.font = [UIFont systemFontOfSize:12];
    }
    
    return _pageLabel;
}

@end
