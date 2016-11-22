//
//  BiaoQianTopView.m
//  QYXPageVCDemo
//
//  Created by 邱云翔 on 16/10/23.
//  Copyright © 2016年 邱云翔. All rights reserved.
//

#define kLineLabColor [UIColor redColor]
#define kBiaoQianInterval 10  //标签之间的间隔
#define kLabTextInsertLR 20 //文字距离lab左右间隔

#import "BiaoQianTopView.h"
#import "UILabel+UILabel_Index.h"

@interface BiaoQianTopView ()
@property (nonatomic,strong) UIScrollView *followScroll;

/**
 配置属性-字体大小
 */
@property (nonatomic,assign) CGFloat textFont;

/**
 正常状态文字颜色
 */
@property (nonatomic,strong) UIColor *textNormalColor;

/**
 选中状态文字颜色
 */
@property (nonatomic,strong) UIColor *textSelectedColor;

/**
 下划线颜色
 */
@property (nonatomic,strong) UIColor *lineColor;

/**
 是否超出屏幕（可滑动）
 */
@property (nonatomic,assign) BOOL isSpecial;

/**
 标签中心点数组
 */
@property (nonatomic,strong) NSMutableArray <NSValue *>*centerArray;

/**
 标签大小数组
 */
@property (nonatomic,strong) NSMutableArray <NSValue *>*boundsArray;

@end

@implementation BiaoQianTopView

#pragma mark 初始化
- (instancetype)initWithFrame:(CGRect)frame followScrollView:(UIScrollView *)scroll dataArr:(NSArray *)arr special:(BOOL)special {
    self = [super initWithFrame:frame];
    if (self) {
        self.followScroll = scroll; //设置跟随Scroll
        [self setUpThings];
        [self setUpContentWithDataArr:arr special:special];  //设置scroll上的控件
        [self topSscrolViewSetContentoffset]; //设置scroll偏移效果
    }
    return self;
}

#pragma mark 设置基础配置
- (void)setUpThings {
    if (!_settingDictionary) {
        [self setUpCommonSetting];
        return;
    } else {
        //自行配置参数
    }
}

#pragma mark 默认配置
- (void)setUpCommonSetting {
    self.textFont = 15;
    self.textNormalColor = HEXCOLOR(0x3c3c3c);
    self.textSelectedColor = HEXCOLOR(0xff9c01);
    self.lineColor = HEXCOLOR(0xff9c01);
}

#pragma mark 设置ScrollView上的标签控件
- (void)setUpContentWithDataArr:(NSArray *)dataArr special:(BOOL)special{
    self.dataArr = [NSMutableArray array];
    
    
    if ([self calculateBiaoQianIsSpecialWithArray:dataArr]) {
        self.isSpecial = YES;
    } else {
        self.isSpecial = NO;
    }
    
    //计算结果和强制指定不相等时，以强制指定为准
    if (self.isSpecial != special) {
        self.isSpecial = special;
    }
    
    self.backgroundColor = [UIColor whiteColor];
    //初始化myScroll
    self.myScroll = [[UIScrollView alloc] initWithFrame:self.bounds];
    _myScroll.bounces = NO;
    [self addSubview:_myScroll];
    
    self.userInteractionEnabled = YES;
    self.myScroll.userInteractionEnabled = YES;
    //滑动可超过屏幕宽度
    if (_isSpecial == YES) {
        self.centerArray = [NSMutableArray array];
        self.boundsArray = [NSMutableArray array];
        CGFloat width = 0;
        for (int i = 0; i < dataArr.count; i++) {
            CGFloat labWidth = [self widthForCalculationHeightWithString:dataArr[i] height:999 font:_textFont] + kLabTextInsertLR * 2;
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(width + kBiaoQianInterval, 5,labWidth, self.bounds.size.height - 12)];
            width += labWidth + kBiaoQianInterval;
            [_centerArray addObject:[NSValue valueWithCGPoint:lab.center]];
            [_boundsArray addObject:[NSValue valueWithCGRect:lab.bounds]];
            lab.font = [UIFont systemFontOfSize:_textFont];
            lab.userInteractionEnabled = YES;
            lab.textAlignment = NSTextAlignmentCenter;
            lab.index = i;
            lab.text = dataArr[i];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleLabFollowShouldChange:)];
            if (i == 0) {
                lab.textColor = _textSelectedColor;
            } else {
                lab.textColor = _textNormalColor;
            }
            [lab addGestureRecognizer:tap];
            [self.myScroll addSubview:lab];
            [self.dataArr addObject:lab];
            if (i == dataArr.count - 1) {
                [_centerArray addObject:[NSValue valueWithCGPoint:lab.center]];
                [_boundsArray addObject:[NSValue valueWithCGRect:lab.bounds]];
            }
        }
        self.myScroll.contentSize = CGSizeMake(width + kBiaoQianInterval, self.bounds.size.height);
        self.lineLab = [[UILabel alloc] initWithFrame:CGRectMake(kBiaoQianInterval, self.bounds.size.height - 2, _dataArr[0].bounds.size.width, 2)];
        _lineLab.backgroundColor = _lineColor;
        [self.myScroll addSubview:_lineLab];
        
    } else {
        self.centerArray = [NSMutableArray array];
        //滑动不可超过屏幕宽度
        float labWidth = 0;
        labWidth = floor((kScreenSize.width - (kBiaoQianInterval * (dataArr.count + 1))) / dataArr.count);
        for (int i = 0; i < dataArr.count; i++) {
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(kBiaoQianInterval + (labWidth  + kBiaoQianInterval) * i, 5, labWidth, self.bounds.size.height - 12)];
            if (i == 0) {
                lab.textColor = _textSelectedColor;
            } else {
                lab.textColor = _textNormalColor;
            }
            lab.font = [UIFont systemFontOfSize:15];
            lab.userInteractionEnabled = YES;
            lab.textAlignment = NSTextAlignmentCenter;
            lab.index = i;
            lab.text = dataArr[i];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleLabFollowShouldChange:)];
            [lab addGestureRecognizer:tap];
            [self.myScroll addSubview:lab];
            [self.dataArr addObject:lab];
            [_centerArray addObject:[NSValue valueWithCGPoint:lab.center]];
        }
        self.myScroll.contentSize = CGSizeMake(kScreenSize.width, self.bounds.size.height);
        self.lineLab = [[UILabel alloc] initWithFrame:CGRectMake(kBiaoQianInterval, self.bounds.size.height - 2, labWidth, 2)];
        _lineLab.backgroundColor = _lineColor;
        [self.myScroll addSubview:_lineLab];
    }
    self.myScroll.showsHorizontalScrollIndicator = NO;
}

