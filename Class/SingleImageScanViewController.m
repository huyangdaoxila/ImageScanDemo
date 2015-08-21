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

    
    _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _imageView.image = _displayImage ;
    [self.view addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
