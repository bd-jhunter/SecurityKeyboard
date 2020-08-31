//
//  UIResponder+FirstResponder.h
//  SafeKeyboard
//
//  Created by hunter.liu on 2020/8/31.
//  Copyright © 2020 com.jh.testkeyboard. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (FirstResponder)

+ (id)currentFirstResponder;

@end

NS_ASSUME_NONNULL_END
