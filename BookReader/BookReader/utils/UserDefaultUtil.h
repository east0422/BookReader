//
//  UserDefaultUtil.h
//  BookReader
//
//  Created by dfang on 2020-7-7.
//  Copyright © 2020 east. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserDefaultUtil : NSObject

// 阅读模式是否为默认模式
+ (BOOL)isReadModeDefault;
// 阅读模式是否为夜间模式
+ (BOOL)isReadModeNight;
// 保存阅读模式为默认模式
+ (void)saveReadModeDefault;
// 保存阅读模式为夜间模式
+ (void)saveReadModeNight;

@end

NS_ASSUME_NONNULL_END
