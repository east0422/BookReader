//
//  BookViewController.m
//  BookReader
//
//  Created by dfang on 2020-7-3.
//  Copyright © 2020 east. All rights reserved.
//

#import "BookViewController.h"
#import "BookPageViewController.h"
#import "BookPageToolTopView.h"
#import "BookPageToolBottomView.h"
#import "BookChapterListView.h"
#import "FileUtil.h"
#import "UserDefaultUtil.h"
#import "CoreTextUtil.h"
#import <Masonry.h>

#define TOOLHEIGHT 70
#define ScreenSize UIScreen.mainScreen.bounds.size

@interface BookViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, BookPageToolTopViewDelegate, BookPageToolBottomViewDelegate, BookChapterListViewDelegate, UIGestureRecognizerDelegate>

// 分页视图控制器
@property (nonatomic, strong) UIPageViewController *pageVC;
// 顶部工具视图
@property (nonatomic, strong) BookPageToolTopView *toolTopView;
// 底部工具视图
@property (nonatomic, strong) BookPageToolBottomView *toolBottomView;
// 章节目录列表视图
@property (nonatomic, strong) BookChapterListView *chapterListView;
// 当前章节内容视图控制器
@property (nonatomic, strong) BookPageViewController *curChapterContentVC;

// 是否显示顶部和底部工具视图
@property (nonatomic, assign) BOOL showToolView;
// 章节目录列表
@property (nonatomic, strong) NSMutableArray *chapterTitleList;
// 章节内容文本列表(textLabel.text, 是NSString类型)，每一个数组元素为一个章节内容
@property (nonatomic, strong) NSMutableArray *chapterTextList;
// 某一章节内容列表(textLabel.attributedText，包括字体大小颜色等属性)，每一个数组元素为章节内容中的一页
@property (nonatomic, strong) NSMutableArray<NSMutableAttributedString *> *chapterContentList;
// 章节内容绘制样式属性字典
@property (nonatomic, strong) NSDictionary *textAttributedDict;
// 当前章节在章节文本内容数组中索引
@property (nonatomic, assign) NSInteger curChapterIndex;
// 当前内容在某章节内容数组中索引
@property (nonatomic, assign) NSInteger curContentIndex;
// 字体大小
@property (nonatomic, assign) NSInteger fontSize;
// 章节每一页显示区域大小(BookPageViewController的contentView显示区域大小)
@property (nonatomic, assign) CGSize contentSize;

@end

@implementation BookViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.pageVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.height.mas_equalTo(self.view);
    }];
    [self.toolTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(-TOOLHEIGHT);
        make.left.width.mas_equalTo(self.view);
        make.height.mas_equalTo(TOOLHEIGHT);
    }];
    [self.toolBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(TOOLHEIGHT);
    }];
    [self.chapterListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.width.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view.bounds.size.width * -0.8);
    }];
}

- (void)initData {
    _showToolView = NO;
    _chapterTitleList = [NSMutableArray array];
    _chapterTextList = [NSMutableArray array];
    _chapterContentList = [NSMutableArray array];
    _curChapterIndex = 0;
    _curContentIndex = 0;
    _contentSize = CGSizeMake(ScreenSize.width - 40, ScreenSize.height - 100);
    _fontSize = 20;
    _textAttributedDict = @{NSFontAttributeName:[UIFont fontWithName:@"PingFang SC" size: _fontSize]};
}

- (void)initUI {
    BookPageViewController *bookPageVC = [self viewControllerAtIndex:self.curContentIndex];
    [self.pageVC setViewControllers:@[bookPageVC] direction:(UIPageViewControllerNavigationDirectionReverse) animated:YES completion:nil];
    [self addChildViewController:self.pageVC];
    [self.view addSubview:self.pageVC.view];
    [self.view addSubview:self.toolTopView];
    [self.view addSubview:self.toolBottomView];
    [self.view addSubview:self.chapterListView];
    
    // 添加手势
    UITapGestureRecognizer *tapHandle = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tapHandle.delegate = self;
    tapHandle.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapHandle];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)tap:(UIGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self.view];
    if (self.showToolView) {
        if (point.y < TOOLHEIGHT || point.y > (ScreenSize.height - TOOLHEIGHT)) { // 除了点击工具视图其他都隐藏
            return;
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.toolTopView.transform = CGAffineTransformIdentity;
            self.toolBottomView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.toolTopView.hidden = YES;
            self.toolBottomView.hidden = YES;
        }];
    } else {
        if (point.x < ScreenSize.width * 0.3 || point.x > ScreenSize.width * 0.7) { // UIPageViewController默认边缘手势分页
               return;
           }
        self.toolTopView.hidden = NO;
        self.toolBottomView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.toolTopView.transform = CGAffineTransformMakeTranslation(0, TOOLHEIGHT);
            self.toolBottomView.transform = CGAffineTransformMakeTranslation(0, -TOOLHEIGHT);
        }];
    }
    self.showToolView = !_showToolView;
}

