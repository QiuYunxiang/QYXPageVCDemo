//
//  BiaoQianTopView.h
//  QYXPageVCDemo
//
//  Created by 邱云翔 on 16/10/23.
//  Copyright © 2016年 邱云翔. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^offsetBlock)(CGFloat dy);
typedef void(^offsetLabColorBlock)(CGFloat dy);

@protocol BiaoQianTopViewDelegate <NSObject>
/**
 * 跟随的ScrollView设置偏移
 */
- (void)fllowScrollViewShouldSetContentOffset;

@end

@interface BiaoQianTopView : UIView

/**
 回调block设置line线偏移
 */
@property (nonatomic,copy) offsetBlock offset;

/**
 回调设置lab颜色
 */
@property (nonatomic,copy) offsetLabColorBlock offsetLabColor;

/**
 装lab的数组
 */
@property (nonatomic,strong) NSMutableArray <UILabel *>*dataArr;

/**
 下划线lab
 */
@property (nonatomic,strong) UILabel *lineLab;

/**
 ScrollView
 */
@property (nonatomic,strong) UIScrollView *myScroll;
/**
 *  配置Dictionary
 */
@property (nonatomic,copy) NSDictionary *settingDictionary;

/**
 代理
 */
@property (nonatomic,assign) id<BiaoQianTopViewDelegate> topDelegate;


/**
 *  BiaoQianTopView初始化方法
 *
 *  @param frame   frame
 *  @param scroll  跟随ScrollView
 *  @param array     数据数组
 *  @param special 滑动是否可以超出屏幕
 */
- (instancetype)initWithFrame:(CGRect)frame followScrollView:(UIScrollView *)scroll dataArr:(NSArray *)array special:(BOOL)special;
@end
