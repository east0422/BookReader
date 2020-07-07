//
//  BookChapterListView.m
//  BookReader
//
//  Created by dfang on 2020-7-4.
//  Copyright © 2020 east. All rights reserved.
//

#import "BookChapterListView.h"
#import <Masonry/Masonry.h>

@interface BookChapterListView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *headerView;
@property (nonatomic, strong) UITableView *tableView;
// 右侧占位视图，点击占位视图隐藏章节目录表视图
@property (nonatomic, strong) UIView *backView;

@end

static NSString *chapterListCellId = @"chapterListCellId";

@implementation BookChapterListView

- (UILabel *)headerView {
    if (_headerView == nil) {
        _headerView = [[UILabel alloc] init];
        _headerView.backgroundColor = [UIColor whiteColor];
        _headerView.text = @"目录";
        _headerView.textAlignment = NSTextAlignmentCenter;
        _headerView.font = [UIFont systemFontOfSize:20];
        _headerView.textColor = [UIColor grayColor];
    }
    return _headerView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 50;
    }
    return _tableView;
}

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor clearColor];
        UIGestureRecognizer *tagGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
        [_backView addGestureRecognizer:tagGestureRecognizer];
    }
    return _backView;
}

- (void)setChapterList:(NSArray *)chapterList {
    _chapterList = chapterList;
    [self.tableView reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self addSubview:self.headerView];
    [self addSubview:self.tableView];
    [self addSubview:self.backView];
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self);
        make.width.mas_equalTo(self.bounds.size.width * 0.8);
        make.height.mas_equalTo(80);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(self);
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.width.mas_equalTo(self.bounds.size.width * 0.8);
    }];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.mas_equalTo(self);
        make.width.mas_equalTo(self.bounds.size.width * 0.2);
        make.left.mas_equalTo(self.bounds.size.width * 0.8);
    }];
}

#pragma --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chapterList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chapterListCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:chapterListCellId];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = [UIColor grayColor];
    }
    
    cell.textLabel.text = self.chapterList[indexPath.row];
    
    return cell;
}

// 不会随着滚动而滚动
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return @"目录";
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width * 0.8, 20)];
//    headerView.text = @"目录";
//    headerView.textColor = UIColor.grayColor;
//    headerView.textAlignment = NSTextAlignmentCenter;
//
//    return headerView;
//}

#pragma --- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(bookChapterListView:didSelectRowAtIndex:)]) {
        [self.delegate bookChapterListView:self didSelectRowAtIndex:indexPath.row];
    }
    [self hideView];
}

- (void)hideView {
    [UIView animateWithDuration:0.3 animations:^{
        // 向左移动隐藏
        self.transform = CGAffineTransformMakeTranslation(-self.frame.size.width * 0.9, 0);
    }completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

@end
