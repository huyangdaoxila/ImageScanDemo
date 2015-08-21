//
//  SingleImageScanViewController.m
//  ImageScanDemo
//
//  Created by huyang on 15/8/21.
//  Copyright (c) 2015年 huyang. All rights reserved.
//

#import "SingleImageScanViewController.h"

@interface SingleImageScanViewController ()

@property (strong , nonatomic) UIImageView *imageView ;

@end

@implementation SingleImageScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    
    _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _imageView.userInteractionEnabled = YES ;
    UITapGestureRecognizer *tapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOneAction:)];
    [_imageView addGestureRecognizer:tapOne];
    
    if ([_model.image isKindOfClass:[NSString class]]) {
        NSURL *url = [NSURL URLWithString:_model.image];
        [_imageView sd_setImageWithURL:url placeholderImage:nil];
    }
    else if ([_model.image isKindOfClass:[UIImage class]]){
        _imageView.image = _model.image ;
    }

    [self.view addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tapOneAction:(UITapGestureRecognizer *)tapOne
{
    if (self.singleTapDelegate && [self.singleTapDelegate respondsToSelector:@selector(didSingleTapAtIndex:)]) {
        [self.singleTapDelegate didSingleTapAtIndex:_model.index];
    }
}

@end
