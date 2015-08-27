//
//  SingleImageScanViewController.m
//  ImageScanDemo
//
//  Created by huyang on 15/8/21.
//  Copyright (c) 2015年 huyang. All rights reserved.
//

#import "SingleImageScanViewController.h"
#import "UCZProgressView.h"

#define KFullWidth  [UIScreen mainScreen].bounds.size.width
#define KFullHeight [UIScreen mainScreen].bounds.size.height
@interface SingleImageScanViewController ()<VIPhotoViewDelegate>

{
    UIActivityIndicatorView *activity ;
}

@property (strong , nonatomic) UCZProgressView *progressView ;
@property (strong , nonatomic) UIImageView *imageView ;

@end

@implementation SingleImageScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    
    __weak typeof(self) weakself = self;
    __weak ImageModel *tmpModel = _model;
    self.photoView = [[VIPhotoView alloc] initWithFrame:self.view.frame withDelegate:self withGestureBlock:^(UITapGestureRecognizer *gesture) {
        if (weakself.singleTapDelegate && [weakself.singleTapDelegate respondsToSelector:@selector(didSingleTapAtIndex:)]) {
            [weakself.singleTapDelegate didSingleTapAtIndex:tmpModel.index];
        }
    }];
    [self.view addSubview:_photoView];
    [_photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.photoView setImage:_model.image];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- public method

- (void)resetModel:(ImageModel *)model
{
    self.model = model;
    [self.photoView setImage:_model.image];
}

#pragma mark - Progress

- (void)addProgressView
{
    if (!self.progressView) {
        self.progressView = [[UCZProgressView alloc] initWithFrame:CGRectZero];
        _progressView.showsText = YES;
        _progressView.tintColor = [UIColor whiteColor];
        _progressView.textColor = [UIColor whiteColor];
        _progressView.backgroundView.backgroundColor = [UIColor clearColor];
        _progressView.indeterminate = NO;
        _progressView.finishAnimation = NO;
        [self.view addSubview:_progressView];
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.centerY.equalTo(self.view.mas_centerY);
            make.width.equalTo(@80);
            make.height.equalTo(@80);
        }];
    }
    
    if (!activity) {
        activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.view addSubview:activity];
        [activity mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        [activity startAnimating];
    }
}


#pragma mark - VIPhotoView Delegate


- (void)vIImageLoadingStart
{
    [self addProgressView];
}

- (void)vIImageLoadingWithProgress:(double)progress
{
    if (activity) {
        [activity  stopAnimating];
        if (activity.superview) {
            [activity removeFromSuperview];
        }
        activity = nil;
    }
    [_progressView setProgress:progress animated:YES];
}

- (void)vIImageLoadingEndSuccess:(BOOL)success
{
    if (activity) {
        [activity  stopAnimating];
        if (activity.superview) {
            [activity removeFromSuperview];
        }
        activity = nil;
    }
    [_progressView setProgress:1 animated:NO];
    [_progressView removeFromSuperview];
    _progressView = nil;
}


//- (void)tapOneAction:(UITapGestureRecognizer *)tapOne
//{
//    if (self.singleTapDelegate && [self.singleTapDelegate respondsToSelector:@selector(didSingleTapAtIndex:)]) {
//        [self.singleTapDelegate didSingleTapAtIndex:_model.index];
//    }
//}

@end
