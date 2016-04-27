//
//  UIView+FSliderView.h
//  FSliderViewDemo
//
//  Created on 16/4/20.
//  Copyright © 2016年 Liuf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FSliderView)

/**
 *  通过响应者链条获取当前View的父控制器
 *  @return 当前视图的父控制器
 */
- (UIViewController *)parentController;

@end
