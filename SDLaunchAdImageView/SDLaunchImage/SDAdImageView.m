//
//  SDAdImageView.m
//  SDLaunchImage
//
//  Created by 宋东昊 on 2016/12/27.
//  Copyright © 2016年 songdh. All rights reserved.
//

#import "SDAdImageView.h"

#define SDScreenBounds [UIScreen mainScreen].bounds

@interface SDAdImageView ()
@property (nonatomic, strong) UIImageView *adImageView;
@property (nonatomic, strong) UIButton *skipButton;
@property (nonatomic, strong) NSTimer *skipTimer;
@end


@implementation SDAdImageView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _aspectRadio = 750.0/1134.0;
        _delaySeconds = 3.0f;
        
        self.image = [self placeholderImage];
        self.userInteractionEnabled = YES;
        
        //创建广告图片
        _adImageView = [[UIImageView alloc]init];
        _adImageView.userInteractionEnabled = YES;
        [self addSubview:_adImageView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onGesture:)];
        [_adImageView addGestureRecognizer:tapGesture];
        
        
        //创建跳过按钮
        _skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _skipButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _skipButton.layer.cornerRadius = 4;
        _skipButton.backgroundColor = [UIColor colorWithRed:38 /255.0 green:38 /255.0 blue:38 /255.0 alpha:0.6];
        [_skipButton addTarget:self action:@selector(onSkip:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_skipButton];
    }
    return self;
}


/**
 * 获取系统设置的启动图片。作为背景使用
 *
 */
-(NSString*)placeholderName
{
    NSString *imageName = nil;
    NSString *orientation = @"Portrait";//横屏 @"Landscape"
    NSArray* launchImages = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    
    for (NSDictionary* launchImage in launchImages){
        CGSize imageSize = CGSizeFromString(launchImage[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, SDScreenBounds.size) &&
            [orientation isEqualToString:launchImage[@"UILaunchImageOrientation"]]){
            
            imageName = launchImage[@"UILaunchImageName"];
            return imageName;
        }
    }
    return nil;
}

-(UIImage*)placeholderImage
{
    NSString *placeholderName = [self placeholderName];
    NSString *path = [[NSBundle mainBundle] pathForResource:placeholderName ofType:@"png"];
    if (!path) {
        //当获取到的图片名称不能取到图片正确路径时，
        //1，在文件名后面加 @2x尝试
        //2,如果仍取不到，则使用@3x尝试。
        placeholderName = [NSString stringWithFormat:@"%@@2x",placeholderName];
        path = [[NSBundle mainBundle] pathForResource:placeholderName ofType:@"png"];
        if (!path) {
            placeholderName = [placeholderName stringByReplacingOccurrencesOfString:@"@2x" withString:@"@3x"];
            path = [[NSBundle mainBundle] pathForResource:placeholderName ofType:@"png"];
        }
    }
    //3,如果仍取不到图片，则使用系统imageName方法获取
    UIImage *logo = [UIImage imageWithContentsOfFile:path];
    if (!logo) {
        logo = [UIImage imageNamed:[self placeholderName]];
    }
    return logo;
}

-(UIImage*)adImage
{
    NSString *path = [SDLaunchImageTool adImagePath];
    return [UIImage imageWithContentsOfFile:path];
}

-(void)show
{
    _adImageView.frame = CGRectMake(0, 0, CGRectGetWidth(SDScreenBounds), CGRectGetWidth(SDScreenBounds)/_aspectRadio);
    _adImageView.image = [self adImage];
    
    
    _skipButton.frame = CGRectMake(CGRectGetWidth(SDScreenBounds)-60-15, 20, 60, 30);

    
    
    _skipTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_skipTimer forMode:NSRunLoopCommonModes];
    [_skipTimer fire];
    
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

-(void)dismiss
{
    [self.skipTimer invalidate];
    self.skipTimer = nil;
    
    [UIView animateWithDuration:0.3f animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

-(void)onGesture:(UITapGestureRecognizer*)tapGesture
{
    if (self.tapActionBlock) {
        self.tapActionBlock(self,[SDLaunchImageTool adDestPath]);
        [self dismiss];
    }
}

-(void)onTimer:(NSTimer*)timer
{
    if (self.delaySeconds <= 0) {
        [self dismiss];
        return;
    }
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *title = [NSString stringWithFormat:@"跳过 %lds",weakSelf.delaySeconds--];
        [_skipButton setTitle:title forState:UIControlStateNormal];
    });
    
}

-(void)onSkip:(UIButton*)button
{
    [self dismiss];
}

@end
