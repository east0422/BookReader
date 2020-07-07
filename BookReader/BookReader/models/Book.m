//
//  Book.m
//  BookReader
//
//  Created by dfang on 2020-7-2.
//  Copyright © 2020 east. All rights reserved.
//

#import "Book.h"

@implementation Book

+ (instancetype)initWithDic:(NSDictionary *)dic {
    Book *book = [[Book alloc] init];
    book.name = [dic valueForKey:@"name"];
    book.path = [dic valueForKey:@"path"];
    book.type = [dic valueForKey:@"type"];

    return book;
}

@end
