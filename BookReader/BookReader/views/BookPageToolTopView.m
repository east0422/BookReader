//
//  BookPageToolTopView.m
//  BookReader
//
//  Created by dfang on 2020-7-4.
//  Copyright © 2020 east. All rights reserved.
//

#import "BookPageToolTopView.h"
#import <Masonry/Masonry.h>

@interface BookPageToolTopView ()

// 返回按钮
@property (nonatomic, strong) UIButton *backBtn;

@end

@implementation BookPageToolTopView

- (UIButton *)backBtn {
    if (_backBtn == nil) {
        _backBtn = [[UIButton alloc] init];
        [_backBtn setImage:[UIImage imageNamed:@"icon_back"] forState:(UIControlStateNormal)];
        [_backBtn addTarget:self action:@selector(backClicked) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _backBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor darkGrayColor];
        [self addSubview: self.backBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.width.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self);
    }];
}

- (void)backClicked {
    if ([self.delegate respondsToSelector:@selector(backInBookPageToolTopView:)]) {
        [self.delegate backInBookPageToolTopView:self];
    }
}

@end
