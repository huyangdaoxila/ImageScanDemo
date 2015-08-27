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
                                      UIPageViewControllerDataSource,
                                      SingleImageScanViewControllerDelegate>

{
    BOOL additionViewHidden;
}

@property (assign , nonatomic) NSInteger       currentPage ;
@property (strong , nonatomic) ImageTopView    *topView ;
@property (strong , nonatomic) ImageBottomView *bottomView ;
@property (strong , nonatomic) ImageModel      *imageModel;

@end

@implementation ImageScanViewController

#pragma mark --- 初始化,以及一些默认值的设定

- (instancetype)initWithTransitionStyle:(UIPageViewControllerTransitionStyle)style navigationOrientation:(UIPageViewControllerNavigationOrientation)navigationOrientation options:(NSDictionary *)options
{
    self = [super initWithTransitionStyle:style navigationOrientation:navigationOrientation options:options];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData
{
    self.delegate = self;
    self.dataSource = self;
    self.showTopView = YES ;
    self.topHeight = 64.f;
    self.bottomHeight = 118.f;
    _currentPage = -1;
    self.topViewBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.bottomViewBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
}


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
    self.view.backgroundColor = [UIColor blackColor];
    [self addTopView:_showTopView];
    [self addBottomView:_showBottomView];
    
    self.currentPage = _firstIndex ;
    self.delegate = self ;
    self.dataSource = self ;
    self.view.backgroundColor = [UIColor blackColor];
    SingleImageScanViewController *currentVC = [self viewControllerAtIndex:_firstIndex];
    _imageModel = self.imageDatasource[_firstIndex];
    [self setBottomViewTextWithModel:_imageModel];
    NSArray *viewControllers = @[currentVC];
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --- 获取当前的viewController

- (SingleImageScanViewController *)viewControllerAtIndex:(NSInteger)index
{
    if (self.imageDatasource.count == 0 || index >= self.imageDatasource.count) {
        return nil ;
    }
    
    SingleImageScanViewController *singleVC = [[SingleImageScanViewController alloc] init];
    singleVC.model = self.imageDatasource[index];
    singleVC.singleTapDelegate = self ;
    return singleVC ;
}

// 根据数组元素值，得到下标值
- (NSUInteger)indexOfViewController:(SingleImageScanViewController *)viewController
{
    NSUInteger index = [self.imageDatasource indexOfObject:viewController.model];
    NSInteger count = self.imageDatasource.count ;
    if (index == 0) {
        
        [self setTopViewPageIndicatorLabelWithCurrentIndex:1 andImageDatasourceCount:count];

    }else if (index == self.imageDatasource.count - 1){
        
        [self setTopViewPageIndicatorLabelWithCurrentIndex:count andImageDatasourceCount:count];

    }else{
        
        [self setTopViewPageIndicatorLabelWithCurrentIndex:index+1 andImageDatasourceCount:count];

    }
    
    [self setBottomViewTextWithModel:viewController.model];
    
    return index;
}

- (void)setTopViewPageIndicatorLabelWithCurrentIndex:(NSInteger)currentIndex andImageDatasourceCount:(NSInteger)count
{
    NSString *c_index_str = [NSString stringWithFormat:@"%ld",currentIndex] ;
    NSString *total_count_str = [NSString stringWithFormat:@"/%ld",count] ;
    
    UIFont *index_font = [UIFont systemFontOfSize:18.f];
    UIFont *total_font = [UIFont systemFontOfSize:14.f];
    
    UIColor *white = [UIColor whiteColor];
    
    NSAttributedString *currentIndexStr = [[NSAttributedString alloc] initWithString:c_index_str attributes:@{NSFontAttributeName:index_font,NSForegroundColorAttributeName:white}];
    
    NSAttributedString *totalCountStr = [[NSAttributedString alloc] initWithString:total_count_str attributes:@{NSFontAttributeName:total_font,NSForegroundColorAttributeName:white}];
    
    NSMutableAttributedString *finalAttrStr = [[NSMutableAttributedString alloc] init];
    [finalAttrStr appendAttributedString:currentIndexStr];
    [finalAttrStr appendAttributedString:totalCountStr];
    
    self.topView.pageIndicatorLabel.attributedText = finalAttrStr;
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
    if (index == self.imageDatasource.count) {
        return nil ;
    }
    
    return [self viewControllerAtIndex:index];
}


#pragma mark --- 添加 topView 和 bottomView

- (void)addTopView:(BOOL)showOrNot
{
    if (showOrNot == YES) {
        if (!self.topView) {
            self.topView = [[ImageTopView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), self.topHeight)];
            self.topView.backgroundColor = self.topViewBackgroundColor;
            
            NSInteger currentIndex = self.firstIndex + 1 ;
            NSInteger totalCount = self.imageDatasource.count ;
            [self setTopViewPageIndicatorLabelWithCurrentIndex:currentIndex andImageDatasourceCount:totalCount];
            
            UIButton *quitButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [quitButton setBackgroundColor:[UIColor clearColor]];
            [quitButton setImage:[UIImage imageNamed:@"white_quit"] forState:UIControlStateNormal];
            [quitButton addTarget:self action:@selector(quitAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.topView addSubview:quitButton];
            [quitButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.topView.mas_centerY);
                make.height.equalTo(@40);
                make.right.equalTo(self.topView.mas_right).offset(-10);
                make.width.equalTo(@40);
            }];
            [self.view addSubview:_topView];
        }
    }
}

- (void)addBottomView:(BOOL)showOrNot
{
    if (showOrNot == YES) {
        if (!self.bottomView) {
            self.bottomView = [[ImageBottomView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - self.bottomHeight, CGRectGetWidth(self.view.bounds), self.bottomHeight)];
            self.bottomView.backgroundColor = self.bottomViewBackgroundColor;
            [self.view addSubview:_bottomView];
        }
    }
}

#pragma mark - Public<根据自己的需求自定义topView和bottomView>


- (void)topViewSetting:(void(^)(ImageTopView *topView))setting
{
    if (setting) {
        setting(_topView);
    }
}

- (void)bottomViewSetting:(void(^)(ImageBottomView *bottomView))setting
{
    if (setting) {
        setting(_bottomView);
    }
}

- (void)didSingleTapAtIndex:(NSInteger)index
{
    if (additionViewHidden == YES) {
        [self topAndBottomShow:YES];
    }else{
        [self topAndBottomHidden:YES];
    }
}


- (void)topAndBottomShow:(BOOL)animation
{
    additionViewHidden = NO;
    [_topView showAnimation:animation];
    [_bottomView showAnimation:animation];
}

- (void)topAndBottomHidden:(BOOL)animation
{
    additionViewHidden = YES;
    [_topView hiddenAnimation:animation];
    [_bottomView hiddenAnimation:animation];
}

- (void)setBottomViewTextWithModel:(ImageModel *)model
{
    _imageModel = model ;
    
    if (_showBottomView == YES) {
        self.bottomView.titleLabel.text = _imageModel.bottomTitle ;
        self.bottomView.descView.text = _imageModel.bottomDesc ;
    }
}

- (void)quitAction:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end






















