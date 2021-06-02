//
//  CustomImageViewController.m
//  DownsamplingDemo
//
//  Created by Tian on 2021/6/2.
//

#import "CustomImageViewController.h"
#import "Macro.h"

@interface CustomImageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation CustomImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sea_5938" ofType:@"jpg"];
    CGSize size = self.imageView.frame.size;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *image = [self downsampleImageAt:[NSURL URLWithString:IMAGE_URL] to:size scale:1];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
        });
    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (UIImage *)downsampleImageAt:(NSURL *)imageURL to:(CGSize)pointSize scale:(CGFloat)scale {
    CFDictionaryRef imageSourceOptions = CFDictionaryCreate ( CFAllocatorGetDefault(),
                                                              (void *)@[ (NSString *)kCGImageSourceShouldCache ],
                                                              (void *)@[ @(YES) ],
                                                              1,
                                                              &kCFTypeDictionaryKeyCallBacks,
                                                              &kCFTypeDictionaryValueCallBacks);
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((__bridge CFURLRef)imageURL, imageSourceOptions);
    NSInteger maxDimensionInPixels = MAX(pointSize.width, pointSize.height) * scale;
    CFDictionaryRef downsampleOptions = (__bridge CFDictionaryRef)@{ (NSString *)kCGImageSourceCreateThumbnailFromImageAlways : @(YES),
                                           (NSString *)kCGImageSourceShouldCacheImmediately : @(YES),
                                           (NSString *)kCGImageSourceCreateThumbnailWithTransform : @(YES),
                                           (NSString *)kCGImageSourceThumbnailMaxPixelSize : @(maxDimensionInPixels) };
    CGImageRef downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions);
    UIImage *image = [UIImage imageWithCGImage:downsampledImage];
    CGImageRelease(downsampledImage);
//    CFRelease(imageSourceOptions);
//    CFRelease(downsampleOptions);
    return image;
}

@end
