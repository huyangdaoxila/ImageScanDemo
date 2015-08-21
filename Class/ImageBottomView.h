//
//  ImageBottomView.h
//  ImageScanDemo
//
//  Created by huyang on 15/8/21.
//  Copyright (c) 2015年 huyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageBottomView : UIView

/* 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/* 详细 */
@property (nonatomic, strong) UITextView *descView;
/* 当前页 */
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign) CGFloat numberOfLines;

/**
 *  显示bottomView
 */
- (void)showAnimation:(BOOL)animation ;

/**
 *  隐藏bottomView
 */
- (void)hiddenAnimation:(BOOL)animation ;

@end
