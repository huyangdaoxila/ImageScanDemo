//
//  ImageScanViewController.m
//  ImageScanDemo
//
//  Created by huyang on 15/8/21.
//  Copyright (c) 2015年 huyang. All rights reserved.
//

#import "ImageScanViewController.h"
#import "SingleImageScanViewController.h"

@interface ImageScanViewController ()<UIPageViewControllerDelegate,
                                      UIPageViewControllerDataSource>

@property (strong , nonatomic) NSArray *pageContent ;

@end

@implementation ImageScanViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIApplication sharedApplication].statusBarHidden = YES ;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [UIApplication sharedApplication].statusBarHidden = NO ;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    
    [self createFakePageContent];
    
    self.delegate = self ;
    self.dataSource = self ;
    self.view.backgroundColor = [UIColor blackColor];
    SingleImageScanViewController *currentVC = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = @[currentVC];
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- 创建假的数据源

- (void)createFakePageContent
{
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < 6 ; i++) {
        NSString *imageName = [NSString stringWithFormat:@"0%d.JPG",i+1];
        UIImage *img = [UIImage imageNamed:imageName];
        [imageArray addObject:img];
    }
    self.pageContent = [[NSArray alloc] initWithArray:imageArray];
}

#pragma mark --- 获取当前的viewController

- (SingleImageScanViewController *)viewControllerAtIndex:(NSInteger)index
{
    if (self.pageContent.count == 0 || index >= self.pageContent.count) {
        return nil ;
    }
    
    SingleImageScanViewController *singleVC = [[SingleImageScanViewController alloc] init];
    singleVC.displayImage = self.pageContent[index] ;
    return singleVC ;
}

// 根据数组元素值，得到下标值
- (NSUInteger)indexOfViewController:(SingleImageScanViewController *)viewController
{
    return [self.pageContent indexOfObject:viewController.displayImage];
}

#pragma mark --- UIPageViewControllerDataSource

// 返回上一个viewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [self indexOfViewController:(SingleImageScanViewController *)viewController];
    
    if (index == 0 || index == NSNotFound) {
        return nil ;
    }
    index -- ;
    // 返回的ViewController，将被添加到相应的UIPageViewController对象上。
    // UIPageViewController对象会根据UIPageViewControllerDataSource协议方法，自动来维护次序。
    // 不用我们去操心每个ViewController的顺序问题。
    return [self viewControllerAtIndex:index];
}

// 返回下一个viewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [self indexOfViewController:(SingleImageScanViewController *)viewController];
    if (index == NSNotFound) {
        return nil ;
    }
    index ++ ;
    if (index == self.pageContent.count) {
        return nil ;
    }
    return [self viewControllerAtIndex:index];
}

@end






















