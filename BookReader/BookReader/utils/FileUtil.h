//
//  FileUtil.h
//  BookReader
//
//  Created by dfang on 2020-7-2.
//  Copyright © 2020 east. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileUtil : NSObject

/** document目录路径 */
+ (NSString *)documentPath;
/** cache目录路径 */
+ (NSString *)cachePath;
/** temp目录路径 */
+ (NSString *)tmpPath;
/** home目录路径 */
+ (NSString *)homePath;

/** 创建书籍存放根目录，创建成功返回目录路径，创建失败返回nil */
+ (NSString *)createBookRootDirectory;
// 将一个路径文件拷贝到指定目录中
+ (BOOL)copyFilePath:(NSString *)originPath toDest:(NSString *)destPath;
/** 解析指定路径文件，返回文件内容 */
+ (NSString *)parseContentWithPath:(NSString *)path;
/** 查找str在content中的range，可能有多个值或使用正则表达式有多个range，NSRange是结构体需要转换为NSValue */
+ (NSMutableArray *)getRangeArrInContent:(NSString *)content withFindStr:(NSString *)str;

/** 解析content内容，将章节标题存入标题数组中，将章节内容存入内容数组中 */
+ (void)parseContent:(NSString *)content toChapterTitle:(NSMutableArray *)chapterTitles andChapterContent:(NSMutableArray *)chapterContents;

@end

NS_ASSUME_NONNULL_END
