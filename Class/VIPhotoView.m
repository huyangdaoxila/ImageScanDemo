//
//  VIPhotoView.m
//  VIPhotoViewDemo
//
//  Created by Vito on 1/7/15.
//  Copyright (c) 2015 vito. All rights reserved.
//

#import "VIPhotoView.h"
#import <SDWebImage/SDWebImageManager.h>
//#import "UIImageView+SDWebExtension.h"
#define MAS_SHORTHAND_GLOBALS
#import <Masonry.h>

#define MAXZoomScale 2

@interface UIImage (VIUtil)

- (CGSize)sizeThatFits:(CGSize)size;

@end

@implementation UIImage (VIUtil)

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize imageSize = CGSizeMake(self.size.width / self.scale,
                                  self.size.height / self.scale);
    
    CGFloat widthRatio = imageSize.width / size.width;
    CGFloat heightRatio = imageSize.height / size.height;
    
    if (widthRatio > heightRatio) {
        imageSize = CGSizeMake(size.width, imageSize.height / widthRatio);
    } else {
        imageSize = CGSizeMake(size.height, imageSize.height / heightRatio);
    }
    
    return imageSize;
}

@end

@interface UIImageView (VIUtil)

- (CGSize)contentSize;

@end

@implementation UIImageView (VIUtil)

- (CGSize)contentSize
{
    return [self.image sizeThatFits:self.bounds.size];
}

@end

@interface VIPhotoView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic) CGSize minSize;

@property (nonatomic, copy) void(^gestureOperation)(UITapGestureRecognizer *gesture);

@end

@implementation VIPhotoView


- (instancetype)initWithFrame:(CGRect)frame withDelegate:(id)delegate withGestureBlock:(void (^)(UITapGestureRecognizer *gesture))block
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.bouncesZoom = NO;
        self.backgroundColor = [UIColor blackColor];
        
        
        // Add container view
        self.canZoomScaleWhenPortrait = YES;
        self.rotating = YES;
        self.gestureOperation = block;
        
        UIView *containerView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:containerView];
        
        _containerView = containerView;
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:_containerView.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_containerView addSubview:imageView];
        
        _imageView = imageView;
        
        if (delegate) {
            self.vipDelegate = delegate;
        }
        
        [self setupGestureRecognizer];
        // Setup other events
        [self setupRotationNotification];
        
    }
    return self;
}


- (void)setImage:(id)image
{
    [self dealImage:image];
}

- (void)dealImage:(id)image
{
    
    if (self.vipDelegate && [self.vipDelegate respondsToSelector:@selector(vIImageLoadingStart)]) {
        [self.vipDelegate vIImageLoadingStart];
    }
    
    if ([image isKindOfClass:[NSString class]]) {
        // Add image view
        if ([image hasPrefix:@"http"]) {
            NSURL *URL = [NSURL URLWithString:image];
            [self downloadImageWithURL:URL];
        }
        else {
            UIImage *im = [UIImage imageWithContentsOfFile:image];
            NSData *data = [NSData dataWithContentsOfFile:image];
            CGFloat timeDelay = 0;
            if (data.length > 512 * 1024) {
                timeDelay = 0.3;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (im) {
                    [self addImageView:im success:YES];
                }
                else {
                    [self addImageView:im success:NO];
                }
            });
        }
    }
    else if ([image isKindOfClass:[UIImage class]]) {
        [self addImageView:image success:YES];
    }
    else {
        [self addImageView:nil success:NO];
    }
}

- (void)downloadImageWithURL:(NSURL *)url
{
    __weak typeof(self) weakself = self;
    [_imageView sd_setImageWithURL:url placeholderImage:nil options:_option progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if (expectedSize > 0) {
            double progress = (double)receivedSize/(double)expectedSize;
            if (weakself.vipDelegate && [weakself.vipDelegate respondsToSelector:@selector(vIImageLoadingWithProgress:)]) {
                [weakself.vipDelegate vIImageLoadingWithProgress:progress];
            }
        }
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image && !error) {
            [weakself addImageView:image success:YES];
        }
        else {
            [weakself addImageView:nil success:NO];
        }
    }];
    
}

