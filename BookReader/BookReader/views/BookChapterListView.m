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

// 顶部标题标签(目录)，放在headerView中
@property (nonatomic, strong) UILabel *titleLabel;
// 章节目录顺/倒序按钮, 放在headerView中
@property (nonatomic, strong) UIButton *orderBtn;

// 顶部视图
@property (nonatomic, strong) UIView *headerView;
// 章节目录表视图
@property (nonatomic, strong) UITableView *tableView;
// 右侧占位视图，点击占位视图隐藏章节目录表视图
@property (nonatomic, strong) UIView *backView;
// 当前选中章节在cell中所占位置
@property (nonatomic, strong) NSIndexPath *curIndexPath;

@end

static NSString *chapterListCellId = @"chapterListCellId";

@implementation BookChapterListView

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.text = @"目录";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _titleLabel.textColor = [UIColor grayColor];
    }
    return _titleLabel;
}

- (UIButton *)orderBtn {
    if (_orderBtn == nil) {
        _orderBtn = [[UIButton alloc] init];
        _orderBtn.titleLabel.textColor = [UIColor redColor];
        _orderBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _orderBtn.selected = NO;
        [_orderBtn setTitle:@"正序" forState:(UIControlStateNormal)];
        [_orderBtn setTitle:@"倒序" forState:(UIControlStateSelected)];
        [_orderBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_orderBtn addTarget:self action:@selector(orderBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _orderBtn;
}

- (UIView *)headerView {
    if (_headerView == nil) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        [_headerView addSubview:self.titleLabel];
        [_headerView addSubview:self.orderBtn];
    }
    return _headerView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 50;
        // fix滚动到顶部时部分issue
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
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
    _curIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
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
    _curIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self addSubview:self.headerView];
    [self addSubview:self.tableView];
    [self addSubview:self.backView];
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(30);
        make.centerY.mas_equalTo(self.headerView);
        make.width.height.mas_equalTo(60);
    }];
    [self.orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-30);
        make.centerY.mas_equalTo(self.headerView.mas_centerY);
        make.width.height.mas_equalTo(60);
    }];
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
    
    BOOL isCurSelected = false;
    if (self.orderBtn.selected) { // 倒序
        isCurSelected = (self.curIndexPath.section == indexPath.section &&
        self.chapterList.count - 1 - self.curIndexPath.row == indexPath.row);
        
        cell.textLabel.text = self.chapterList[self.chapterList.count - 1 - indexPath.row];
    } else {
        isCurSelected = [self.curIndexPath isEqual:indexPath];
        cell.textLabel.text = self.chapterList[indexPath.row];
    }
    
    cell.textLabel.textColor = isCurSelected ? [UIColor redColor] : [UIColor grayColor];
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
    // 更新以前选中和当前选中章节cell样式
    NSArray *changeIndexPathArr = @[self.curIndexPath, indexPath];
    self.curIndexPath = indexPath;
    [self reloadTableViewWithIndexPathChangeArr:changeIndexPathArr];
    
    if ([self.delegate respondsToSelector:@selector(bookChapterListView:didSelectRowAtIndex:)]) {
        NSInteger selectedRow = self.orderBtn.selected ? self.chapterList.count - 1 - indexPath.row : indexPath.row;
        [self.delegate bookChapterListView:self didSelectRowAtIndex:selectedRow];
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

- (void)updateIndexPathRow:(NSInteger)row {
    if (self.curIndexPath.row == row) { // row未改变
        return;
    }
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:row inSection:self.curIndexPath.section];
    NSArray *changeIndexPathArr = @[self.curIndexPath, newIndexPath];
    self.curIndexPath = newIndexPath;
    // 更新以前选中和当前选中章节cell样式
    [self reloadTableViewWithIndexPathChangeArr:changeIndexPathArr];
    
    [self scrollCurIndexPathToTop];
}

- (void)orderBtnClicked:(UIButton *)btn {
    btn.selected = !btn.selected;
    [self.tableView reloadData];
    
    [self scrollCurIndexPathToTop];
}

// 将当前indexPath滚动到顶部
- (void)scrollCurIndexPathToTop {
    // 滚动到头部
    // 1. 无效
    //    [self.tableView setContentOffset:CGPointZero animated:YES];
    // 2. 无效
    //    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 0.1, 0.1) animated:YES];
    // 3. 有效
    NSInteger showRow = self.orderBtn.selected ? self.chapterList.count - 1 - self.curIndexPath.row : self.curIndexPath.row;
    NSIndexPath *showIndexPath = [NSIndexPath indexPathForRow:showRow inSection:self.curIndexPath.section];
    [self.tableView scrollToRowAtIndexPath:showIndexPath atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
}

- (void)reloadTableViewWithIndexPathChangeArr:(NSArray *)changeIndexPathArr {
    if (self.orderBtn.selected) { // 倒序需要做转换
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:changeIndexPathArr.count];
        for (NSIndexPath *indexpath in changeIndexPathArr) {
            [arr addObject:[NSIndexPath indexPathForRow:self.chapterList.count - 1 - indexpath.row inSection:indexpath.section]];
        }
        [self.tableView reloadRowsAtIndexPaths:arr withRowAnimation:(UITableViewRowAnimationNone)];
    } else {
        [self.tableView reloadRowsAtIndexPaths:changeIndexPathArr withRowAnimation:(UITableViewRowAnimationNone)];
    }
}

@end
