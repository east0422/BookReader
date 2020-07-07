//
//  FileUtil.m
//  BookReader
//
//  Created by dfang on 2020-7-2.
//  Copyright © 2020 east. All rights reserved.
//

#import "FileUtil.h"

@implementation FileUtil

+ (NSString *)documentPath {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
}

+ (NSString *)cachePath {
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
}

+ (NSString *)tmpPath {
    return NSTemporaryDirectory();
}

+ (NSString *)homePath {
    return NSHomeDirectory();
}

+ (NSString *)createBookRootDirectory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *bookRootDir = [[self documentPath] stringByAppendingPathComponent:@"books"];
    BOOL isDir;
    if ([fileManager fileExistsAtPath:bookRootDir isDirectory:&isDir] && isDir) { // 存在且为目录
        return bookRootDir;
    }
    
    BOOL isCreated = [fileManager createDirectoryAtPath:bookRootDir withIntermediateDirectories:YES attributes:nil error:nil];
    
    if (isCreated) {
        return bookRootDir;
    } else {
        return nil;
    }
}

+ (BOOL)copyFilePath:(NSString *)originPath toDest:(NSString *)destPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:originPath] && ![fileManager fileExistsAtPath:destPath]) { // 源文件存在且目标文件不存在
        NSError *error = nil;
        BOOL isCoped = [fileManager copyItemAtPath:originPath toPath:destPath error:&error];
        if (!isCoped) {
            NSLog(@"copy %@ to %@ fail and error: %@", originPath, destPath, error);
            return NO;
        }
    }
    return YES;
}

+ (NSString *)parseContentWithPath:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSStringEncoding encoding;
    // 若成功解析则编码方式也会存入encoding
    NSString *content = [NSString stringWithContentsOfURL:url usedEncoding:&encoding error:nil];
    if (content) { // 解析读取内容成功直接返回
        return content;
    }
    
    // 未能成功解析，尝试使用常见编码方式解析，后期依需要再添加其他编码
//    NSLog(@"kCFStringEncodingGB_2312_80");
    content = [NSString stringWithContentsOfURL:url encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_2312_80) error:nil];
    if (content) {
        return content;
    }
//    NSLog(@"kCFStringEncodingGB_18030_2000");
    content = [NSString stringWithContentsOfURL:url encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000) error:nil];
    if (content) {
        return content;
    }
//    NSLog(@"kCFStringEncodingGBK_95");
    content = [NSString stringWithContentsOfURL:url encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGBK_95) error:nil];
    if(content) {
        return content;
    }
    
    NSLog(@"%@ fail and return nil", NSStringFromSelector(_cmd));
    return nil;
}

+ (NSMutableArray *)getRangeArrInContent:(NSString *)content withFindStr:(NSString *)findStr {
    NSMutableArray *ranges = [NSMutableArray array];
    if (findStr != nil && ![findStr isEqualToString:@""]) {
        NSRange range = [content rangeOfString:findStr options:(NSRegularExpressionSearch)];
        if (range.location != NSNotFound) {
            [ranges addObject:[NSValue valueWithRange:range]];
            
            NSRange tempRange = NSMakeRange(range.location + range.length, content.length - range.location - range.length);
            while (true) {
                tempRange = [content rangeOfString:findStr options:(NSRegularExpressionSearch) range:tempRange];
                if (tempRange.location == NSNotFound) {
                    break;
                } else {
                    [ranges addObject:[NSValue valueWithRange:tempRange]];
                    tempRange.location = tempRange.location + tempRange.length;
                    tempRange.length = content.length - tempRange.location - tempRange.length;
                }
            }
        }
    }
    
    return ranges;
}

+ (void)parseContent:(NSString *)content toChapterTitle:(NSMutableArray *)chapterTitles andChapterContent:(NSMutableArray *)chapterContents {
    NSString *chapterReg = @"\r\n第.{1,}[章|回].*\r\n";
    NSMutableArray *rangeArr = [self getRangeArrInContent:content withFindStr:chapterReg];
    // 为章节目录增加开始/前言 标题
    [chapterTitles addObject:@"开始"];
    
    NSRange lastRange = NSMakeRange(0, 0);
    for (NSValue *rValue in rangeArr) {
        [chapterTitles addObject:[[content substringWithRange:rValue.rangeValue] stringByReplacingOccurrencesOfString:@"\r\n" withString:@""]];
        [chapterContents addObject:[content substringWithRange:NSMakeRange(lastRange.location, rValue.rangeValue.location - lastRange.location)]];
        lastRange = rValue.rangeValue;
    }
    
    // 最后一章
    [chapterContents addObject:[content substringFromIndex:lastRange.location]];
}

@end
