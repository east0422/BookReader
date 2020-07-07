//
//  UserDefaultUtil.m
//  BookReader
//
//  Created by dfang on 2020-7-7.
//  Copyright © 2020 east. All rights reserved.
//

#import "UserDefaultUtil.h"

#define BookReadMode @"BookReadMode" // 阅读模式
#define BookReadModeDefault @"BookReadModeDefault" // 默认模式（白天）
#define BookReadModeNight @"BookReadModeNight" // 夜间模式

@implementation UserDefaultUtil

+ (BOOL)isReadModeDefault {
    NSString *readMode = [[NSUserDefaults standardUserDefaults] objectForKey:BookReadMode];
    return readMode == nil || [readMode isEqualToString:BookReadModeDefault];
}

+ (BOOL)isReadModeNight {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:BookReadMode] isEqualToString:BookReadModeNight];
}

+ (void)saveReadModeDefault {
    [[NSUserDefaults standardUserDefaults] setObject:BookReadModeDefault forKey:BookReadMode];
}

+ (void)saveReadModeNight {
    [[NSUserDefaults standardUserDefaults] setObject:BookReadModeNight forKey:BookReadMode];
}

@end
