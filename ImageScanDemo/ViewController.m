//
//  ViewController.m
//  ImageScanDemo
//
//  Created by huyang on 15/8/21.
//  Copyright (c) 2015年 huyang. All rights reserved.
//

#import "ViewController.h"
#import "ImageScanViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *imageScanButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"图片浏览";
    
    _imageScanButton.layer.masksToBounds = YES ;
    _imageScanButton.layer.cornerRadius = 5.f ;
    [_imageScanButton setBackgroundColor:[UIColor greenColor]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)imageScanAction:(id)sender
{
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < 6 ; i++) {
        NSString *imageName = [NSString stringWithFormat:@"0%d.JPG",i+1];
        UIImage *img = [UIImage imageNamed:imageName];
        
        ImageModel *model = [[ImageModel alloc] init];
        model.image = img ;
        model.index = i ;
        model.bottomDesc = [NSString stringWithFormat:@"这是第%d张图片",i+1];
        [imageArray addObject:model];
    }
    
    ImageScanViewController *imageScanVC = [[ImageScanViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey: @30}];
    imageScanVC.showBottomView = YES ;
//    imageScanVC.showTopView = YES ;
    imageScanVC.firstIndex = 0 ;
    imageScanVC.imageDatasource = [[NSArray alloc] initWithArray:imageArray];
    [self presentViewController:imageScanVC animated:YES completion:nil];
}

@end
