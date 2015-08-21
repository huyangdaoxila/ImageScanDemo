//
//  ImageTopView.m
//  ImageScanDemo
//
//  Created by huyang on 15/8/21.
//  Copyright (c) 2015年 huyang. All rights reserved.
//

#import "ImageTopView.h"

@implementation ImageTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


- (void)showAnimation:(BOOL)animation
{
    self.hidden = NO;
    if (animation) {
        [UIView animateWithDuration:0.15 animations:^{
            CGRect rect = self.frame;
            rect.origin.y = 0;
            self.frame = rect;
        }];
    }
    else {
        CGRect rect = self.frame;
        rect.origin.y = 0;
        self.frame = rect;
    }
    
}


- (void)hiddenAnimation:(BOOL)animation
{
    if (animation) {
        [UIView animateWithDuration:0.15 animations:^{
            CGRect rect = self.frame;
            rect.origin.y = -CGRectGetHeight(self.bounds);
            self.frame = rect;
        } completion:^(BOOL finished) {
            self.hidden = YES;
        }];
        
    }
    else {
        CGRect rect = self.frame;
        rect.origin.y = -CGRectGetHeight(self.bounds);
        self.frame = rect;
        self.hidden = YES;
    }
    
}


- (UILabel *)pageIndicatorLabel
{
    if (!_pageIndicatorLabel) {
        _pageIndicatorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _pageIndicatorLabel.textAlignment = NSTextAlignmentLeft;
        _pageIndicatorLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_pageIndicatorLabel];
        [_pageIndicatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.height.equalTo(@44);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
    return _pageIndicatorLabel;
}

- (UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLable.textAlignment = NSTextAlignmentCenter;
        _titleLable.font = [UIFont boldSystemFontOfSize:14.f];
        _titleLable.textColor = [UIColor whiteColor];
        _titleLable.backgroundColor = [UIColor clearColor];
        [self insertSubview:_titleLable atIndex:0];
        [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.width.equalTo(@(CGRectGetWidth(self.bounds) - 100));
            make.height.equalTo(@((CGRectGetHeight(self.bounds))));
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
    return _titleLable;
}

@end
