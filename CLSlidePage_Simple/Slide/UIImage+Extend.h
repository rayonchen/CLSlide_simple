//
//  UIImage+Extend.h
//  CategoryModule
//
//  Created by gaobo on 2018/8/7.
//  Copyright © 2018年 stock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extend)
+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color
                       size:(CGSize)size
               cornerRadius:(CGFloat)radius;

+ (UIImage *)imageWithColor:(UIColor *)color
                       size:(CGSize)size
               cornerRadius:(CGFloat)radius
                borderWidth:(CGFloat)borderWidth
                borderColor:(UIColor *)borderColor;


/**
 全屏截图
 */
+ (UIImage *)imageWithScreenshot;
/**
 创建渐变色图片
 */
+ (UIImage *)imageByGradient:(CGSize)size
                      colors:(NSArray *)colors
                   locations:(NSArray <NSNumber *>*)locations
                  startPoint:(CGPoint)startPoint
                    endPoint:(CGPoint)endPoint;

/**
 创建渐变色图片--简单版(横向)
 */
+ (UIImage *)imageHorizontalByGradient:(CGSize)size
                      colors:(NSArray *)colors;

/**
 创建渐变色图片--简单版(竖向)
 */
+ (UIImage *)imageVerticalByGradient:(CGSize)size
                      colors:(NSArray *)colors;

/**
 创建纯色图片
 */
+ (UIImage *)imageByColor:(UIColor *)color;
/**
 创建带圆角的纯色图片
 */
+ (UIImage *)imageByColor:(UIColor *)color
                     size:(CGSize)size
                   radius:(CGFloat)radius;
/**
 创建指定位置圆角的纯色图片
 */
+ (UIImage *)imageByColor:(UIColor *)color
                     size:(CGSize)size
                   corner:(UIRectCorner)corner
             cornerRadius:(CGFloat)radius;
/**
 创建圆角带描边的纯色图片
 */
+ (UIImage *)imageByColor:(UIColor *)color
                     size:(CGSize)size
             cornerRadius:(CGFloat)radius
              borderWidth:(CGFloat)borderWidth
              borderColor:(UIColor *)borderColor;
/**
 创建指定位置圆角并带描边的纯色图片
 */
+ (UIImage *)imageByColor:(UIColor *)color
                     size:(CGSize)size
                   corner:(UIRectCorner)corner
             cornerRadius:(CGFloat)radius
              borderWidth:(CGFloat)borderWidth
              borderColor:(UIColor *)borderColor;


/**
 给图片切圆角
 */
- (UIImage *)imageByRadius:(CGFloat)radius;
/**
 给图片指定位置切圆角
 */
- (UIImage *)imageByRadius:(CGFloat)radius
                    corner:(UIRectCorner)corner;
/**
 给图片加描边
 */
- (UIImage *)imageByBorderWidth:(CGFloat)borderWidth
                    borderColor:(UIColor *)borderColor;
/**
 切圆角加描边
 */
- (UIImage *)imageByRadius:(CGFloat)radius
               borderWidth:(CGFloat)borderWidth
               borderColor:(UIColor *)borderColor;
/**
 给图片指定位置切圆角，加描边
 */
- (UIImage *)imageByRadius:(CGFloat)radius
                    corner:(UIRectCorner)corner
               borderWidth:(CGFloat)borderWidth
               borderColor:(UIColor *)borderColor;
/**
 缩放图片
 */
- (UIImage *)imageBySize:(CGSize)size;
/**
 裁切图片
 */
- (UIImage *)imageByClipRect:(CGRect)rect;




/**
 生成二维码图片
 */
+ (UIImage *)makeQRImageWithContent:(NSString *)content
                               size:(CGFloat)size;

/**
 获得清晰指定大小图片
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image
                                            withSize:(CGFloat)size;
/**
 uiview转uiimage
 */
+ (UIImage *)imageByView:(UIView *)view;
@end