#pragma --- UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if (self.curContentIndex == 0) { // 第一页
        if (self.curChapterIndex == 0) { // 第一章
            return nil;
        } else {
            self.curChapterIndex--;
            self.chapterContentList = [self parseChapterContentListWithText:self.chapterTextList[self.curChapterIndex]];
            self.curContentIndex = self.chapterContentList.count - 1;
        }
    } else {
        self.curContentIndex--;
    }
    
    return [self viewControllerAtIndex:self.curContentIndex];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if (self.curContentIndex == self.chapterContentList.count - 1) { // 最后一页
        if (self.curChapterIndex == self.chapterTextList.count - 1) { // 最后一章最后一页直接返回nil
            return nil;
        } else if (self.curChapterIndex < self.chapterTextList.count - 1) { // 非最后一章的最后一页
            self.curChapterIndex++;
            _curContentIndex = 0;
            self.chapterContentList = [self parseChapterContentListWithText:self.chapterTextList[self.curChapterIndex]];
        }
    } else {
        self.curContentIndex++;
    }
    
    return [self viewControllerAtIndex:self.curContentIndex];
}

#pragma --- UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // 若为UITableViewCellContentView（点击tableViewCell）则不截获Touch事件（继续执行Cell的点击方法）
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

#pragma --- BookPageToolTopViewDelegate
- (void)backInBookPageToolTopView:(BookPageToolTopView *)topView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)speechInBookPageToolTopView:(BookPageToolTopView *)topView {
    
}

#pragma --- BookPageToolBottomViewDelegate
- (void)chapterListClicked:(UIButton *)btn {
    // 显示章节目录列表
    self.chapterListView.hidden = NO;
    [self.chapterListView updateIndexPathRow:self.curChapterIndex];
    // 隐藏顶部底部工具视图
    self.showToolView = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.chapterListView.transform = CGAffineTransformMakeTranslation(ScreenSize.width * 0.8, 0);
        self.toolTopView.transform = CGAffineTransformIdentity;
        self.toolBottomView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.toolTopView.hidden = YES;
        self.toolBottomView.hidden = YES;
    }];
}

- (void)readModeClicked:(UIButton *)btn {
    if (btn.selected) {
        [UserDefaultUtil saveReadModeNight];
    } else {
        [UserDefaultUtil saveReadModeDefault];
    }
    [self.curChapterContentVC updateUI];
}

- (void)changeFontWithType:(BookPageChangeFontType)fontType {
    // 显示字体调节视图
    if (fontType == BookPageChangeFontDecrease) { // 字体减小2
        if (self.fontSize <= 16) { // 最小字体大小为16
            return;
        }
        self.fontSize -= 2;
    } else if (fontType == BookPageChangeFontIncrease) { // 字体增加2
        if (self.fontSize >= 30) { // 最大字体大小为30
            return;
        }
        self.fontSize += 2;
    }
    self.textAttributedDict = @{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size:self.fontSize]};
    self.chapterContentList = [self parseChapterContentListWithText:self.chapterTextList[self.curChapterIndex]];
    self.curChapterContentVC.content = self.chapterContentList[self.curContentIndex];
    [self.curChapterContentVC setCurPage:self.curContentIndex totalPages:self.chapterContentList.count];
}

#pragma --- BookChapterListViewDelegate
- (void)bookChapterListView:(BookChapterListView *)bookChapterListView didSelectRowAtIndex:(NSInteger)index {
    self.curChapterIndex = index;
    self.curContentIndex = 0;
    self.chapterContentList = [self parseChapterContentListWithText:self.chapterTextList[self.curChapterIndex]];
    self.curChapterContentVC.content = self.chapterContentList[self.curContentIndex];
    [self.curChapterContentVC setCurPage:self.curContentIndex totalPages:self.chapterContentList.count];
}

