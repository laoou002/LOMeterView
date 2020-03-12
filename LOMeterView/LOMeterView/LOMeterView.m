//
//  LOMeterView.m
//  LOMeterView
//
//  Created by 欧ye on 16/3/17.
//  Copyright © 2016年 老欧. All rights reserved.
//

#import "LOMeterView.h"
#import <QuartzCore/QuartzCore.h>

@interface LOMeterView ()

@property (nonatomic, strong) NSMutableArray *startRadianArray;

@property (nonatomic, assign) NSUInteger lineAngle;
@property (nonatomic, strong) UIImageView *lineView;

@property (nonatomic, assign) NSInteger speed;//速度,指示针在固定时间转动的弧度
@property (nonatomic, assign) BOOL isRunning;//是否运行中

@property (nonatomic, assign) CGFloat minStartRadian;
@property (nonatomic, assign) CGFloat maxEndRadian;

@property (nonatomic) NSTimeInterval duration;

@end

@implementation LOMeterView

//绘制
- (void)drawRect:(CGRect)rect{
    if (self.startRadianArray==nil)
        self.startRadianArray = [[NSMutableArray alloc] init];
    else
        [self.startRadianArray removeAllObjects];

    [self drawRound];
    [self drawText];
}

//绘制文本
- (void)drawText{
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (int i=0;i<self.textArray.count;i++) {
        NSString *text = self.textArray[i];
        float startAngle = [self.startRadianArray[i] floatValue];
        CGSize textSize = [text sizeWithAttributes:self.textAttributes];
        textSize = CGSizeMake(textSize.width, textSize.height);
        
        //计算半径
        float radius = (self.textRadius <=0) ? (self.bounds.size.width <= self.bounds.size.height) ? self.bounds.size.width / 2 - textSize.height: self.bounds.size.height / 2 - textSize.height : self.textRadius;
        
        //计算字符角度
        self.characterSpacing = (self.characterSpacing > 0) ? self.characterSpacing : 1;
        float circumference = 2 * radius * M_PI;
        float anglePerPixel = M_PI * 2 / circumference * self.characterSpacing;
        
        //初始角度
        startAngle = startAngle - (textSize.width * anglePerPixel/2);
        
        float characterPosition = 0;
        NSString *lastCharacter;
        //循环绘制字符文本
        for (NSInteger charIdx=0; charIdx<text.length; charIdx++) {
            //当前字符
            NSString *currentCharacter = [NSString stringWithFormat:@"%c", [text characterAtIndex:charIdx]];
            
            //设置当前字符大小和字距调整
            CGSize stringSize = [currentCharacter sizeWithAttributes:self.textAttributes];
            float kerning = (lastCharacter) ? [self kerningForCharacter:currentCharacter afterCharacter:lastCharacter] : 0;
            
            //将字符宽度的一半加到字符位置，减去字距调整
            characterPosition += (stringSize.width / 2) - kerning;
            
            //计算角度
            float angle = characterPosition * anglePerPixel + startAngle;
            
            //当前字符位置
            CGPoint characterPoint = CGPointMake(radius * cos(angle) + self.circleCenterPoint.x, radius * sin(angle) + self.circleCenterPoint.y);
            
            //字符串位置
            CGPoint stringPoint = CGPointMake(characterPoint.x -stringSize.width/2, characterPoint.y - stringSize.height);
            
            //旋转
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, characterPoint.x, characterPoint.y);
            CGAffineTransform textTransform = CGAffineTransformMakeRotation(angle + M_PI_2);
            CGContextConcatCTM(context, textTransform);
            CGContextTranslateCTM(context, -characterPoint.x, -characterPoint.y);
            
            //绘制字符
            [currentCharacter drawAtPoint:stringPoint withAttributes:self.textAttributes];
            
            //恢复上下文以确保仅将旋转应用于此字符
            CGContextRestoreGState(context);
            
            //将字符大小的另一半添加到字符位置
            characterPosition += stringSize.width / 2;
            
            //如果已经绕满一圈，则停止
            if (characterPosition * anglePerPixel >= M_PI*2) break;
            
            //存储currentCharacter，以在下一次运行中进行字距调整计算。
            lastCharacter = currentCharacter;
        }
    }
}

