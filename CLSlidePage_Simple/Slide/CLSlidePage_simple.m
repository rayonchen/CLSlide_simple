//
//  CLSlidePage_simple.m
//  CLSlidePage_Simple
//
//  Created by 程磊 on 17/8/22.
//  Copyright © 2017年 程磊. All rights reserved.
//

#import "CLSlidePage_simple.h"
#import "UIScrollView+Swizzling.h"
#import "UIImage+Extend.h"
#import "UIView+Additions.h"


@interface CLSlidePage_simple ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *backView;// 顶部按钮存放处
@property(nonatomic,strong)UIView *lineView;// button下的横线
@property (nonatomic,strong)UIScrollView *scrollView;// 存放view
@property (nonatomic, readwrite, strong) UIImageView *spaceImgV;// 分割线

@property(nonatomic,strong)NSMutableArray *btnArray;// 按钮数组
@property(nonatomic,strong)NSMutableArray *viewsArray;// view数组
@property(nonatomic,strong)NSMutableArray *btnWidthArray;// 按钮宽度数组
@property(nonatomic,assign)NSInteger allBtnWidth;// 所有按钮总宽度

@property (nonatomic, readwrite, assign) NSUInteger currentIndex;// 静止时显示的内容下标
@end
@implementation CLSlidePage_simple

#define kFontOfSize(value)  [UIFont systemFontOfSize:value]
#define UIColorRGB(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]


- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles block:(SetSlideTabBlock)block
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 设置默认值
        [self settingDefaultValues];
        
        // 赋值
        self.titles = [titles copy];

        // 让外部改变值
        if (block) {
            block(self);
        }
        
        // 计算按钮总宽度
        [self calculateAllBtnWidth];
        
        // 创建header
        [self addSubview:self.backView];
        // 创建scrollView
        [self addSubview:self.scrollView];
        // 阴影横线
//        [self addSubview:self.spaceImgV];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.scrollView.frame = CGRectMake(0, CGRectGetMaxY(self.backView.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-CGRectGetMaxY(self.backView.frame));
    for (UIView *view in self.viewsArray) {
        NSInteger index = view.tag - 10240;
        view.frame = CGRectMake(index*CGRectGetWidth(self.scrollView.frame), 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
    }
}

- (void)addSubviewToSlideView:(UIView *)view index:(NSUInteger)index
{
    if (index <= self.titles.count -1) {
        // 不能超过button个数
        view.tag = 10240+index;
        view.x = self.scrollView.width * index;
        view.y = 0;
        if (view.width == 0) {
            view.width = CGRectGetWidth(self.scrollView.bounds);
        }
        if (view.height == 0) {
            view.height = CGRectGetHeight(self.scrollView.bounds);
        }
        [self.scrollView addSubview:view];
        [self.viewsArray addObject:view];
    }
}
- (void)settingDefaultValues
{
    _style = CLSlidePageStyleNormal;
    _lineStyle = CLSlidePageBottomLineStyleNormal;
    _headHeight = 40;
    _titleColor = UIColorRGB(0x999999,1.0f);
    _titleSeteColor = UIColorRGB(0x333333, 1.0f);
    _headBackColor = [UIColor whiteColor];
    _font = kFontOfSize(14.f);
    _lineColor = UIColorRGB(0x0068b7, 1.f);
    _firstIndex = 0;
    _currentIndex = 0;
    _btnSpaceNum = 15;
}

- (void)calculateAllBtnWidth
{
    for (int i = 0; i < self.btnWidthArray.count; i++) {
        self.allBtnWidth += [self.btnWidthArray[i] integerValue];
    }
    
}

/**
 计算一行文字宽度
 */
- (CGFloat)getStrWidthWithStr:(NSString *)str andFont:(CGFloat)fontFloat
{
    UIFont *font = [UIFont systemFontOfSize:fontFloat];
    NSDictionary *dic = @{NSFontAttributeName:font};
    CGRect rect = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil];
    return rect.size.width;
}

/**
 点击button
 
 @param btn btn
 */
- (void)clickBtn:(UIButton *)btn
{
    [self refreshControlsWithBtn:btn];
    // scrollView滑动
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.width * (btn.tag), 0) animated:true];
    
}

#pragma mark ---- UIScrollViewDelegate
// 将要开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        self.currentIndex = scrollView.contentOffset.x / scrollView.width;
        
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@" 滑动动画结束 ");
    if (scrollView == self.scrollView) {
        [self settingLineFrameWith:scrollView];
    }

}
// 结束减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@" 滑动减速结束 ");
    if (scrollView == self.scrollView) {
        [self settingLineFrameWith:scrollView];
    }
    
}

