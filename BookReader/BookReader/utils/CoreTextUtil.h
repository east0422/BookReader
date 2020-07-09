//
//  CoreTextUtil.h
//  BookReader
//
//  Created by dfang on 2020-7-9.
//  Copyright © 2020 east. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

NS_ASSUME_NONNULL_BEGIN

@interface CoreTextUtil : NSObject

// 获取显示区域大小为contentSize，显示内容为attrStr的CTFrameRef
+ (CTFrameRef)getCTFrameRefByAttrStr:(NSAttributedString *)attrStr withContentSize:(CGSize)contentSize;
// attrStr每一页显示区域大小为contenSize，获取其分页range数组(NSRange为结构体，使用NSValue封装使用时再解封)
+ (NSArray<NSValue *> *)getPageRangesWithAttrStr:(NSAttributedString *)attrStr withContentSize:(CGSize)contenSize;
// attrStr每一页显示区域大小为contenSize，获取其分页内容数组
+ (NSArray<NSMutableAttributedString *> *)getPageContentsWithAttrStr:(NSAttributedString *)attrStr withContentSize:(CGSize)contentSize;

@end

NS_ASSUME_NONNULL_END
