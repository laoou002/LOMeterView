//
//  LOMeterView.h
//  LOMeterView
//
//  Created by 欧ye on 16/3/17.
//  Copyright © 2016年 老欧. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LOMeterView : UIView

@property (strong, nonatomic) NSArray *textArray;//刻度文本
@property (strong, nonatomic) NSDictionary *textAttributes;//文本属性

@property (nonatomic) CGFloat roundRadius;//圆半径
@property (nonatomic) CGFloat textRadius;//文本半径
@property (nonatomic) CGFloat radian;//内容弧度
@property (nonatomic) CGFloat characterSpacing;//字符间隔
@property (nonatomic) CGFloat roundLineWidth;//圆线的宽度
@property (nonatomic) CGPoint circleCenterPoint;//圆心位置
@property (nonatomic) CGFloat progress;//指针百分比，可用于初始指针位置

//百分比回调
@property (nonatomic) void (^progressBlock)(CGFloat progress);

//加速
- (void)speedUpAction:(BOOL)up;
//灵敏度调整
- (void)sensitivityAction:(NSTimeInterval)duration;
//暂停
- (void)pause;

#pragma mark - 弧度与角度的转换
+ (float)angleForRadians:(CGFloat)radians;
+ (float)radiansForAngle:(CGFloat)angle;

@end
