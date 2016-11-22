//
//  MainBIaoQianVC.m
//  QYXPageVCDemo
//
//  Created by 邱云翔 on 16/10/23.
//  Copyright © 2016年 邱云翔. All rights reserved.
//

#define kTopScrollH 43 //顶部选项ScrollView高度

#import "MainBIaoQianVC.h"
#import "BiaoQianTopView.h"

@interface MainBIaoQianVC ()<UIScrollViewDelegate,BiaoQianTopViewDelegate>
@property (nonatomic,strong) BiaoQianTopView *topScrollView;

/**
 装控制器的字典，做缓存处理
 */
@property (nonatomic,strong) NSMutableDictionary *controllerDictionary;
@end

@implementation MainBIaoQianVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpThings];
    // Do any additional setup after loading the view.
}

#pragma mark 基础布局
- (void)setUpThings {
    //
    self.controllerFrames = [NSMutableArray array];
    self.controllerDictionary = [NSMutableDictionary dictionary];
    
    //布局
    self.view.backgroundColor = [UIColor whiteColor];
    //
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kTopScrollH + 5,kScreenSize.width, self.view.bounds.size.height - kTopScrollH - 5)];
    self.mainScrollView.delegate = self;
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.contentSize = CGSizeMake(kScreenSize.width * self.subviewControllerClass.count, 0);
    _mainScrollView.bounces = NO;
    [self.view addSubview:self.mainScrollView];
    
    //
    self.topScrollView = [[BiaoQianTopView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kTopScrollH) followScrollView:self.mainScrollView dataArr:self.topScrollViewTitleArray special:self.isSpecial];
    self.topScrollView.topDelegate = self;
    [self.view addSubview:self.topScrollView];
    
    //
    self.disPlayVC = [NSMutableDictionary dictionary];
    self.controllerFrames = [NSMutableArray array];
    
    //整合Frame方便使用
    for (int i = 0; i < self.subviewControllerClass.count; i++) {
        CGFloat dx = i * kScreenSize.width + 4;
        CGFloat height = kScreenSize.height - 64 - 5 - kTopScrollH;
        CGRect frame = CGRectMake(dx, 0, kScreenSize.width - 8, height);
        [self.controllerFrames addObject:[NSValue valueWithCGRect:frame]];
    }
    [self createViewControllerViewAtIndex:0];
    
}

#pragma mark 创建视图控制器
- (void)createViewControllerViewAtIndex:(NSInteger)index {
    Class vcClass = self.subviewControllerClass[index];
    UIViewController *vc = [[vcClass alloc] init];
    vc.view.frame = [self.controllerFrames[index] CGRectValue];
    [self addChildViewController:vc];
    [self.mainScrollView addSubview:vc.view];
    [self.disPlayVC setObject:vc forKey:@(index)];
}

#pragma mark 移除视图控制器
- (void)removeViewController:(UIViewController *)viewController AtIndex:(NSInteger)index {
    [viewController.view removeFromSuperview];
    [viewController willMoveToParentViewController:nil];
    [viewController removeFromParentViewController];
    [self.disPlayVC removeObjectForKey:@(index)];
    if ([self.controllerDictionary objectForKey:@(index)]) {
        return;
    } else {
        [self.controllerDictionary setObject:viewController forKey:@(index)];
    }
}

#pragma mark 添加视图控制器
- (void)addCacheViewController:(UIViewController *)viewController atIndex:(NSInteger)index {
    [self addChildViewController:viewController];
    [self.mainScrollView addSubview:viewController.view];
    [self.disPlayVC setObject:viewController forKey:@(index)];
}

#pragma mark 判断给定的frame是否是在可视区域
- (BOOL)isInScreen:(CGRect)frame {
    CGFloat dx = frame.origin.x;
    CGFloat width = self.mainScrollView.bounds.size.width;
    CGFloat contentOffx = self.mainScrollView.contentOffset.x;
    if (CGRectGetMaxX(frame) > contentOffx && dx - contentOffx < width) {
        return YES;
    } else {
        return NO;
    }
}


#pragma mark UIScrollViewDelegate
/**
 处理拖拽滑动的时候
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.topScrollView) {
        self.topScrollView.offset(self.mainScrollView.contentOffset.x);
    }
    //便利数组中的frame,取出可视范围的frame
    for (int i = 0; i < self.controllerFrames.count; i++) {
        CGRect frame = [self.controllerFrames[i] CGRectValue];
        UIViewController *vc = [self.disPlayVC objectForKey:@(i)];
        if ([self isInScreen:frame]) {
            if (!vc) { //如果disPlay中不存在则从缓存中取出
                //                vc = [self.controllerCache objectForKey:@(i)];
                vc = [self.controllerDictionary objectForKey:@(i)];
                if (vc) { //缓存中有则直接添加
                    [self addCacheViewController:vc atIndex:i];
                }
            }
        } else {
            if (vc) { //如果不在屏幕当中显示而且还存在就将其移除,保证不占用内存
                [self removeViewController:vc AtIndex:i];
            }
        }
    }
}


/**
 处理拖拽滑动结束的时候
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.topScrollView.offsetLabColor) {
        self.topScrollView.offsetLabColor(scrollView.contentOffset.x);
    }
    for (int i = 0; i < self.controllerFrames.count; i++) {
        CGRect frame = [self.controllerFrames[i] CGRectValue];
        UIViewController *vc = [self.disPlayVC objectForKey:@(i)];
        if ([self isInScreen:frame]) {
            if (!vc) { //如果disPlay中不存在则从缓存中取出
                vc = [self.controllerDictionary objectForKey:@(i)];
                if (!vc) { //缓存中有则直接添加
                    [self createViewControllerViewAtIndex:i];
                }
            }
        } else {
            if (vc) { //如果不在屏幕当中显示而且还存在就将其移除,保证不占用内存
                [self removeViewController:vc AtIndex:i];
            }
        }
    }
}



#pragma mark JWBiaoQianTopViewDelegate
- (void)fllowScrollViewShouldSetContentOffset {
    [self scrollViewDidEndDecelerating:self.mainScrollView];
}

- (NSMutableArray *)subviewControllerClass {
    if (!_subviewControllerClass) {
        _subviewControllerClass = [NSMutableArray array];
    }
    return _subviewControllerClass;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
