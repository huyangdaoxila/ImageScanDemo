//
//  ImageBottomView.m
//  ImageScanDemo
//
//  Created by huyang on 15/8/21.
//  Copyright (c) 2015年 huyang. All rights reserved.
//

#import "ImageBottomView.h"

@interface ImageBottomView ()

//{
//    UITextView *_customTextView;
//    BOOL _show;
//    BOOL _shouldAnimation;
//    BOOL _isRotating;
//    UIInterfaceOrientation _orientation;
//}

@end

@implementation ImageBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        _numberOfLines = 4;
    }
    return self;
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    if (_isRotating) {
//        _isRotating = NO;
//        CGPoint point = _customTextView.contentOffset;
//        point.y = 0;
//        _customTextView.contentOffset = point;
//    }
//}


#pragma mark - Setter And Getter

- (void)setNumberOfLines:(CGFloat)numberOfLines
{
    if (_numberOfLines == numberOfLines) {
        return;
    }
    _numberOfLines = numberOfLines;
}

#pragma mark - Show And Hidden

- (void)showAnimation:(BOOL)animation
{
    self.hidden = NO;
    if (animation) {
        [UIView animateWithDuration:0.15 animations:^{
            CGRect rect = self.frame;
            rect.origin.y = CGRectGetHeight(self.superview.bounds) - CGRectGetHeight(rect);
            self.frame = rect;
        }];
    }
    else {
        CGRect rect = self.frame;
        rect.origin.y = CGRectGetHeight(self.superview.bounds) - CGRectGetHeight(rect);
        self.frame = rect;
    }
}


- (void)hiddenAnimation:(BOOL)animation
{
    if (animation) {
        [UIView animateWithDuration:0.15 animations:^{
            CGRect rect = self.frame;
            rect.origin.y = CGRectGetHeight(self.superview.bounds) + CGRectGetHeight(rect);
            self.frame = rect;
        } completion:^(BOOL finished) {
            self.hidden = YES;
        }];
    }
    else {
        CGRect rect = self.frame;
        rect.origin.y = CGRectGetHeight(self.superview.bounds) + CGRectGetHeight(rect);
        self.frame = rect;
        self.hidden = YES;
    }
    
}

//- (void)orientationChanged:(NSNotification *)notification
//{
//    _isRotating = YES;
//}


- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:16.f];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
        [self prepareUpdateConstraints];
    }
    return _titleLabel;
}


- (UITextView *)descView
{
    if (!_descView) {
        _descView = [[UITextView alloc] initWithFrame:CGRectZero];
        _descView.textColor = [UIColor whiteColor];
        _descView.font = [UIFont systemFontOfSize:11];
        _descView.editable = NO;
        _descView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _descView.backgroundColor = [UIColor clearColor];
        [self addSubview:_descView];
        [self prepareUpdateConstraints];
    }
    return _descView;
}


- (void)prepareUpdateConstraints
{
    if (_titleLabel) {
        [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left).offset(15);
            make.right.equalTo(self.mas_right).offset(-15);
            make.height.equalTo(@20);
        }];
    }
    if (_descView) {
        [_descView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(12);
            make.right.equalTo(self.mas_right).offset(-12);
            make.height.equalTo(@(_numberOfLines * 16));
            make.bottom.equalTo(self.mas_bottom).offset(-15);
        }];
    }
    
}

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
