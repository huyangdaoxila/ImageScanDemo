//
//  ImageTopView.h
//  ImageScanDemo
//
//  Created by huyang on 15/8/21.
//  Copyright (c) 2015年 huyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageTopView : UIView

/* 页面指示计 */
@property (nonatomic, strong) UILabel *pageIndicatorLabel;
/* 标题 */
@property (nonatomic, strong) UILabel *titleLable;
/* 当前页 */
@property (nonatomic, assign) NSInteger currentPage;

/**
 *  显示topView
 */
- (void)showAnimation:(BOOL)animation ;

/**
 *  隐藏topView
 */
- (void)hiddenAnimation:(BOOL)animation ;

@end
