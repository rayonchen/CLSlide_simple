//
//  UIView+Additions.h
//  111
//
//  Created by chenglei on 16/9/2.
//  Copyright © 2016年 chenglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Additions)


// UIView及其所有子控件的便捷取值方法
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat max_x;
@property (nonatomic, assign) CGFloat max_y;

/// 控件顶部坐标
@property (nonatomic, assign) CGFloat top;
/// 控件底部坐标
@property (nonatomic, assign) CGFloat bottom;
/// 控件左侧坐标
@property (nonatomic, assign) CGFloat left;
/// 控件右侧坐标
@property (nonatomic, assign) CGFloat right;
/// 控件宽度
@property (nonatomic, assign) CGFloat width;
/// 控件高度
@property (nonatomic, assign) CGFloat height;
/// 控件中心x坐标
@property (nonatomic, assign) CGFloat centerX;
/// 控件中心y坐标
@property (nonatomic, assign) CGFloat centerY;
/// 控件尺寸(width,height)
@property (nonatomic, assign) CGSize  size;
/// 控件坐标(x，y)
@property (assign, nonatomic) CGPoint origin ;
/// 控件坐标自身中心点
@property (assign, nonatomic, readonly) CGPoint middle ;
/// 控件坐标自身中心点
@property (assign, nonatomic, readonly) CGFloat middleX ;
/// 控件坐标自身中心点
@property (assign, nonatomic, readonly) CGFloat middleY ;

@end