- (NSMutableArray *)parseChapterContentListWithText:(NSString *)text {
    NSMutableArray *pageArr = [NSMutableArray array];
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:text attributes:self.textAttributedDict];
    
    // 填充textview需要考虑textContainer.lineFragmentPadding值
//    return [CoreTextUtil getPageContentsWithAttrStr:attrStr withContentSize:self.contentSize];
    
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:attrStr];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:layoutManager];
    
    while (true) {
        NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:self.contentSize];
        [layoutManager addTextContainer:textContainer];
        NSRange range = [layoutManager glyphRangeForTextContainer:textContainer];
        if (range.length <= 0) {
            break;
        }

        [pageArr addObject:[[NSMutableAttributedString alloc] initWithAttributedString:[attrStr attributedSubstringFromRange:range]]];
    }
    return pageArr;
}

- (BookPageViewController *)viewControllerAtIndex:(NSUInteger)index {
    // 若章节索引大于或等于章节数组总长度或当前章节内容数组长度为0直接返回nil
    if (index >= self.chapterContentList.count || self.chapterContentList.count == 0) {
        return nil;
    }
    
    // 创建一个新的书籍页面内容控制器
    BookPageViewController *bookPageVC = [[BookPageViewController alloc] init];
//    bookPageVC.text = self.chapterTextList[index];
    bookPageVC.content = self.chapterContentList[index];
    [bookPageVC setCurPage:index totalPages:self.chapterContentList.count];
    
    self.curChapterContentVC = bookPageVC;
    return bookPageVC;
}

- (void)setBook:(Book *)book {
    _book = book;
    NSString *content = nil;
    NSString *bookPath = book.path;
    if (bookPath == nil || [bookPath isEqualToString:@""]) {
        bookPath = [[NSBundle mainBundle] pathForResource:book.name ofType:book.type];
        // 也可将文件拷贝到doc文件目录中
//        NSString *bookInBundlePath = [[NSBundle mainBundle] pathForResource:book.name ofType:book.type];
//        bookPath = [[FileUtil createBookRootDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", book.name, book.type]];
//        BOOL isCopySuccess = [FileUtil copyFilePath:bookInBundlePath toDest:bookPath];
//        if (!isCopySuccess) { // 指定路径文件不存在或拷贝失败，使用bundle地址
//            bookPath = bookInBundlePath;
//        }
    }
    
    if ([book.name isEqualToString:@"三国演义"]) {
        content = [FileUtil parseContentWithPath:bookPath withFormatType:FormatTypeOne];
    } else {
        content = [FileUtil parseContentWithPath:bookPath withFormatType:FormatTypeNone];
    }
    if (content) {
        [FileUtil parseContent:content toChapterTitle:self.chapterTitleList andChapterContent:self.chapterTextList];
        self.chapterListView.chapterList = self.chapterTitleList;
        
        self.chapterContentList = [self parseChapterContentListWithText:self.chapterTextList[self.curChapterIndex]];
    }
}

- (void)setShowToolView:(BOOL)showToolView {
    _showToolView = showToolView;
    self.pageVC.view.userInteractionEnabled = !showToolView;
}

// 懒加载
- (UIPageViewController *)pageVC {
    if (_pageVC == nil) {
        _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:(UIPageViewControllerTransitionStylePageCurl) navigationOrientation:(UIPageViewControllerNavigationOrientationHorizontal) options:nil];
        _pageVC.dataSource = self;
        _pageVC.delegate = self;
    }
    return _pageVC;
}

- (BookPageToolTopView *)toolTopView {
    if (_toolTopView == nil) {
        _toolTopView = [[BookPageToolTopView alloc] init];
        _toolTopView.hidden = YES;
        _toolTopView.delegate = self;
    }
    return _toolTopView;
}

- (BookPageToolBottomView *)toolBottomView {
    if (_toolBottomView == nil) {
        _toolBottomView = [[BookPageToolBottomView alloc] init];
        _toolBottomView.hidden = YES;
        _toolBottomView.delegate = self;
    }
    return _toolBottomView;
}

- (BookChapterListView *)chapterListView {
    if (_chapterListView == nil) {
        _chapterListView = [[BookChapterListView alloc] init];
        _chapterListView.hidden = YES;
        _chapterListView.delegate = self;
    }
    return _chapterListView;
}

@end
