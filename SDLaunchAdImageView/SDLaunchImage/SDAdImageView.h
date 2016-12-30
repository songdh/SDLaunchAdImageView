//
//  SDAdImageView.h
//  SDLaunchImage
//
//  Created by 宋东昊 on 2016/12/27.
//  Copyright © 2016年 songdh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDLaunchImageTool.h"


@interface SDAdImageView : UIImageView
@property (nonatomic, assign) CGFloat aspectRadio;//广告图片的宽高比
@property (nonatomic, assign) NSInteger delaySeconds;//广告展示的时间 s
@property (nonatomic, copy  ) void (^tapActionBlock)(SDAdImageView *adImageView ,NSString *destUrl);

-(void)show;
-(void)dismiss;
@end
