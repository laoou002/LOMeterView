# LOMeterView
半圆数值标尺、可做战斗力表、汽车速度仪表等

### 使用方法：
```objc
	//文本数组
    NSUInteger maxNumber = 240;
    NSMutableArray *textArray = [[NSMutableArray alloc] init];
    for (int i=0; i<=maxNumber; i=i+20) {
        [textArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    //半圆仪表相关配置
    self.circleView.textArray = textArray;
    self.circleView.textAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10.0],NSForegroundColorAttributeName:[UIColor redColor]};
    //内容弧度
    self.circleView.radian = [LOMeterView radiansForAngle:240.0];
    //字符间隔
    self.circleView.characterSpacing = 0.85;
    //圆半径
    self.circleView.roundRadius = 90;
    //文本半径
    self.circleView.textRadius = 80;
    //刻度长
    self.circleView.roundLineWidth = 8.0;
    //圆心
    self.circleView.circleCenterPoint = CGPointMake(self.circleView.bounds.size.width/2, self.circleView.bounds.size.height/2+20);
    
    //监听
    [self.circleView setProgressBlock:^(CGFloat progress) {
        NSLog(@"当前数值比率 = %.2f",progress);
    }];
```
