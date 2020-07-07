//
//  BookPageToolBottomView.m
//  BookReader
//
//  Created by dfang on 2020-7-4.
//  Copyright © 2020 east. All rights reserved.
//

#import "BookPageToolBottomView.h"
#import "UserDefaultUtil.h"
#import <Masonry/Masonry.h>

typedef enum : NSUInteger {
    TagForListBtn,
    TagForReadModeBtn,
    TagForFontBtn,
} TagForBtn;

@interface BookPageToolBottomView ()

// 章节目录列表按钮
@property (nonatomic, strong) UIButton *listBtn;
// 阅读模式按钮
@property (nonatomic, strong) UIButton *readModeBtn;
// 字体更改按钮
@property (nonatomic, strong) UIButton *fontBtn;

@end

@implementation BookPageToolBottomView

- (UIButton *)listBtn {
    if (_listBtn == nil) {
        _listBtn = [[UIButton alloc]init];
        _listBtn.tag = TagForListBtn;
        [_listBtn setImage:[UIImage imageNamed:@"icon_list"] forState:UIControlStateNormal];
        [_listBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_listBtn setContentEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [_listBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _listBtn;
}

- (UIButton *)readModeBtn {
    if (_readModeBtn == nil) {
        _readModeBtn = [[UIButton alloc] init];
        _readModeBtn.tag = TagForReadModeBtn;
        [_readModeBtn setImage:[UIImage imageNamed:@"readmode_default"] forState:(UIControlStateNormal)];
        [_readModeBtn setImage:[UIImage imageNamed:@"readmode_night"] forState:(UIControlStateSelected)];
        [_readModeBtn setContentEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
        [_readModeBtn addTarget:self action:@selector(btnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
        
        _readModeBtn.selected = [UserDefaultUtil isReadModeNight];
    }
    
    return _readModeBtn;
}

- (UIButton *)fontBtn {
    if (_fontBtn == nil) {
        _fontBtn = [[UIButton alloc] init];
        _fontBtn.tag = TagForFontBtn;
        [_fontBtn setTitle:@"A" forState:(UIControlStateNormal)];
        [_fontBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_fontBtn addTarget:self action:@selector(btnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _fontBtn;
}

- (void)initUI {
    [self addSubview:self.listBtn];
    [self addSubview:self.readModeBtn];
    [self addSubview:self.fontBtn];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor darkGrayColor];
        [self initUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.listBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_offset(15);
        make.width.height.mas_equalTo(25);
    }];
    [self.readModeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(25);
        make.center.mas_equalTo(self);
    }];
    [self.fontBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-10);
        make.centerY.mas_equalTo(self);
        make.width.height.mas_equalTo(25);
    }];
}

- (void)btnClicked: (UIButton *)btn {
    switch (btn.tag) {
        case TagForListBtn:
            if ([self.delegate respondsToSelector:@selector(chapterListClicked:)]) {
                [self.delegate chapterListClicked:btn];
            }
            break;
        case TagForReadModeBtn:
            btn.selected = !btn.selected;
            if ([self.delegate respondsToSelector:@selector(readModeClicked:)]) {
                [self.delegate readModeClicked:btn];
            }
            break;
        case TagForFontBtn:
            if ([self.delegate respondsToSelector:@selector(changeFontToSize:)]) {
                [self.delegate changeFontToSize:20];
            }
            break;
        default:
            break;
    }
}

@end
