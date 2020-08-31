//
//  UIResponder+FirstResponder.m
//  SafeKeyboard
//
//  Created by hunter.liu on 2020/8/31.
//  Copyright © 2020 com.jh.testkeyboard. All rights reserved.
//

#import "UIResponder+FirstResponder.h"

static __weak id currentFirstResponder;

@implementation UIResponder (FirstResponder)

+(id)currentFirstResponder {
    currentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentFirstResponder;
}

-(void)findFirstResponder:(id)sender {
   currentFirstResponder = self;
}
@end
