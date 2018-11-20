//
//  UIImage+Extend.m
//  CategoryModule
//
//  Created by gaobo on 2018/8/7.
//  Copyright © 2018年 stock. All rights reserved.
//

#import "UIImage+Extend.h"

@implementation UIImage (Extend)
+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)radius{
    UIImage *image = [self imageWithColor:color size:size];
    image = [image imageByRoundCornerRadius:radius];
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color
                       size:(CGSize)size
               cornerRadius:(CGFloat)radius
                borderWidth:(CGFloat)borderWidth
                borderColor:(UIColor *)borderColor{
    
    UIImage *image = [self imageWithColor:color size:size];
    image = [image imageByRoundCornerRadius:radius borderWidth:borderWidth borderColor:borderColor];
    return image;
}

#pragma mark --
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius {
    return [self imageByRoundCornerRadius:radius borderWidth:0 borderColor:nil];
}

- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor {
    return [self imageByRoundCornerRadius:radius
                                  corners:UIRectCornerAllCorners
                              borderWidth:borderWidth
                              borderColor:borderColor
                           borderLineJoin:kCGLineJoinMiter];
}

- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                              corners:(UIRectCorner)corners
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor
                       borderLineJoin:(CGLineJoin)borderLineJoin {
    
    if (corners != UIRectCornerAllCorners) {
        UIRectCorner tmp = 0;
        if (corners & UIRectCornerTopLeft) tmp |= UIRectCornerBottomLeft;
        if (corners & UIRectCornerTopRight) tmp |= UIRectCornerBottomRight;
        if (corners & UIRectCornerBottomLeft) tmp |= UIRectCornerTopLeft;
        if (corners & UIRectCornerBottomRight) tmp |= UIRectCornerTopRight;
        corners = tmp;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -rect.size.height);
    
    CGFloat minSize = MIN(self.size.width, self.size.height);
    if (borderWidth < minSize / 2) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, borderWidth, borderWidth) byRoundingCorners:corners cornerRadii:CGSizeMake(radius, borderWidth)];
        [path closePath];
        
        CGContextSaveGState(context);
        [path addClip];
        CGContextDrawImage(context, rect, self.CGImage);
        CGContextRestoreGState(context);
    }
    
    if (borderColor && borderWidth < minSize / 2 && borderWidth > 0) {
        CGFloat strokeInset = (floor(borderWidth * self.scale) + 0.5) / self.scale;
        CGRect strokeRect = CGRectInset(rect, strokeInset, strokeInset);
        CGFloat strokeRadius = radius > self.scale / 2 ? radius - self.scale / 2 : 0;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:strokeRect byRoundingCorners:corners cornerRadii:CGSizeMake(strokeRadius, borderWidth)];
        [path closePath];
        
        path.lineWidth = borderWidth;
        path.lineJoinStyle = borderLineJoin;
        [borderColor setStroke];
        [path stroke];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}










+ (NSData *)dataWithScreenshotInPNGFormat{
    
    UIGraphicsEndImageContext();
    
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
    imageSize = [UIScreen mainScreen].bounds.size; //竖屏
    else
    imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width); //横屏
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]){
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        //根据偏转修改坐标系，来显示图片
        if (orientation == UIInterfaceOrientationLandscapeLeft){
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }else if (orientation == UIInterfaceOrientationLandscapeRight){
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]){
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }else{
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImagePNGRepresentation(image);
}


+ (UIImage *)imageWithScreenshot{
    NSData *imageData = [self dataWithScreenshotInPNGFormat];
    return [UIImage imageWithData:imageData];
}


