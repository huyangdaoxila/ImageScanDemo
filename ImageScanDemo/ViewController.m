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
    [_imageScanButton setBackgroundColor:[UIColor purpleColor]];
    
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
    imageScanVC.firstIndex = 3 ;
    imageScanVC.imageDatasource = [[NSArray alloc] initWithArray:imageArray];
    [self presentViewController:imageScanVC animated:YES completion:nil];
}
- (IBAction)netImageItemClicked:(id)sender
{
    NSArray *imagePaths = @[@"http://iq.dxlfile.com/mall/original/2015-08/20150814152755310.jpg?",
                            @"http://iq.dxlfile.com/mall/original/2015-08/20150814152626509.jpg?",
                            @"http://iq.dxlfile.com/mall/original/2015-08/20150814152613976.jpg?",
                            @"http://iq.dxlfile.com/mall/original/2015-08/20150814152630983.jpg?",
                            @"http://iq.dxlfile.com/mall/original/2015-08/20150814152633247.jpg?",
                            @"http://iq.dxlfile.com/mall/original/2015-08/20150814152665842.jpg?",
                            @"http://iq.dxlfile.com/mall/original/2015-08/20150814152674338.jpg?",
                            @"http://iq.dxlfile.com/mall/original/2015-08/20150814152659103.jpg?",
                            @"http://iq.dxlfile.com/mall/original/2015-08/20150814152690723.jpg?",
                            @"http://iq.dxlfile.com/mall/original/2015-08/20150814152670761.jpg?",
                            @"http://iq.dxlfile.com/mall/original/2015-08/20150814152612330.jpg?",
                            @"http://iq.dxlfile.com/mall/original/2015-08/20150814152686354.jpg?",
                            @"http://iq.dxlfile.com/mall/original/2015-08/20150814152638571.jpg?",
                            @"http://iq.dxlfile.com/mall/original/2015-08/20150814152610863.jpg?",
                            @"http://iq.dxlfile.com/mall/original/2015-08/20150814152630830.jpg?",
                            @"http://iq.dxlfile.com/mall/original/2015-08/20150814152610488.jpg?",
                            @"http://iq.dxlfile.com/mall/original/2015-08/20150814152479479.jpg?",
                            @"http://iq.dxlfile.com/mall/original/2015-08/20150814152441985.jpg?",
                            @"http://iq.dxlfile.com/mall/original/2015-08/20150814152493544.jpg?"];
    
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < imagePaths.count ; i++) {
        
        ImageModel *model = [[ImageModel alloc] init];
        model.image = imagePaths[i] ;
        model.index = i ;
        model.bottomDesc = [NSString stringWithFormat:@"这是第%d张图片",i+1];
        [imageArray addObject:model];
    }
    
    ImageScanViewController *imageScanVC = [[ImageScanViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey: @30}];
    imageScanVC.showBottomView = YES ;
    imageScanVC.firstIndex = 0 ;
    imageScanVC.imageDatasource = [[NSArray alloc] initWithArray:imageArray];
    [self presentViewController:imageScanVC animated:YES completion:nil];
}

@end
