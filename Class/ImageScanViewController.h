//
//  ImageScanViewController.h
//  ImageScanDemo
//
//  Created by huyang on 15/8/21.
//  Copyright (c) 2015年 huyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageModel.h"
#import "ImageBottomView.h"
#import "ImageTopView.h"

@interface ImageScanViewController : UIPageViewController

@property (strong , nonatomic) NSArray   *imageDatasource ; //图片数据源

@property (assign , nonatomic) NSInteger firstIndex ;       //当前的viewController对应的索引

@property (assign , nonatomic) BOOL      showTopView ;      //是否显示顶部额外添加的视图

@property (assign , nonatomic) BOOL      showBottomView ;   //是否显示底部额外添加的视图

@property (assign , nonatomic) CGFloat   topHeight;         //默认值 top 64.f

@property (assign , nonatomic) CGFloat   bottomHeight;      //默认值 bottom 118.f

@property (strong , nonatomic) UIColor *topViewBackgroundColor;     //topView背景色

@property (strong , nonatomic) UIColor *bottomViewBackgroundColor;  //bottomView背景色

/**
 *  可根据自己的需求修改topView
 */
- (void)topViewSetting:(void(^)(ImageTopView *topView))setting;

/**
 *  可根据自己的需求修改bottomView
 */
- (void)bottomViewSetting:(void(^)(ImageBottomView *bottomView))setting;

@end