- (void)settingLineFrameWith:(UIScrollView *)scrollView
{
    self.currentIndex = scrollView.contentOffset.x / scrollView.width;
    [self refreshControlsWithBtn:self.btnArray[self.currentIndex]];
    
    UIButton *btn = [self.btnArray objectAtIndex:self.currentIndex];
    if (self.lineView.centerX != btn.centerX || self.lineView.width != [self getStrWidthWithStr:self.titles[btn.tag] andFont:self.font.pointSize]) {
        if (self.lineStyle == CLSlidePageBottomLineStyleNormal) {
            self.lineView.width = [self getStrWidthWithStr:self.titles[btn.tag] andFont:self.font.pointSize];
        }else{
            self.lineView.width = 20;
        }
        
        self.lineView.centerX = btn.centerX;
    }

}
// 滑动时
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        
        if ((NSUInteger)scrollView.contentOffset.x%(NSUInteger)scrollView.width == 0) {
            return;
        }
        
        UIButton *btn = self.btnArray[self.currentIndex];
        UIButton *newBtn;
        
        CGFloat move_x = scrollView.contentOffset.x - scrollView.width * self.currentIndex;
        if (move_x > 0) {
            // 向右移动
            newBtn = self.btnArray[self.currentIndex + 1];
            
        }else if (move_x < 0){
            // 向左移动
            newBtn = self.btnArray[self.currentIndex - 1];
        }
        
        CGFloat btnSpace = newBtn.centerX - btn.centerX;
        if (self.lineStyle == CLSlidePageBottomLineStyleNormal) {
            CGFloat btnStrWidth = [self getStrWidthWithStr:self.titles[btn.tag] andFont:self.font.pointSize];
            CGFloat newBtnStrWidth = [self getStrWidthWithStr:self.titles[newBtn.tag] andFont:self.font.pointSize];
            
            self.lineView.width = ABS(move_x)/scrollView.width * (newBtnStrWidth - btnStrWidth) + btnStrWidth;
        }else{
            self.lineView.width = 20;
        }
        
        self.lineView.centerX = ABS(move_x)/scrollView.width * btnSpace + btn.centerX;
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}


#pragma mark ---- 点击按钮或者划动底层scrollView时
- (void)refreshControlsWithBtn:(UIButton *)btn
{
    self.currentIndex = [self.btnArray indexOfObject:btn];
    
    // 如果selecteFont有值,切换字体font
    if (self.selecteFont) {
        for (UIButton *button in self.btnArray) {
            if (btn.tag == button.tag) {
                [button.titleLabel setFont:self.selecteFont];
            }else{
                [button.titleLabel setFont:self.font];
            }
        }
    }
    
    // 点击button或滑动scrollView，切换文字、背景的颜色
    btn.selected = YES;
    [btn setTitleColor:self.titleSeteColor forState:(UIControlStateNormal)];
    for (UIButton *button in self.btnArray) {
        if (button != btn) {
            button.selected = NO;
            [button setTitleColor:self.titleColor forState:(UIControlStateNormal)];
        }
    }
    
    
    // 被点击的按钮尽量处在中间
    if (self.allBtnWidth > self.backView.width) {
        
        if (btn.centerX > self.backView.width / 2) {
            if (self.allBtnWidth - btn.centerX > self.backView.width / 2) {
                [self.backView setContentOffset:CGPointMake(btn.centerX - self.backView.width / 2, 0) animated:true];
                
            }else{
                [self.backView setContentOffset:CGPointMake((self.allBtnWidth - self.backView.width), 0) animated:true];
            }
            
        }else{
            [self.backView setContentOffset:CGPointZero animated:true];
            
        }
    }
    
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    if (selectIndex >=0 && selectIndex < self.btnArray.count) {
        UIButton *btn = [self.btnArray objectAtIndex:selectIndex];
        [self clickBtn:btn];
    }
}