#pragma mark 设置scroll的偏移
- (void)topSscrolViewSetContentoffset {
    //第一个lab的center
    UILabel *firstLab = _dataArr[0];
    UILabel *lastLab = _dataArr[_dataArr.count - 1];
    CGPoint firstLabCenter = firstLab.center;
    CGFloat moreWidth = firstLab.center.x + _myScroll.contentSize.width - lastLab.center.x;
    __block CGFloat mdx = 0;
    __weak typeof(self) weakSelf = self;
    self.offset = ^(CGFloat dy) {
        if (weakSelf.isSpecial) {
            NSInteger index = dy / kScreenSize.width;
            CGFloat offsetX = dy - index * kScreenSize.width;
            CGFloat indexDx = offsetX * 1.0 / kScreenSize.width * ([_centerArray[index + 1] CGPointValue].x - [_centerArray[index] CGPointValue].x);
            CGFloat offsetW = offsetX * 1.0 / kScreenSize.width * ([_boundsArray[index + 1] CGRectValue].size.width - [_boundsArray[index] CGRectValue].size.width);
            weakSelf.lineLab.center = CGPointMake([_centerArray[index] CGPointValue].x + indexDx, weakSelf.lineLab.center.y);
            weakSelf.lineLab.bounds = CGRectMake(0, 0, [_boundsArray[index] CGRectValue].size.width + offsetW, 2);
        } else {
            CGFloat indexDx = dy * 1.0 / (kScreenSize.width * (_dataArr.count - 1)) * (weakSelf.myScroll.contentSize.width - moreWidth);
            weakSelf.lineLab.center = CGPointMake(firstLabCenter.x + indexDx, weakSelf.lineLab.center.y);
        }
        
    };
    
    //改变文字颜色
    self.offsetLabColor = ^(CGFloat dy) {
        NSInteger index = dy / kScreenSize.width;
        for (UILabel *lab in weakSelf.dataArr) {
            if (lab.index == index) {
                lab.textColor = weakSelf.textSelectedColor;
                weakSelf.lineLab.center = CGPointMake(lab.center.x, weakSelf.lineLab.center.y);
                mdx = lab.center.x - kScreenSize.width / 2;
            } else {
                lab.textColor = weakSelf.textNormalColor;
            }
        }
        
        if (_isSpecial == NO) {
            return ;
        }
        
        if (mdx < 0) {
            [weakSelf.myScroll setContentOffset:CGPointMake(0, 0) animated:YES];
            return ;
        }
        
        if (mdx > weakSelf.myScroll.contentSize.width - kScreenSize.width) {
            [weakSelf.myScroll setContentOffset:CGPointMake(weakSelf.myScroll.contentSize.width - kScreenSize.width, 0) animated:YES];
            return;
        }
        [weakSelf.myScroll setContentOffset:CGPointMake(mdx, 0) animated:YES];
    };
}


#pragma mark 计算所给定的标签是否需要需要滑动
- (BOOL)calculateBiaoQianIsSpecialWithArray:(NSArray *)biaoQianArray {
    CGFloat widthSum = kBiaoQianInterval;
    for (int i = 0; i < biaoQianArray.count; i++) {
        widthSum += [self widthForCalculationHeightWithString:biaoQianArray[i] height:9999 font:_textFont] + kLabTextInsertLR * 2 + kBiaoQianInterval;
    }
    if (widthSum >= kScreenSize.width) {
        return YES;
    }
    return NO;
}

#pragma mark 点击标签，设置下划线lab的偏移
- (void)handleLabFollowShouldChange:(UITapGestureRecognizer *)tap {
    UILabel *lab = (UILabel *)tap.view;
    [self.followScroll setContentOffset:CGPointMake(kScreenSize.width * lab.index, 0)];
    if (self.topDelegate && [self.topDelegate respondsToSelector:@selector(fllowScrollViewShouldSetContentOffset)]) {
        [self.topDelegate fllowScrollViewShouldSetContentOffset];
    }
    self.lineLab.center = CGPointMake(lab.center.x, _lineLab.center.y);
}

#pragma mark 工具
- (CGFloat)widthForCalculationHeightWithString:(NSString *)string height:(CGFloat)height font:(CGFloat)font {
    return [string boundingRectWithSize:CGSizeMake(99999, height) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size.width;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
