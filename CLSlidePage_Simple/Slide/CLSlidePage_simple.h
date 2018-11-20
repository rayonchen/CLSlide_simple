//
//  CLSlidePage_simple.h
//  CLSlidePage_Simple
//
//  Created by 程磊 on 17/8/22.
//  Copyright © 2017年 程磊. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CLSlidePageStyle) {
    CLSlidePageStyleNormal = 100,// 普通模式，默认
    CLSlidePageStyleMiddle,// 居中模式（个数<=3时，特定情况使用）
    
};

typedef NS_ENUM(NSUInteger, CLSlidePageBottomLineStyle) {
    CLSlidePageBottomLineStyleNormal = 200,// 随着title变化, 默认的
    CLSlidePageBottomLineStyleShort,// 固定20长度
};

@class CLSlidePage_simple;
typedef void(^SetSlideTabBlock)(CLSlidePage_simple *slideView);

@interface CLSlidePage_simple : UIView

@property (nonatomic, assign) CLSlidePageStyle style;// 默认normal
@property (nonatomic, assign) CLSlidePageBottomLineStyle lineStyle;// 默认normal

#pragma mark ---- 自定义属性
@property(nonatomic,strong)NSArray *titles;// 文字数组
@property(nonatomic,assign)NSInteger headHeight;// 按钮区域高度
@property(nonatomic,strong)UIColor *titleColor;// 文字颜色
@property(nonatomic,strong)UIColor *titleSeteColor;// 文字被点击颜色
@property(nonatomic,strong)UIFont *font;// 字体样式
@property(nonatomic,strong)UIFont *selecteFont;// 被点击的字体样式
@property(nonatomic,strong)UIColor *headBackColor;// 按钮下面背景颜色
@property(nonatomic,strong)UIColor *lineColor;// 横线颜色
@property(nonatomic,assign)NSInteger firstIndex;// 第一次显示哪个页面
@property(nonatomic,assign)BOOL bounces;// 
@property (nonatomic, readwrite, assign) CGFloat btnSpaceNum;// 按钮间距, 默认15

@property (nonatomic, assign) NSInteger selectIndex;// 设置当前的页面下标
/**
 创建滑动页

 @param frame frame
 @param titles 文字数组
 @param block 设置
 @return object
 */
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles block:(SetSlideTabBlock)block;

/**
 向scrollView上添加View

 @param view view
 @param index scrollView的页数下标，0开始
 */
- (void)addSubviewToSlideView:(UIView *)view index:(NSUInteger)index;


@end
