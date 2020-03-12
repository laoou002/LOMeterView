//
//  ViewController.m
//  LOMeterView
//
//  Created by 欧ye on 16/3/17.
//  Copyright © 2016年 老欧. All rights reserved.
//

#import "ViewController.h"
#import "LOMeterView/LOMeterView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet LOMeterView *meterView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *sensitivityButtons;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //文本数组
    NSUInteger maxNumber = 240;
    NSMutableArray *textArray = [[NSMutableArray alloc] init];
    for (int i=0; i<=maxNumber; i=i+20) {
        [textArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    //半圆仪表相关配置
    self.meterView.textArray = textArray;
    self.meterView.textAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10.0],NSForegroundColorAttributeName:[UIColor redColor]};
    //内容弧度
    self.meterView.radian = [LOMeterView radiansForAngle:240.0];
    //字符间隔
    self.meterView.characterSpacing = 0.85;
    //圆半径
    self.meterView.roundRadius = 90;
    //文本半径
    self.meterView.textRadius = 80;
    //刻度长
    self.meterView.roundLineWidth = 8.0;
    //圆心
    self.meterView.circleCenterPoint = CGPointMake(self.meterView.bounds.size.width/2, self.meterView.bounds.size.height/2+20);
    
    //监听
    [self.meterView setProgressBlock:^(CGFloat progress) {
        NSLog(@"当前数值比率 = %.2f",progress);
    }];
    
    //默认选择S级灵敏度
    [self sensitivityAction:nil];
}

//按下按钮，加速
- (IBAction)speedUpAction:(id)sender {
    [self.meterView speedUpAction:YES];
}

//松开按钮,减速
- (IBAction)cancelAction:(id)sender {
    [self.meterView speedUpAction:NO];
}

//点击事件失效，减速
- (IBAction)cancelAction2:(id)sender {
    [self.meterView speedUpAction:NO];
}

//灵敏度跳转
- (IBAction)sensitivityAction:(UIButton *)sender {
    NSTimeInterval duration = 0.05;
    if (sender!=nil) {
        switch (sender.tag) {
            case 0:
                duration = 0.05;
                break;
            case 1:
                duration = 0.1;
                break;
            case 2:
                duration = 0.2;
                break;
                
            default:
                duration = 0.3;
                break;
        }
    }
    
    for (UIButton *btn in self.sensitivityButtons) {
        if (sender==nil) {
            btn.backgroundColor = btn.tag==0?[UIColor lightGrayColor]:[UIColor whiteColor];
        }else{
            btn.backgroundColor = btn==sender?[UIColor lightGrayColor]:[UIColor whiteColor];
        }
    }
    
    [self.meterView sensitivityAction:duration];
}

//暂停
- (IBAction)pauseAction:(UIButton *)sender{
    [self.meterView pause];
}
@end