#pragma mark ---- Lazy
- (UIView *)backView
{
    if (!_backView) {
        CGRect rect_back = CGRectMake(0, 0, self.width, self.headHeight);
        _backView = [[UIScrollView alloc]initWithFrame:rect_back];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.showsHorizontalScrollIndicator = NO;
        _backView.showsVerticalScrollIndicator = NO;
        _backView.pagingEnabled = false;
        _backView.contentSize = self.allBtnWidth >= rect_back.size.width ? CGSizeMake(self.allBtnWidth , 0) : CGSizeMake(_backView.width , 0);
        
        // 根据按钮数量及文字长度设置cgrect
        int width_x = 0;
        for (int i = 0; i < self.titles.count; i ++) {
            CGRect rect = CGRectZero;;
            if (self.style == CLSlidePageStyleMiddle && self.titles.count <= 3) {
                // 按钮尽量向中靠拢
                if (self.titles.count == 3) {
                    // 有三个按钮
                    if (i == 0) {
                        rect = CGRectMake((rect_back.size.width - [self.btnWidthArray[i] intValue]) / 2 - [self.btnWidthArray[i] intValue], 0, [self.btnWidthArray[i] intValue], rect_back.size.height);
                    }
                    if (i == 1) {
                        rect = CGRectMake((rect_back.size.width - [self.btnWidthArray[i] intValue]) / 2, 0, [self.btnWidthArray[i] intValue], rect_back.size.height);
                    }
                    if (i == 2) {
                        rect = CGRectMake((rect_back.size.width - [self.btnWidthArray[i] intValue]) / 2 + [self.btnWidthArray[i] intValue], 0, [self.btnWidthArray[i] intValue], rect_back.size.height);
                    }
                }
                
                if (self.titles.count == 2) {
                    // 有两个按钮
                    if (i == 0) {
                        rect = CGRectMake(rect_back.size.width/2 - [self.btnWidthArray[i] intValue], 0, [self.btnWidthArray[i] intValue], rect_back.size.height);
                    }
                    if (i == 1) {
                        rect = CGRectMake(rect_back.size.width/2, 0, [self.btnWidthArray[i] intValue], rect_back.size.height);
                    }
                }
                
                
            }else{
                if (self.allBtnWidth >= _backView.width) {
                    rect = CGRectMake(width_x, 0, [self.btnWidthArray[i] intValue], _backView.height);
                    width_x += [self.btnWidthArray[i] intValue];
                    
                }else{
                    int num = _backView.width - self.allBtnWidth;
                    rect = CGRectMake(width_x, 0, [self.btnWidthArray[i] intValue] + num/self.titles.count, _backView.height -1);
                    width_x += rect.size.width;
                    
                }
            }
            
            // 创建按钮
            UIButton *btn = [[UIButton alloc]initWithFrame:rect];
            [btn setBackgroundColor:self.headBackColor];
            [btn setTitle:self.titles[i] forState:(UIControlStateNormal)];
            [btn setTitleColor:self.titleColor forState:(UIControlStateNormal)];
            [btn setTag:i];
            // 如果selecteFont有值,切换字体font
            if (i == self.firstIndex) {
                self.selecteFont ? [btn.titleLabel setFont:self.selecteFont] : [btn.titleLabel setFont:self.font];
            }else{
                [btn.titleLabel setFont:self.font];
            }
            [_backView addSubview:btn];
            
            // 存储button数组
            [self.btnArray addObject:btn];
            
            // 默认第一个button是点击状态
            if (i == self.firstIndex) {
                btn.selected = YES;
                [self clickBtn:btn];
                [btn setTitleColor:self.titleSeteColor forState:(UIControlStateNormal)];
                
            }
            
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        }
        
        // 创建横线
        [_backView addSubview:self.lineView];
        
    }
    return _backView;
}

- (UIView *)lineView
{
    if (!_lineView) {
        int width;
        if (self.lineStyle == CLSlidePageBottomLineStyleNormal) {
            width = [self getStrWidthWithStr:self.titles[0] andFont:self.font.pointSize];
        }else{
            width = 20;
        }
        CGRect rect = CGRectMake(0, self.backView.height - 5, width, 2);
        _lineView = [[UIView alloc]initWithFrame:rect];
        _lineView.backgroundColor = self.lineColor;
        UIButton *btn =[ self.btnArray firstObject];
        _lineView.centerX = btn.centerX;
    }
    return _lineView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:(CGRect){0, self.spaceImgV.max_y, self.width, self.height - self.spaceImgV.max_y}];
        _scrollView.contentSize = CGSizeMake(self.width * self.titles.count, 0);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = true;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = self.bounces;
        
    }
    return _scrollView;
}


- (NSMutableArray *)btnArray
{
    if (!_btnArray) {
        _btnArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _btnArray;
}
- (NSMutableArray *)viewsArray
{
    if (!_viewsArray) {
        _viewsArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _viewsArray;
}

- (NSMutableArray *)btnWidthArray
{
    if (!_btnWidthArray) {
        _btnWidthArray = [NSMutableArray arrayWithCapacity:10];
        
        for (int i = 0; i < self.titles.count; i ++) {
            NSInteger width = [self getStrWidthWithStr:self.titles[i] andFont:self.font.pointSize] + self.btnSpaceNum*2;
            [_btnWidthArray addObject:@(width)];
            
        }
    }
    return _btnWidthArray;
}
- (UIImageView *)spaceImgV
{
    if (!_spaceImgV) {
        _spaceImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.backView.max_y, self.backView.width, 10)];
        _spaceImgV.image = [UIImage imageByGradient:CGSizeMake(self.width, 10) colors:@[UIColorRGB(0xeeeeee, 1.f), UIColorRGB(0xffffff, 0.3f)] locations:@[@0, @1] startPoint:CGPointMake(0.5, 0) endPoint:CGPointMake(0.5, 1)];
    }
    return _spaceImgV;
}


@end


