//
//  ImageModel.h
//  ImageScanDemo
//
//  Created by huyang on 15/8/21.
//  Copyright (c) 2015年 huyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageModel : NSObject

@property (assign , nonatomic) NSInteger index ;        //索引

@property (copy   , nonatomic) NSString  *topTitle ;    //顶部标题

@property (copy   , nonatomic) NSString  *bottomTitle ; //底部标题

@property (copy   , nonatomic) NSString  *bottomDesc ;  //底部图片的描述

@property (strong , nonatomic) id        image ;        //UIImage实例或者图片的链接

@end