+ (UIImage *)imageByGradient:(CGSize)size
                      colors:(NSArray *)colors
                   locations:(NSArray<NSNumber *> *)locations
                  startPoint:(CGPoint)startPoint
                    endPoint:(CGPoint)endPoint {
    
    NSMutableArray *mutableColors = [[NSMutableArray alloc] initWithCapacity:colors.count];
    for (UIColor *color in colors) {
        [mutableColors addObject:(__bridge id)color.CGColor];
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    gradientLayer.colors = mutableColors;
    gradientLayer.locations = locations;
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    [view.layer addSublayer:gradientLayer];
    
    view.backgroundColor = [UIColor clearColor];
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tImage;
}

+ (UIImage *)imageHorizontalByGradient:(CGSize)size colors:(NSArray *)colors
{
    return [UIImage imageByGradient:size
                             colors:colors
                          locations:@[@0,@1]
                         startPoint:CGPointZero
                           endPoint:CGPointMake(1, 0)];
}

+ (UIImage *)imageVerticalByGradient:(CGSize)size colors:(NSArray *)colors
{
    return [UIImage imageByGradient:size
                             colors:colors
                          locations:@[@0,@1]
                         startPoint:CGPointZero
                           endPoint:CGPointMake(0, 1)];
}


/**
 创建纯色图片
 */
+ (UIImage *)imageByColor:(UIColor *)color {
    return [self imageByColor:color size:CGSizeMake(1, 1)];
}
/**
 创建带圆角的纯色图片
 */
+ (UIImage *)imageByColor:(UIColor *)color
                     size:(CGSize)size
                   radius:(CGFloat)radius {
    return [self imageByColor:color
                         size:size
                       corner:UIRectCornerAllCorners
                 cornerRadius:radius];
}
/**
 创建指定位置圆角的纯色图片
 */
+ (UIImage *)imageByColor:(UIColor *)color
                     size:(CGSize)size
                   corner:(UIRectCorner)corner
             cornerRadius:(CGFloat)radius {
    UIImage *image = [self imageByColor:color size:size];
    return [image imageByRadius:radius
                         corner:corner];
}
/**
 创建圆角带描边的纯色图片
 */
+ (UIImage *)imageByColor:(UIColor *)color
                     size:(CGSize)size
             cornerRadius:(CGFloat)radius
              borderWidth:(CGFloat)borderWidth
              borderColor:(UIColor *)borderColor {
    return [self imageByColor:color
                         size:size
                       corner:UIRectCornerAllCorners
                 cornerRadius:radius
                  borderWidth:borderWidth
                  borderColor:borderColor];
}
/**
 创建指定位置圆角并带描边的纯色图片
 */
+ (UIImage *)imageByColor:(UIColor *)color
                     size:(CGSize)size
                   corner:(UIRectCorner)corner
             cornerRadius:(CGFloat)radius
              borderWidth:(CGFloat)borderWidth
              borderColor:(UIColor *)borderColor {
    UIImage *image = [self imageByColor:color size:size];
    return [image imageByRadius:radius
                        corners:UIRectCornerAllCorners
                    borderWidth:borderWidth
                    borderColor:borderColor
                 borderLineJoin:kCGLineJoinMiter];
}


+ (UIImage *)imageByColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}




/**
 给图片切圆角
 */
- (UIImage *)imageByRadius:(CGFloat)radius {
    return [self imageByRadius:radius corner:UIRectCornerAllCorners];
}
/**
 给图片指定位置切圆角
 */
- (UIImage *)imageByRadius:(CGFloat)radius
                    corner:(UIRectCorner)corner {
    return [self imageByRadius:radius
                       corners:corner
                   borderWidth:0
                   borderColor:nil
                borderLineJoin:kCGLineJoinMiter];
}
/**
 给图片加描边
 */
- (UIImage *)imageByBorderWidth:(CGFloat)borderWidth
                    borderColor:(UIColor *)borderColor {
    return [self imageByRadius:0
                       corners:UIRectCornerAllCorners
                   borderWidth:borderWidth
                   borderColor:borderColor
                borderLineJoin:kCGLineJoinMiter];
}
/**
 切圆角加描边
 */
