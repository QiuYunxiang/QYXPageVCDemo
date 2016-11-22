//
//  MainBIaoQianVC.h
//  QYXPageVCDemo
//
//  Created by 邱云翔 on 16/10/23.
//  Copyright © 2016年 邱云翔. All rights reserved.
//

/*
 注:关于缓存这一块demo里直接用了字典，比较好的方式是仿照NSCache在字典的基础之上自定义一个缓存的类，之所以不用NSCache是因为封装程度太高可自定义的部分太少，内部处理机制不明确（进入后台NSCache自动清除所有数据）,很多地方不能满足需要。
    这里建议根据自己的情况自定义
 */


/**
 事件的触发表现在两个状态，可视部分和不可视部分。可视部分正常显示，不可视部分加入缓存。
 
 */


#import <UIKit/UIKit.h>

@interface MainBIaoQianVC : UIViewController

/**
 需要建的类的数组
 */
@property (nonatomic,strong) NSMutableArray *subviewControllerClass;

/**
 顶部TopScroll数据
 */
@property (nonatomic,strong) NSMutableArray *topScrollViewTitleArray;

/**
 选项topScroll是否超出屏幕（优先级最高，设置之后不再以topScroll数据判断是否超出屏幕）
 */
@property (nonatomic,assign) BOOL isSpecial;

/**
 主Scroll
 */
@property (nonatomic,strong) UIScrollView *mainScrollView;

/**
 保存控制器view的 frame
 */
@property (nonatomic,strong) NSMutableArray *controllerFrames;

/**
 将要显示的VC  始终保持在1-2
 */
@property (nonatomic,strong) NSMutableDictionary *disPlayVC;



/**
 *  子类可重写动态创建控制器
 *
 *  @param index 第几个控制器
 */
- (void)createViewControllerViewAtIndex:(NSInteger)index;

@end
