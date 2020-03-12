# LOMeterView
半圆数值标尺、可做战斗力表、汽车速度仪表等

### 演示：
##### （录制视频转gif为了压缩体积，所以看上去模糊且有卡顿）

![在这里插入图片描述](https://github.com/laoou002/LOMeterView/blob/master/boke002.gif)

### 使用方法：
```objc
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
```
