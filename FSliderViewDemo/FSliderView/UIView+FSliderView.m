//
//  UIView+FSliderView.m
//  FSliderViewDemo
//
//  Created on 16/4/20.
//  Copyright © 2016年 Liuf. All rights reserved.
//

#import "UIView+FSliderView.h"

@implementation UIView (FSliderView)

- (UIViewController *)parentController {
    
    UIResponder *responder = [self nextResponder];
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

@end
