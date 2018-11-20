//
//  ViewController.m
//  CLSlidePage_Simple
//
//  Created by 程磊 on 17/8/22.
//  Copyright © 2017年 程磊. All rights reserved.
//

#import "ViewController.h"
#import "CLSlidePage_simple.h"
#import "UIView+Additions.h"


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CLSlidePage_simple *slideView = [[CLSlidePage_simple alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 500) titles:@[@"测试1", @"测试22222", @"测试333", @"测试444", @"测试55", @"测试6666"] block:^(CLSlidePage_simple *slideView) {

        slideView.style = CLSlidePageStyleNormal;
        slideView.lineStyle = CLSlidePageBottomLineStyleNormal;
        slideView.titleColor = [UIColor grayColor];
        slideView.titleSeteColor = [UIColor darkTextColor];
        slideView.lineColor = [UIColor blueColor];
        slideView.firstIndex = 1;
        slideView.selecteFont = [UIFont boldSystemFontOfSize:15.f];
        slideView.font = [UIFont systemFontOfSize:15.f];
        slideView.btnSpaceNum = 15;
    }];
    [self.view addSubview:slideView];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 300)];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 300)];
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 300)];

    view1.backgroundColor = [UIColor redColor];
    view2.backgroundColor = [UIColor yellowColor];
    view3.backgroundColor = [UIColor greenColor];

    [slideView addSubviewToSlideView:view1 index:0];
    [slideView addSubviewToSlideView:view2 index:1];
    [slideView addSubviewToSlideView:view3 index:2];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
