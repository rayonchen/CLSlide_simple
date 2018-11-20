//
//  SwizzlingDefine.h
//  WorldCup
//
//  Created by gaobo on 2018/4/13.
//  Copyright © 2018年 xlan. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

UIKIT_STATIC_INLINE void swizzling_exchangeMethod(Class clazz ,SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(clazz, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(clazz, swizzledSelector);
    
    BOOL success = class_addMethod(clazz, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(clazz, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

UIKIT_STATIC_INLINE void swizzling_exchangeClassMethod(Class clazz ,SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getClassMethod(clazz, originalSelector);
    Method swizzledMethod = class_getClassMethod(clazz, swizzledSelector);
    
    BOOL success = class_addMethod(clazz, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(clazz, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
