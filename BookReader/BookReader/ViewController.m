//
//  ViewController.m
//  BookReader
//
//  Created by dfang on 2020-7-1.
//  Copyright © 2020 east. All rights reserved.
//

#import "ViewController.h"
#import "Book.h"
#import "BookViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<Book *> *bookList;

@end

static NSString *bookcellid = @"bookcellid";
@implementation ViewController

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSArray<Book *> *)bookList {
    if (_bookList == nil) {
        NSMutableArray<Book *> *bookArr = [NSMutableArray array];
        NSArray *books = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"books" ofType:@"plist"]];
        for (NSDictionary *dic in books) {
            [bookArr addObject: [Book initWithDic:dic]];
        }
        _bookList = [NSArray arrayWithArray:bookArr];
    }
    
    return _bookList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"书籍阅读器";
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bookList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bookcellid];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:bookcellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    Book *book = self.bookList[indexPath.row];
    cell.textLabel.text = book.name;
    
    return cell;
}

#pragma --- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Book *book = self.bookList[indexPath.row];
    
    BookViewController *bookVC = [[BookViewController alloc] init];
    bookVC.book = book;
    [self.navigationController pushViewController:bookVC animated:YES];
}

@end
