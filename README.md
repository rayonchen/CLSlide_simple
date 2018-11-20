# CLSlidePageView_Simple
网易、凤凰、今日头条等导航栏仿写简单版

最近做了一个新项目，里面有很多：头部几个按钮，下面几个可左右滑动的tableView，每个cell的样式一样，因此做了一个封装，可快速集成这种需求的页面
由于拆出来有点小麻烦且需要URL数据才能显示效果，就先弄了这个
可在滑动的scrollView上添加View

### 使用
下载demo，将`滑动页_简单版`文件添加到自己工程中
具体使用
```
CLSlidePage_simple *slideView = [[CLSlidePage_simple alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 500) titles:@[@"测试1", @"测试22222", @"测试333", @"测试444", @"测试55", @"测试6666"] block:^(CLSlidePage_simple *slideView) {

        // 可以对样式进行设定，否则使用默认值
//        slideView.titleColor =
//        slideView.titleSeteColor =
        
    }];
    [self.view addSubview:slideView];
    
    // 添加View测试
    // view.x值对View的frame无影响，根据添加方法中的index决定
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 300)];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 300)];
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 300)];

    view1.backgroundColor = [UIColor redColor];
    view2.backgroundColor = [UIColor cyanColor];
    view3.backgroundColor = [UIColor greenColor];

    [slideView addSubviewToSlideView:view1 index:0];
    [slideView addSubviewToSlideView:view2 index:2];
    [slideView addSubviewToSlideView:view3 index:4];

```

##### PS:简单几步集成`简易新闻App`的代码马上推出
