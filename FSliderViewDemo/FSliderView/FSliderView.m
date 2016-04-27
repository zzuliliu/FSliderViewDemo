//
//  FSliderView.m
//  FSliderViewDemo
//
//  Created on 16/4/20.
//  Copyright © 2016年 Liuf. All rights reserved.
//

#import "FSliderView.h"
#import "UIView+FSliderView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

/**标签栏距离顶部的高度*/
#define kMarginSliderTitleToTop 64
/**导航栏标题按钮的高度*/
#define kSliderTitleHigh 30
/**导航栏标题按钮的宽度*/
#define kSliderTitleWidth 80
/**选中button的时候,缩放的倍率*/
#define kMaxScale 1.2
/**设置标题默认的字号*/
#define kFontOfTitleSize 15

@interface FSliderView ()<UIScrollViewDelegate>

/**可滑动的标签栏所在的ScrollView*/
@property (nonatomic, strong) UIScrollView   *sliderTitleScrollView;

/**可滑动的控制器所在的ScrollView*/
@property (nonatomic, strong) UIScrollView   *sliderControllerScrollView;

/**导航栏标签Button*/
@property (nonatomic, strong) NSMutableArray *buttonArr;

/**子控制器的标题数组*/
@property (nonatomic, strong) NSMutableArray *titlesArr;

/**将要离开的Button*/
@property (nonatomic, strong) UIButton  *fromButton;

/**Button的背景视图*/
@property (nonatomic, strong) UIImageView   *backImageView;

@end

@implementation FSliderView

- (NSMutableArray *)buttonArr {
    if (_buttonArr == nil) {
        self.buttonArr = [NSMutableArray array];
    }
    return _buttonArr;
}

- (NSMutableArray *)titlesArr {
    if (_titlesArr == nil) {
        self.titlesArr = [NSMutableArray array];
    }
    return _titlesArr;
}

- (void)configSliderView {
    
    [self setSliderNaviScrollView];
    [self setSliderControllerScrollView];
    [self setSliderNaviContentView];
    
    self.sliderControllerScrollView.contentSize = CGSizeMake(self.titlesArr.count * kScreenWidth, kScreenHeight);
    self.sliderControllerScrollView.pagingEnabled = YES;
    self.sliderControllerScrollView.showsHorizontalScrollIndicator  = NO;
    self.sliderControllerScrollView.delegate = self;
    self.sliderControllerScrollView.bounces = NO;
}

- (void)setSliderNaviScrollView {
    
    UIViewController *parentVC = [self parentController];
    CGRect rect = CGRectMake(0, kMarginSliderTitleToTop, kScreenWidth, kSliderTitleHigh);
    self.sliderTitleScrollView = [[UIScrollView alloc] initWithFrame:rect];
    [parentVC.view addSubview:self.sliderTitleScrollView];
}

- (void)setSliderNaviContentView {
    
    NSUInteger count = self.titlesArr.count;
    CGFloat x = 0, w = kSliderTitleWidth, h = kSliderTitleHigh;
    for (int i = 0; i < count; i++) {
        x = i * w;
        CGRect rect = CGRectMake(x, 0, w, h);
        UIButton *btn = [[UIButton alloc] initWithFrame:rect];
        [btn setTitle:self.titlesArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:kFontOfTitleSize];
        btn.tag = i + 400;
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonArr addObject:btn];
        [self.sliderTitleScrollView addSubview:btn];
        if (0 == i) {
            [self click:btn];
        }
    }
    
    self.sliderTitleScrollView.contentSize = CGSizeMake(count * w, 0);
    self.sliderTitleScrollView.showsHorizontalScrollIndicator = NO;
}

- (void)setSliderControllerScrollView {
    
    UIViewController *parentVC = [self parentController];
    CGFloat Y = CGRectGetMaxY(self.sliderTitleScrollView.frame);
    CGRect rect = CGRectMake(0, Y, kScreenWidth, kScreenHeight - Y);
    self.sliderControllerScrollView = [[UIScrollView alloc] initWithFrame:rect];
    [parentVC.view addSubview:self.sliderControllerScrollView];
}

- (void)addChildViewController:(UIViewController *)childVC title:(NSString *)title{

    UIViewController *parentVC = [self parentController];
    childVC.title = title;
    [self.titlesArr addObject:title];
    [parentVC addChildViewController:childVC];
}
- (void)click:(UIButton *)sender {
    
    [self selectTitleButton:sender];
    NSInteger i = sender.tag - 400;
    CGFloat x = i * kScreenWidth;
    self.sliderControllerScrollView.contentOffset = CGPointMake(x, 0);
    [self setChildControllerAtIndex:i];
}

- (void)selectTitleButton:(UIButton *)toButton {//btn是点击的button
    
    [self.fromButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    self.fromButton.transform = CGAffineTransformIdentity;
    
    [toButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    toButton.transform = CGAffineTransformMakeScale(kMaxScale, kMaxScale);
    
    self.fromButton = toButton;
    
    [self setTitleCenter:toButton];
}

- (void)setTitleCenter:(UIButton *)sender {

    CGFloat offset = sender.center.x - kScreenWidth * 0.5;
    if (offset < 0) {
        offset = 0;
    }
    CGFloat maxOffSet = self.sliderTitleScrollView.contentSize.width - kScreenWidth;
    
    if (offset > maxOffSet && maxOffSet > 0) {
        offset = maxOffSet;
    }
    
    [self.sliderTitleScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
}

- (void)setChildControllerAtIndex:(NSInteger)index {
    
    UIViewController *parentVC = [self parentController];
    CGFloat x = index * kScreenWidth;
    UIViewController *childVC = parentVC.childViewControllers[index];
    if (childVC.view.superview) {
        return;
    }
    childVC.view.frame = CGRectMake(x, 0, kScreenWidth, kScreenHeight - self.sliderControllerScrollView.frame.origin.y);
    [self.sliderControllerScrollView addSubview:childVC.view];
}

#pragma mark --UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger i = self.sliderControllerScrollView.contentOffset.x / kScreenWidth;
    [self selectTitleButton:self.buttonArr[i]];
    [self setChildControllerAtIndex:i];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger leftIndex = offsetX / kScreenWidth;
    NSInteger rightIndex = leftIndex + 1;
    
    UIButton *leftButton = self.buttonArr[leftIndex];
    UIButton *rightButton  = nil;
    if (rightIndex < self.buttonArr.count) {
        rightButton  = self.buttonArr[rightIndex];
    }
    
    CGFloat scaleR  = offsetX / kScreenWidth - leftIndex;
    CGFloat scaleL  = 1 - scaleR;
    CGFloat transScale = kMaxScale - 1;

    leftButton.transform = CGAffineTransformMakeScale(scaleL * transScale + 1, scaleL * transScale + 1);
    rightButton.transform = CGAffineTransformMakeScale(scaleR * transScale + 1, scaleR * transScale + 1);

    UIColor *rightColor = [UIColor colorWithRed:(174+66*scaleR)/255.0 green:(174-71*scaleR)/255.0 blue:(174-174*scaleR)/255.0 alpha:1];
    UIColor *leftColor = [UIColor colorWithRed:(174+66*scaleL)/255.0 green:(174-71*scaleL)/255.0 blue:(174-174*scaleL)/255.0 alpha:1];

    [leftButton setTitleColor:leftColor forState:UIControlStateNormal];
    [rightButton setTitleColor:rightColor forState:UIControlStateNormal];
}

@end
