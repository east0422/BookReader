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

+ (NSString *)formatOneContent:(NSString *)content {
//    NSLog(@"1111");
    if (!content || [content isEqualToString:@""]) {
        return nil;
    }
    // 比较耗时，消耗cpu(正则表达式先匹配再替换，相比直接替换更耗时)
//    NSMutableString *newContent = [NSMutableString stringWithString:content];
//    // 替换回车
//    [newContent replaceOccurrencesOfString:@"\r" withString:@"" options:(NSRegularExpressionSearch) range:NSMakeRange(0, newContent.length)];
//    // 两个及以上换行替换为临时\r，后面再替换回来
//    [newContent replaceOccurrencesOfString:@"\n{2,}" withString:@"\r" options:(NSRegularExpressionSearch) range:NSMakeRange(0, newContent.length)];
//
//    // 去掉单个换行链接符(一定要在处理多个\n以后在处理单个\n)
//    [newContent replaceOccurrencesOfString:@"\n" withString:@"" options:(NSRegularExpressionSearch) range:NSMakeRange(0, newContent.length)];
//    // 将\r占位符替换回去
//    [newContent replaceOccurrencesOfString:@"\r" withString:@"\n\n" options:(NSRegularExpressionSearch) range:NSMakeRange(0, newContent.length)];
    
    // 大文本使用下面方式替换性能更好
    NSString *newContent = [content stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    newContent = [newContent stringByReplacingOccurrencesOfString:@"\n{2,}" withString:@"\r" options:NSRegularExpressionSearch range:NSMakeRange(0, newContent.length)];
    newContent = [newContent stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    newContent = [newContent stringByReplacingOccurrencesOfString:@"\r" withString:@"\n\n"];

//    NSLog(@"2222");
    return newContent;
}

+ (NSString *)parseContentWithPath:(NSString *)path withFormatType:(FormatType)formatType {
    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSStringEncoding encoding;
    // 若成功解析则编码方式也会存入encoding
    NSString *content = [NSString stringWithContentsOfURL:url usedEncoding:&encoding error:nil];
    if (content == nil) { // 未能成功解析，尝试使用常见编码方式解析，后期依需要再添加其他编码
        NSStringEncoding encodingArr[] = {
            CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_2312_80),
            CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000),
            CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGBK_95)
        };
        NSUInteger encodingCount = sizeof(encodingArr)/sizeof(encodingArr[0]);
        for (int i = 0; i < encodingCount; i++) {
            content = [NSString stringWithContentsOfURL:url encoding:encodingArr[i] error:nil];
            if (content) {
                break;
            }
        }
        
        if (content == nil) {
            NSLog(@"%@ fail and return nil", NSStringFromSelector(_cmd));
            return nil;
        }
    }
    
    if (formatType == FormatTypeOne) {
        return [self formatOneContent:content];
    } else {
        return content;
    }
}

+ (NSMutableArray *)getRangeArrInContent:(NSString *)content withFindStr:(NSString *)findStr {
    NSMutableArray *ranges = [NSMutableArray array];
    if (findStr != nil && ![findStr isEqualToString:@""]) {
//        NSRange range = [content rangeOfString:findStr options:(NSRegularExpressionSearch)];
//        if (range.location != NSNotFound) {
//            [ranges addObject:[NSValue valueWithRange:range]];
//
//            NSRange tempRange = NSMakeRange(range.location + range.length, content.length - range.location - range.length);
//            while (true) {
//                tempRange = [content rangeOfString:findStr options:(NSRegularExpressionSearch) range:tempRange];
//                if (tempRange.location == NSNotFound) {
//                    break;
//                } else {
//                    [ranges addObject:[NSValue valueWithRange:tempRange]];
//                    tempRange.location = tempRange.location + tempRange.length;
//                    tempRange.length = content.length - tempRange.location - tempRange.length;
//                }
//            }
//        }
        
        // 使用正则表达式
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:findStr options:(NSRegularExpressionCaseInsensitive) error:nil];
        NSArray<NSTextCheckingResult *> *results = [regularExpression matchesInString:content options:(NSMatchingReportCompletion) range:NSMakeRange(0, content.length)];
        for (NSTextCheckingResult *result in results) {
            [ranges addObject:[NSValue valueWithRange:result.range]];
        }
    }
    
    return ranges;
}

+ (void)parseContent:(NSString *)content toChapterTitle:(NSMutableArray *)chapterTitles andChapterContent:(NSMutableArray *)chapterContents {
    // .点匹配除“\n”和"\r"之外的任何单个字符
    NSString *chapterReg = @"第[0-9一二三四五六七八九十百千]*[章回].*";
    NSMutableArray *rangeArr = [self getRangeArrInContent:content withFindStr:chapterReg];
    // 为章节目录增加开始/前言 标题
    [chapterTitles addObject:@"开始"];
    
    NSRange lastRange = NSMakeRange(0, 0);
    for (NSValue *rValue in rangeArr) {
        [chapterTitles addObject:[content substringWithRange:rValue.rangeValue]];
        [chapterContents addObject:[content substringWithRange:NSMakeRange(lastRange.location, rValue.rangeValue.location - lastRange.location)]];
        lastRange = rValue.rangeValue;
    }
    
    // 最后一章
    [chapterContents addObject:[content substringFromIndex:lastRange.location]];
}

@end
