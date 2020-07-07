//
//  Book.h
//  BookReader
//
//  Created by dfang on 2020-7-2.
//  Copyright © 2020 east. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Book : NSObject

/** 书名 */
@property (nonatomic, copy) NSString *name;
/** 类型 */
@property (nonatomic, copy) NSString *type;
/** 路径 */
@property (nonatomic, copy) NSString *path;

/** 字典实例化书籍模型对象 */
+ (instancetype)initWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
