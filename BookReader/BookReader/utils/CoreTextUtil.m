//
//  CoreTextUtil.m
//  BookReader
//
//  Created by dfang on 2020-7-9.
//  Copyright © 2020 east. All rights reserved.
//

#import "CoreTextUtil.h"

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


// 获取line所在行相对lineOrign所占区域(CoreText坐标系)，返回区域宽度值是实际line所占宽度而非一定为CTFrameRef宽度值
+ (CGRect)getLineFrame:(CTLineRef)line withLineOrigin:(CGPoint)lineOrigin {
    CGFloat ascent = 0;
    CGFloat descent = 0;
    CGFloat leading = 0;
    CGFloat width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + descent + leading;
    // 转换为相对CoreText左下角为坐标原点(0,0)的坐标系
    return CGRectMake(lineOrigin.x, lineOrigin.y - descent, width, height);
}

// 获取触摸点位于CTFrameRef所在行CTLineRef
+ (CTLineRef)getCTLineRefWithTouchPoint:(CGPoint)touchPoint inCTFrameRef:(CTFrameRef)frameRef {
    CFArrayRef lines = CTFrameGetLines(frameRef);
    CFIndex linecount = CFArrayGetCount(lines);
    if (linecount == 0) { // 没有CTLineRef元素
        return nil;
    }
    
    // 获取CTFrame绘制区域
    CGPathRef path = CTFrameGetPath(frameRef);
    CGRect bounds = CGPathGetBoundingBox(path);
    // 用于当前CTFrame的CoreText坐标系和UIKit坐标系的转换
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0.0f, bounds.size.height);
    transform = CGAffineTransformScale(transform, 1.0f, -1.0f);
    
    // 每一行origin坐标
    CGPoint origins[linecount];
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), origins);
    
    for (int i = 0; i < linecount; i++) {
        CGPoint lineOrigin = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        // 获取当前行frame(坐标系为CoreText)
        CGRect ctLineFrame = [self getLineFrame:line withLineOrigin:lineOrigin];
        // 将ctLineFrame的CoreText坐标系转换为UIKit坐标系
        // 1. 使用transform转换
        CGRect lineFrame = CGRectApplyAffineTransform(ctLineFrame, transform);
        // 2. 手动计算转换
//        CGRect lineFrame = CGRectMake(ctLineFrame.origin.x, bounds.size.height - ctLineFrame.origin.y - ctLineFrame.size.height, ctLineFrame.size.width, ctLineFrame.size.height);
        
        if (CGRectContainsPoint(lineFrame, touchPoint)) {
            return line;
        }
    }
    
    return nil;
}

// 获取触摸点字符位于CTFrameRef中索引位置
+ (CFIndex)getCFIndexWithTouchPoint:(CGPoint)touchPoint inCTFrameRef:(CTFrameRef)frameRef {
    CTLineRef lineRef = [self getCTLineRefWithTouchPoint:touchPoint inCTFrameRef:frameRef];
    CFIndex idx = kCFNotFound;
    if (lineRef == nil) {
        return idx;
    }
    
    // 获得当前点击坐标对应的字符索引
    idx = CTLineGetStringIndexForPosition(lineRef, touchPoint);
    
    // 点击图片左半边响应，右半边不响应；链接首文字前一个非链接文字右半边会响应，链接尾文字右半边不会响应
    // fix left side hand but right side not hand
    CGFloat secondaryOffset;
    CGFloat primaryOffset = CTLineGetOffsetForStringIndex(lineRef, idx, &secondaryOffset);
    if (touchPoint.x < primaryOffset && (idx > 0)) {
        --idx;
    }
    
    return idx;
}

+ (CGFloat)getAttrHeight:(NSAttributedString *)attrStr withMaxWidth:(CGFloat)maxW {
    if (attrStr.length == 0) {
        return 0;
    }
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrStr);
    
    // 获得要绘制的区域的高度
    CGSize restrictSize = CGSizeMake(maxW, CGFLOAT_MAX);
    CGSize ctSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, CFRangeMake(0, 0), nil, restrictSize, nil);
    return ctSize.height;
}

@end
