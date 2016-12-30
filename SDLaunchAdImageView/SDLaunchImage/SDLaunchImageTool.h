//
//  SDLaunchImageTool.h
//  SDLaunchImage
//
//  Created by 宋东昊 on 2016/12/27.
//  Copyright © 2016年 songdh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

FOUNDATION_EXTERN NSString *const SDAdImageUrl;
FOUNDATION_EXTERN NSString *const SDAdDestUrl;

@interface SDLaunchImageTool : NSObject
/**
 * 约定所有信息都保存到系统Documents目录下
 * 其中：
 *      广告信息根目录为：launchAdImage
 *      广告图片名称为：图片的url中经过解析后的文件名
 *      广告信息文件为：adInfo：image_url:图片名称
 *                           dest_url:广告跳转路径
 */


/**
 * 保存广告信息
 * adInfo:  image_url:广告图片地址，若为空 则删除本地已有图片
 *          dest_url:广告跳转地址
 * 此方法在子先撑中执行，并且会默认延迟三秒执行。这样可确保读取上一张图片时，图片被删除，导致读取失败的问题
*/
+(void)saveAdInfo:(NSDictionary*)adInfo;

/**
 * 广告图片是否存在
 */
+(BOOL)isAdImageExist;

/**
 * 广告图片路径
 */
+(NSString*)adImagePath;

/**
 * 广告跳转信息
 */
+(NSString*)adDestPath;
@end
