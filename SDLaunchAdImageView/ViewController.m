//
//  ViewController.m
//  SDLaunchAdImageView
//
//  Created by 宋东昊 on 2016/12/30.
//  Copyright © 2016年 songdh. All rights reserved.
//

#import "ViewController.h"
#import "SDLaunchImageTool.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //此处像服务器请求广告信息的接口。请求成功后，将结果中的图片地址和跳转地址当做参数，调用saveAdInfo接口
    //以下图片地址为测试数据
    
    //测试数据
    NSArray *imageArray = @[@"http://imgsrc.baidu.com/forum/pic/item/9213b07eca80653846dc8fab97dda144ad348257.jpg",
                            @"http://img002.21cnimg.com/photos/album/20160326/m600/B920004B5414AE4C7D6F2BAB2966491E.jpeg",
                            @"http://c.hiphotos.baidu.com/lvpics/h=800/sign=f08ecc016c63f624035d3403b745eb32/a2cc7cd98d1001e93b905337bf0e7bec54e7975d.jpg"];
    NSString *imageUrl = imageArray[arc4random() % imageArray.count];
    NSDictionary *dic = @{SDAdImageUrl:imageUrl,SDAdDestUrl:@"aa"};
    
    [SDLaunchImageTool saveAdInfo:dic];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
