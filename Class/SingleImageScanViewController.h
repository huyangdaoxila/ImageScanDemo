//
//  SingleImageScanViewController.h
//  ImageScanDemo
//
//  Created by huyang on 15/8/21.
//  Copyright (c) 2015年 huyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageModel.h"

@protocol SingleImageScanViewControllerDelegate <NSObject>

@optional

- (void)didSingleTapAtIndex:(NSInteger)index;

@end

@interface SingleImageScanViewController : UIViewController

@property (strong , nonatomic) ImageModel *model ;

@property (weak   , nonatomic) id<SingleImageScanViewControllerDelegate>singleTapDelegate ;

@end
