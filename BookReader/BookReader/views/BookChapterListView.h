//
//  BookChapterListView.h
//  BookReader
//
//  Created by dfang on 2020-7-4.
//  Copyright © 2020 east. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class BookChapterListView;
@protocol BookChapterListViewDelegate <NSObject>

// 书籍章节目录列表选中index行
- (void)bookChapterListView:(BookChapterListView *)bookChapterListView didSelectRowAtIndex:(NSInteger)index;

@end

@interface BookChapterListView : UIView
// 章节目录列表
@property (nonatomic, strong) NSArray *chapterList;
@property (nonatomic, weak) id<BookChapterListViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