- (void)addImageView:(UIImage *)image success:(BOOL)yesOrNo
{
    
    if (!image) {
        image = [UIImage imageNamed:@"library.bundle/placeholder"];
    }
    [self addImage:image success:yesOrNo];
    
}


- (void)addImage:(UIImage *)image success:(BOOL)yesOrNo
{
    // Add image view
    if (self.vipDelegate && [self.vipDelegate respondsToSelector:@selector(vIImageLoadingEndSuccess:)]) {
        [self.vipDelegate vIImageLoadingEndSuccess:yesOrNo];
    }
    
    _imageView.image = image;
    
    self.rotating = YES;
    
    [self calculateSize];
    [self setMaxMinZoomScale];
    [self centerContent];
    
}

- (void)calculateSize
{
    // Fit container view's size to image size
    if (_imageView.image) {
        
        
        CGSize size = _imageView.image.size;
        CGFloat scale = size.width/size.height;
        CGFloat width = self.bounds.size.width;
        CGFloat height = self.bounds.size.height;
        
        CGFloat widthScale = size.width/width;
        CGFloat heightScale = size.height/height;
        if (widthScale > heightScale) {
            self.containerView.frame = CGRectMake(0, 0, width, width / scale);
        }
        else {
            self.containerView.frame = CGRectMake(0, 0, height * scale, height);
            
        }
        
        
        
        
        width = CGRectGetWidth(_containerView.bounds);
        height = CGRectGetHeight(_containerView.bounds);
        
        self.contentSize = CGSizeMake(width, height);
    }
    
    // Center containerView by set insets
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.rotating) {
        self.rotating = NO;
        [self calculateSize];
    }
    [self centerContent];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    NSLog(@"%s",__FUNCTION__);
}

#pragma mark - Setup

- (void)setupRotationNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}

- (void)setupGestureRecognizer
{
    
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandle:)];
    
    [self addGestureRecognizer:tapG];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tapGestureRecognizer.numberOfTapsRequired = 2;
    [self addGestureRecognizer:tapGestureRecognizer];
    
    [tapG requireGestureRecognizerToFail:tapGestureRecognizer];
}


- (void)resetZoomScaleToDefault
{
    if (self.zoomScale != 1) {
        [self setZoomScale:1];
    }
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.containerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self centerContent];
}

#pragma mark - GestureRecognizer

- (void)tapHandler:(UITapGestureRecognizer *)recognizer
{
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    if (!_canZoomScaleWhenPortrait && screenW < screenH ) {
        return;
    }
    if (self.zoomScale > self.minimumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    } else if (self.zoomScale < self.maximumZoomScale) {
        CGPoint location = [recognizer locationInView:recognizer.view];
        CGRect zoomToRect = CGRectMake(0, 0, 50, 50);
        zoomToRect.origin = CGPointMake(location.x - CGRectGetWidth(zoomToRect)/2, location.y - CGRectGetHeight(zoomToRect)/2);
        [self zoomToRect:zoomToRect animated:YES];
    }
}

- (void)singleTapHandle:(UITapGestureRecognizer *)recognizer
{
    if (self.gestureOperation) {
        self.gestureOperation(recognizer);
    }
}

#pragma mark - Notification

- (void)orientationChanged:(NSNotification *)notification
{
    self.rotating = YES;
    [self setZoomScale:self.minimumZoomScale animated:NO];
    [self calculateSize];
}


#pragma mark - Helper

- (void)setMaxMinZoomScale
{
    self.maximumZoomScale = 2.0;
    self.minimumZoomScale = 1.0;
}

- (void)centerContent
{
    CGRect frame = self.containerView.frame;
    
    CGFloat top = 0, left = 0;
    if (self.contentSize.width < self.bounds.size.width) {
        left = (self.bounds.size.width - self.contentSize.width) * 0.5f;
    }
    if (self.contentSize.height < self.bounds.size.height) {
        top = (self.bounds.size.height - self.contentSize.height) * 0.5f;
    }
    
    top -= frame.origin.y;
    left -= frame.origin.x;
    
    self.contentInset = UIEdgeInsetsMake(top, left, top, left);
}



@end
