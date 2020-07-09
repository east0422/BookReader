//
//  CoreTextUtil.m
//  BookReader
//
//  Created by dfang on 2020-7-9.
//  Copyright © 2020 east. All rights reserved.
//

#import "CoreTextUtil.h"
#import <UIKit/UIKit.h>

@implementation CoreTextUtil

+ (CTFrameRef)getCTFrameRefByAttrStr:(NSAttributedString *)attrStr withContentSize:(CGSize)contentSize {
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrStr);
    CGPathRef path = CGPathCreateWithRect(CGRectMake(0, 0, contentSize.width, contentSize.height), nil);
    CTFrameRef frameRef = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil);
    
    CFRelease(frameSetter);
    CFRelease(path);
    
    return frameRef;
}

// 设置UITextView需置textContainer.lineFragmentPadding为0(默认为5)或者contentSize宽度值减10，否则内容可能不会在textView上全部显示
+ (NSArray<NSValue *> *)getPageRangesWithAttrStr:(NSAttributedString *)attrStr withContentSize:(CGSize)contentSize {
    NSMutableArray *rangeArr = [NSMutableArray array];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrStr);
//    CGPathRef path = CGPathCreateWithRect(CGRectMake(0, 0, contentSize.width, contentSize.height), nil);
    // textView.textContainer.lineFragmentPadding默认值为5，前后两个需要减10
    CGPathRef path = CGPathCreateWithRect(CGRectMake(0, 0, contentSize.width - 10, contentSize.height), nil);
    CFRange range = CFRangeMake(0, 0);
    NSInteger rangeOffset = 0;
    do {
        CTFrameRef frameRef = CTFramesetterCreateFrame(frameSetter, CFRangeMake(rangeOffset, 0), path, nil);
        range = CTFrameGetVisibleStringRange(frameRef);
        [rangeArr addObject:[NSValue valueWithRange:NSMakeRange(rangeOffset, range.length)]];
        rangeOffset += range.length;
        
        CFRelease(frameRef);
    } while (range.location + range.length < attrStr.length);
    
    CFRelease(frameSetter);
    CFRelease(path);
    
    return rangeArr;
}

// 同getPageRangesWithAttrStr::，需要保证计算计算区域和textView填充一致(宽高都相等)
+ (NSArray<NSMutableAttributedString*> *)getPageContentsWithAttrStr:(NSAttributedString *)attrStr withContentSize:(CGSize)contentSize {
    NSMutableArray *contentArr = [NSMutableArray array];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrStr);
//    CGPathRef path = CGPathCreateWithRect(CGRectMake(0, 0, contentSize.width, contentSize.height), nil);
    // textView.textContainer.lineFragmentPadding默认值为5，前后两个需要减10
    CGPathRef path = CGPathCreateWithRect(CGRectMake(0, 0, contentSize.width - 10, contentSize.height), nil);
    CFRange range = CFRangeMake(0, 0);
    NSInteger rangeOffset = 0;
    
    do {
        CTFrameRef frameRef = CTFramesetterCreateFrame(frameSetter, CFRangeMake(rangeOffset, 0), path, nil);
        range = CTFrameGetVisibleStringRange(frameRef);
        [contentArr addObject:[[NSMutableAttributedString alloc] initWithAttributedString:[attrStr attributedSubstringFromRange:NSMakeRange(rangeOffset, range.length)]]];
       
        rangeOffset += range.length;
        
        CFRelease(frameRef);
    } while (range.location + range.length < attrStr.length);
    
    CFRelease(frameSetter);
    CFRelease(path);
    
    return contentArr;
}

@end