- (UIImage *)imageByRadius:(CGFloat)radius
               borderWidth:(CGFloat)borderWidth
               borderColor:(UIColor *)borderColor {
    return [self imageByRadius:radius
                       corners:UIRectCornerAllCorners
                   borderWidth:borderWidth
                   borderColor:borderColor
                borderLineJoin:kCGLineJoinMiter];
}
/**
 给图片指定位置切圆角，加描边
 */
- (UIImage *)imageByRadius:(CGFloat)radius
                    corner:(UIRectCorner)corner
               borderWidth:(CGFloat)borderWidth
               borderColor:(UIColor *)borderColor {
    return [self imageByRadius:radius
                       corners:corner
                   borderWidth:borderWidth
                   borderColor:borderColor
                borderLineJoin:kCGLineJoinMiter];
}

/**
 缩放图片
 */
- (UIImage *)imageBySize:(CGSize)size {
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, CGRectMake(0, 0, size.width, size.height));
    CGContextSetInterpolationQuality(context,0);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height) blendMode:kCGBlendModeNormal alpha:1];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 裁切图片
 */
- (UIImage *)imageByClipRect:(CGRect)rect {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat x= rect.origin.x*scale,y=rect.origin.y*scale,w=rect.size.width*scale,h=rect.size.height*scale;
    CGRect dianRect = CGRectMake(x, y, w, h);
    CGImageRef sourceImageRef = [self CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, dianRect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    return newImage;
}





- (UIImage *)imageByRadius:(CGFloat)radius
                   corners:(UIRectCorner)corners
               borderWidth:(CGFloat)borderWidth
               borderColor:(UIColor *)borderColor
            borderLineJoin:(CGLineJoin)borderLineJoin {
    
    if (corners != UIRectCornerAllCorners) {
        UIRectCorner tmp = 0;
        if (corners & UIRectCornerTopLeft) tmp |= UIRectCornerBottomLeft;
        if (corners & UIRectCornerTopRight) tmp |= UIRectCornerBottomRight;
        if (corners & UIRectCornerBottomLeft) tmp |= UIRectCornerTopLeft;
        if (corners & UIRectCornerBottomRight) tmp |= UIRectCornerTopRight;
        corners = tmp;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -rect.size.height);
    
    CGFloat minSize = MIN(self.size.width, self.size.height);
    if (borderWidth < minSize / 2) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, borderWidth, borderWidth) byRoundingCorners:corners cornerRadii:CGSizeMake(radius, borderWidth)];
        [path closePath];
        
        CGContextSaveGState(context);
        [path addClip];
        CGContextDrawImage(context, rect, self.CGImage);
        CGContextRestoreGState(context);
    }
    
    if (borderColor && borderWidth < minSize / 2 && borderWidth > 0) {
        CGFloat strokeInset = (floor(borderWidth * self.scale) + 0.5) / self.scale;
        CGRect strokeRect = CGRectInset(rect, strokeInset, strokeInset);
        CGFloat strokeRadius = radius > self.scale / 2 ? radius - self.scale / 2 : 0;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:strokeRect byRoundingCorners:corners cornerRadii:CGSizeMake(strokeRadius, borderWidth)];
        [path closePath];
        
        path.lineWidth = borderWidth;
        path.lineJoinStyle = borderLineJoin;
        [borderColor setStroke];
        [path stroke];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}





/**
 生成二维码图片
 */
+ (UIImage *)makeQRImageWithContent:(NSString *)content
                               size:(CGFloat)size {
    if (!content || [content length] == 0)
    return nil;
    // 1. 创建一个二维码滤镜实例(CIFilter)
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];
    
    // 2. 给滤镜添加数据
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    // 使用KVC的方式给filter赋值
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 3. 生成二维码
    CIImage *image = [filter outputImage];
    return [UIImage createNonInterpolatedUIImageFormCIImage:image withSize:size];
}

/**
 获得清晰指定大小图片
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image
                                            withSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}


+ (UIImage *)imageByView:(UIView *)view {
    CGSize size = view.bounds.size;
    //下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
