//
//  ViewController.m
//  FSliderViewDemo
//
//  Created on 16/4/20.
//  Copyright © 2016年 Liuf. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"
#import "FSliderView.h"

#define Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RandomColor Color(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    FSliderView *slideVC = [[FSliderView alloc] init];

    [self.view addSubview:slideVC];
    for (int i = 0; i < 100; i++) {
        TestViewController *testVC = [TestViewController new];
        testVC.view.backgroundColor = RandomColor;
        [slideVC addChildViewController:testVC title:[NSString stringWithFormat:@"测试_%d", i]];
    }
    
    [slideVC configSliderView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
