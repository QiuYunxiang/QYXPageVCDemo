//
//  UILabel+UILabel_Index.m
//  QYXPageVCDemo
//
//  Created by 邱云翔 on 16/10/23.
//  Copyright © 2016年 邱云翔. All rights reserved.
//

#import "UILabel+UILabel_Index.h"
#import <objc/runtime.h>

@implementation UILabel (UILabel_Index)
const char indexKey;

#pragma mark setSetterAndGetter

- (void)setIndex:(NSInteger)index {
    objc_setAssociatedObject(self, &indexKey, @(index), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)index {
    return [objc_getAssociatedObject(self, &indexKey) integerValue];
}

@end