//根据textArray的count、弧度radians、半径radius、圆线的宽度画圆
- (void)drawRound{
    [super drawRect:self.frame];
    //Set drawing context.
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.roundLineWidth);//线的宽度
    NSInteger count = self.textArray.count;
    
    self.minStartRadian = [self doubleByRounding:M_PI-(self.radian-M_PI)/2];//最初的开始
    self.maxEndRadian = _minStartRadian+self.radian;
    float startRadian = _minStartRadian;//每一块的开始
    float lineRadian = [self doubleByRounding:M_PI/180];//每根分界线的所占弧度
    float itemRadian = [self doubleByRounding:(self.radian/(count-1))];//每等份的弧度
    
    self.lineAngle = [LOMeterView angleForRadians:_minStartRadian];
    
    [self.startRadianArray addObject:[NSNumber numberWithFloat:startRadian]];
    for (int i=0; i<count; i++) {
        float endRadian = [self doubleByRounding:startRadian+itemRadian];
        CGContextSetRGBStrokeColor(context,209.0/255.0,73.0/255.0,70.0/255.0,1.0);//画笔线的颜色
        CGContextAddArc(context, self.circleCenterPoint.x, self.circleCenterPoint.y,self.roundRadius+self.roundLineWidth, startRadian, startRadian+lineRadian, 0); //添加一个圆
        CGContextDrawPath(context, kCGPathStroke); //绘制路径
        
        startRadian = endRadian;
        [self.startRadianArray addObject:[NSNumber numberWithFloat:startRadian]];
    }
    
    //指针
    if (self.lineView==nil) {
        CGFloat lineWidth = self.textRadius - 2;
        CGFloat lineHeight = 30;
        self.lineView = [[UIImageView alloc] initWithFrame:CGRectMake(self.circleCenterPoint.x-lineWidth/2, self.circleCenterPoint.y-lineHeight/2, lineWidth, lineHeight)];
        self.lineView.image = [UIImage imageNamed:@"icon_arrow"];
        self.lineView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.lineView];
    }
    
    //按百分比设置指针初始角度
    CGAffineTransform lineStartAngle = CGAffineTransformMakeRotation(self.minStartRadian +  (self.maxEndRadian-self.minStartRadian)*self.progress);
    self.lineView.layer.anchorPoint = CGPointMake(0.0f,0.5f);//围绕点
    self.lineView.transform = lineStartAngle;
}

//格式化小数 四舍五入类型
- (CGFloat)doubleByRounding:(CGFloat)doubleV{
    double d = round(doubleV*100000);
    return d/100000;
}

//字符间距调整
- (float)kerningForCharacter:(NSString *)currentCharacter afterCharacter:(NSString *)previousCharacter{
    float totalSize = [[NSString stringWithFormat:@"%@%@", previousCharacter, currentCharacter] sizeWithAttributes:self.textAttributes].width;
    float currentCharacterSize = [currentCharacter sizeWithAttributes:self.textAttributes].width;
    float previousCharacterSize = [previousCharacter sizeWithAttributes:self.textAttributes].width;
    
    return (currentCharacterSize + previousCharacterSize) - totalSize;
}

#pragma mark - Action
//加速动作, up为YES加速，反之减速
- (void)speedUpAction:(BOOL)up{
    if (up) {
        self.speed = 10;
    }else{
        self.speed = -3;
    }
    
    if (!self.isRunning){
        self.isRunning = YES;
        [self startAnimation:up];
    }
}

- (void)sensitivityAction:(NSTimeInterval)duration{
    _duration = duration;
}

- (void)startAnimation:(BOOL)up{
    if (self.isRunning) {
        NSUInteger minStartAngle = [LOMeterView angleForRadians:_minStartRadian];
        NSUInteger maxEndAngle = [LOMeterView angleForRadians:_maxEndRadian];
        
        NSInteger curAngle = self.lineAngle%360;
        if (self.speed>0) {
            //达到最大值
            if (self.lineAngle>360 && curAngle>=maxEndAngle%360) {
                self.lineAngle = maxEndAngle;
                self.isRunning = NO;
            }
        }else{
            //达到最小值
            if (self.lineAngle<180 && curAngle<=minStartAngle%360) {
                self.lineAngle = minStartAngle;
                self.isRunning = NO;
            }
        }
        
        CGAffineTransform endRadian = CGAffineTransformMakeRotation(self.lineAngle * (M_PI / 180.0f));
        
        [UIView animateWithDuration:self.duration animations:^{
            self.lineView.transform = endRadian;
            //回调当前仪表百分比
            CGFloat progress = (CGFloat)(self.lineAngle - minStartAngle) / (maxEndAngle - minStartAngle);
            if (self.progressBlock)
                self.progressBlock(progress);
        } completion:^(BOOL finished) {
            if (self.isRunning){
                self.lineAngle = self.lineAngle + self.speed;
                [self startAnimation:up];
            }
        }];
    }
}

//暂停
- (void)pause{
    self.isRunning = NO;
}

#pragma mark - 弧度与角度的转换
+ (float)angleForRadians:(CGFloat)radians{
    return radians * (180.0 / M_PI);
}

+ (float)radiansForAngle:(CGFloat)angle{
    return angle / 180.0 * M_PI;
}
@end
