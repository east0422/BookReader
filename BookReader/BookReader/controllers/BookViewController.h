//
//  BookViewController.h
//  BookReader
//
//  Created by dfang on 2020-7-3.
//  Copyright © 2020 east. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

NS_ASSUME_NONNULL_BEGIN

@interface BookViewController : UIViewController

@property (nonatomic, strong) Book *book;

@end

NS_ASSUME_NONNULL_END
