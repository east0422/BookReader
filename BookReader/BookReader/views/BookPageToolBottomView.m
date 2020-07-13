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
    TagForDecreaseFontBtn,
    TagForIncreaseFontBtn,
} TagForBtn;

@interface BookPageToolBottomView ()

// 章节目录列表按钮
@property (nonatomic, strong) UIButton *listBtn;
// 阅读模式按钮
@property (nonatomic, strong) UIButton *readModeBtn;
// 字体减小按钮
@property (nonatomic, strong) UIButton *decreaseFontBtn;
// 字体增大按钮
@property (nonatomic, strong) UIButton *increaseFontBtn;

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

- (UIButton *)decreaseFontBtn {
    if (_decreaseFontBtn == nil) {
        _decreaseFontBtn = [[UIButton alloc] init];
        _decreaseFontBtn.tag = TagForDecreaseFontBtn;
        [_decreaseFontBtn setTitle:@"A-" forState:(UIControlStateNormal)];
        [_decreaseFontBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_decreaseFontBtn addTarget:self action:@selector(btnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _decreaseFontBtn;
}

- (UIButton *)increaseFontBtn {
    if (_increaseFontBtn == nil) {
        _increaseFontBtn = [[UIButton alloc] init];
        _increaseFontBtn.tag = TagForIncreaseFontBtn;
        [_increaseFontBtn setTitle:@"A+" forState:(UIControlStateNormal)];
        [_increaseFontBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_increaseFontBtn addTarget:self action:@selector(btnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _increaseFontBtn;
}

- (void)initUI {
    [self addSubview:self.listBtn];
    [self addSubview:self.readModeBtn];
    [self addSubview:self.decreaseFontBtn];
    [self addSubview:self.increaseFontBtn];
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
    
    // 子视图高度25，垂直居中
    [self.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(25);
        make.centerY.mas_equalTo(self);
    }];
    // 水平排列，子视图宽度25，首尾间距均为10
    [self.subviews mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedItemLength:25 leadSpacing:10 tailSpacing:10];
    // 水平排列，子视图等间距30，首尾间距10
//    [self.subviews mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedSpacing:30 leadSpacing:10 tailSpacing:10];
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
        case TagForDecreaseFontBtn:
            if ([self.delegate respondsToSelector:@selector(changeFontWithType:)]) {
                [self.delegate changeFontWithType:BookPageChangeFontDecrease];
            }
            break;
        case TagForIncreaseFontBtn:
            if ([self.delegate respondsToSelector:@selector(changeFontWithType:)]) {
                [self.delegate changeFontWithType:BookPageChangeFontIncrease];
            }
            break;
        default:
            break;
    }
}

@end
