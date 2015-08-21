//
//  ViewController.m
//  ImageScanDemo
//
//  Created by huyang on 15/8/21.
//  Copyright (c) 2015年 huyang. All rights reserved.
//

#import "ViewController.h"

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
}

@end
