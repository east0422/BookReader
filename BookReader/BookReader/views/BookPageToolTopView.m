//
//  BookPageToolTopView.m
//  BookReader
//
//  Created by dfang on 2020-7-4.
//  Copyright © 2020 east. All rights reserved.
//

#import "BookPageToolTopView.h"
#import <Masonry/Masonry.h>

typedef enum : NSUInteger {
    ButtonTagBack,
    ButtonTagSpeech,
} ButtonTagType;

@interface BookPageToolTopView ()

// 返回按钮
@property (nonatomic, strong) UIButton *backBtn;
// 语音按钮
@property (nonatomic, strong) UIButton *speechBtn;

@end

@implementation BookPageToolTopView

- (UIButton *)backBtn {
    if (_backBtn == nil) {
        _backBtn = [[UIButton alloc] init];
        _backBtn.tag = ButtonTagBack;
        _backBtn.tintColor = [UIColor whiteColor];
        [_backBtn setImage:[[UIImage imageNamed:@"icon_back"] imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)] forState:(UIControlStateNormal)];
        [_backBtn addTarget:self action:@selector(btnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _backBtn;
}

- (UIButton *)speechBtn {
    if (_speechBtn == nil) {
        _speechBtn = [[UIButton alloc] init];
        _speechBtn.tag = ButtonTagSpeech;
        _speechBtn.tintColor = [UIColor whiteColor];
        // 正常和选中状态都使用tintColor渲染图片，需要在点击该按钮时更改对应tintColor
        [_speechBtn setImage:[[UIImage imageNamed:@"icon_speech"] imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)] forState:(UIControlStateNormal)];
        [_speechBtn addTarget:self action:@selector(btnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _speechBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor darkGrayColor];
        [self addSubview: self.backBtn];
        [self addSubview:self.speechBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        // 按钮太小不太容易触发点击事件，可考虑将按钮宽高增大以便于触发点击事件
        make.width.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self);
    }];
    [self.speechBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-10);
        make.width.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self);
    }];
}

- (void)btnClicked:(UIButton *)btn {
    switch (btn.tag) {
        case ButtonTagBack:
            if ([self.delegate respondsToSelector:@selector(backInBookPageToolTopView:)]) {
                [self.delegate backInBookPageToolTopView:self];
            }
            break;
        case ButtonTagSpeech:
            btn.selected = !btn.selected;
            btn.tintColor = btn.selected ? [UIColor redColor]: [UIColor whiteColor];
            if ([self.delegate respondsToSelector:@selector(speechInBookPageToolTopView:)]) {
                [self.delegate speechInBookPageToolTopView:btn.selected];
            }
            break;
        default:
            break;
    }
}

@end
