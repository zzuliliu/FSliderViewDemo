//
//  FSliderView.h
//  FSliderViewDemo
//
//  Created on 16/4/20.
//  Copyright © 2016年 Liuf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSliderView : UIView

/**
 *  根据标题添加子控制器
 *
 *  @param childVC 子控制器
 *  @param vcTitle  控制器标题
 */
-(void)addChildViewController:(UIViewController *)childVC title:(NSString *)vcTitle;

/**
 *  在添加完成子控制时,调用此方法,即可完成初始化操作
 */
- (void)configSliderView;

@end
