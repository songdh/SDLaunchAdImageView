//
//  SDLaunchImageTool.m
//  SDLaunchImage
//
//  Created by 宋东昊 on 2016/12/27.
//  Copyright © 2016年 songdh. All rights reserved.
//

#import "SDLaunchImageTool.h"

NSString *const SDAdImageUrl = @"image_url";
NSString *const SDAdDestUrl = @"dest_url";

@implementation SDLaunchImageTool

+(NSString*)imageDirPath
{
    NSArray* dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                        NSUserDomainMask,
                                                        YES);
    NSString *documentsPath = [dirs objectAtIndex:0];
    NSString *imageDirPath = [documentsPath stringByAppendingPathComponent:@"launchAdImage"];
    
    //如果目录不存在，则创建目录
    if (NO == [[NSFileManager defaultManager] fileExistsAtPath:imageDirPath]) {
         [[NSFileManager defaultManager] createDirectoryAtPath:imageDirPath
                                         withIntermediateDirectories:YES
                                                          attributes:nil
                                                               error:NULL];
    }
    return imageDirPath;
}

+(BOOL)isAdImageExist
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self adImagePath]];
}

+(NSString*)userInfoPath
{
    return [[self imageDirPath] stringByAppendingPathComponent:@"adInfo"];
}


+(NSString*)adImagePath
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithContentsOfFile:[self userInfoPath]];
    NSString *imagePath = userInfo[SDAdImageUrl];
    
    NSArray *paths = [imagePath componentsSeparatedByString:@"/"];
    
    if (paths.count > 0) {
        NSString *imageName = paths.lastObject;
        
        return [[self imageDirPath] stringByAppendingPathComponent:imageName];
    }
    return nil;

}

+(NSString*)adDestPath
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithContentsOfFile:[self userInfoPath]];
    if (userInfo && userInfo.count > 0) {
        NSString *url = userInfo[SDAdDestUrl];
        if (url && [url isKindOfClass:[NSString class]]) {
            return url;
        }
    }
    return nil;
}

+(void)saveAdInfo:(NSDictionary*)adInfo
{
    __weak __typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [weakSelf saveSuccessed:adInfo];

        });
    });

}

+(void)saveSuccessed:(NSDictionary*)adInfo
{
    NSString *oldImagePath = [self adImagePath];
    
    [adInfo writeToFile:[self userInfoPath] atomically:YES];
    NSString *imageUrl = adInfo[SDAdImageUrl];
    
    /////////
    NSString *newImagePath = [self adImagePath];
    newImagePath = nil;
    //获取到的最新的图片地址为空 或者和旧的图片地址不相同，则删除旧图片
    if ( newImagePath.length <=0 ||
        ![oldImagePath isEqualToString:newImagePath]) {
        if (oldImagePath && oldImagePath.length > 0) {
            [self deleteOldImageWithPath:oldImagePath];
        }
        
    }
    
    if (![self isAdImageExist]) {
        //下载图片
        [self downloadAdImageWithUrl:imageUrl];
    }
}

+(void)deleteOldImageWithPath:(NSString*)imagePath
{
    if (imagePath) {
        [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
    }
}


/**
 *  下载新图片
 */
+(void)downloadAdImageWithUrl:(NSString*)imageUrl
{
    if (!imageUrl || imageUrl.length <= 0) {
        NSLog(@"empty");
        return;
    }
    NSString *imagePath = [self adImagePath];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        if (imageData) {
            if ([imageData writeToFile:imagePath atomically:YES] ) {
                NSLog(@"download adimage successed!imagePath=%@",imagePath);
            }else {
                NSLog(@"download adimage failed!");
            }
        }
        
    });
    
}
@end
