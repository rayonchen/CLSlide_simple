//
//  UIScrollView+Swizzling.m
//  Swizzling
//
//  Created by gaobo on 2018/5/11.
//  Copyright © 2018年 xlan. All rights reserved.
//

#import "UIScrollView+Swizzling.h"
#import "SwizzlingDefine.h"


@implementation UIScrollView (Swizzling)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzling_exchangeMethod([UIScrollView class], @selector(init), @selector(swizzling_init));
        swizzling_exchangeMethod([UIScrollView class], @selector(initWithFrame:), @selector(swizzling_initWithFrame:));
    });
}

- (instancetype)swizzling_init {
    id instance = [self swizzling_init];
    if (instance) {
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return instance;
}

- (instancetype)swizzling_initWithFrame:(CGRect)frame {
    id instance = [self swizzling_initWithFrame:frame];
    if (instance) {
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return instance;
}


/**
 uiscrollview滑动手势和系统右滑返回上一页面冲突, 解决方法
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // 首先判断otherGestureRecognizer是不是系统pop手势
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        // 再判断系统手势的state是began还是fail，同时判断scrollView的位置是不是正好在最左边
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.contentOffset.x == 0) {
            return YES;
        }
    }
    return NO;
}

@end
