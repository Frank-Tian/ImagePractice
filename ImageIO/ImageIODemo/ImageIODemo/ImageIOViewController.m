//
//  ImageIOViewController.m
//  ImageIODemo
//
//  Created by Tian on 2021/6/1.
//

#import "ImageIOViewController.h"
#import <ImageIO/ImageIO.h>
#import <ImageIO/CGImageProperties.h>

//https://developer.apple.com/library/archive/documentation/GraphicsImaging/Conceptual/ImageIOGuide/imageio_basics/ikpg_basics.html#//apple_ref/doc/uid/TP40005462-CH216-TPXREF101

@interface ImageIOViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
- (IBAction)encodeAction:(id)sender;
- (IBAction)decodeAction:(id)sender;
@end

@implementation ImageIOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Image I/O";
}

- (IBAction)decodeAction:(id)sender {
    [self decodeStaticImageByName:@"ocean"];
    [self decodeStaticImageByName:@"sky"];
//    [self decodeGIFImageByName:@"band"];
}

- (IBAction)encodeAction:(id)sender {
    CFStringRef imageType = CFSTR("public.jpeg");
    // 待编码的CGImage
    CGImageRef imageRef = self.imageView.image.CGImage;
    // 创建容器
    CFMutableDataRef imageData = CFDataCreateMutable(NULL, 0);
    CGImageDestinationRef destination = CGImageDestinationCreateWithData(imageData, imageType, 1, NULL);
    if (!destination) {
        // 无法编码，多为目标格式不支持
    }
    // 可选元信息，比如EXIF方向
    CGImagePropertyOrientation exifOrientation = kCGImagePropertyOrientationDown;
    NSMutableDictionary *frameProperties = [NSMutableDictionary dictionary];
    NSMutableDictionary *imageProperties = [NSMutableDictionary dictionary];
    imageProperties[(__bridge_transfer NSString *) kCGImagePropertyExifDictionary] = @(exifOrientation);
    // 添加图像和元信息
    CGImageDestinationAddImage(destination, imageRef, (__bridge CFDictionaryRef)frameProperties);
    if (CGImageDestinationFinalize(destination) == NO) {
        // 编码失败
    }
    
    // 图片数据已经拿到，可以存储等操作，这里做简单展示
    self.imageView2.image = [UIImage imageWithData:(__bridge NSData * _Nonnull)(imageData)];
    
    CFRelease(imageData);
    CFRelease(imageType);
    CGImageRelease(imageRef);
    CFRelease(destination);
}

- (void)decodeStaticImageByName:(NSString *)name {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"jpg"];
    
    // 方式1
    // UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    // self.imageView.image = image;
    
    // 方式2
    // NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    // UIImage *image = [UIImage imageWithData:imageData];
    // self.imageView.image = image;
    
    // 方式3
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    if (source) {
        NSDictionary *properties = (__bridge NSDictionary *)CGImageSourceCopyProperties(source, NULL);
        NSUInteger fileSize = [properties[(__bridge NSString *)kCGImagePropertyFileSize] unsignedIntegerValue];
        // EXIF信息
        NSDictionary *exifProperties = properties[(__bridge NSString *)kCGImagePropertyExifDictionary];
        // EXIF拍摄时间
        NSString *exifCreateTime = exifProperties[(__bridge NSString *)kCGImagePropertyExifDateTimeOriginal];
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, NULL);
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        self.imageView.image = image;
        // 避免内存泄漏
        CGImageRelease(imageRef);
        CFRelease(source);
    } else {
        // 输入图像数据的格式不支持
    }
}

- (void)decodeGIFImageByName:(NSString *)name {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    if (source) {
        // 获取帧数
        NSUInteger frameCount = CGImageSourceGetCount(source);
        NSMutableArray <UIImage *> *images = [NSMutableArray array];
        double totalDuration = 0;
        for (size_t i = 0; i < frameCount; i++) {
            NSDictionary *frameProperties = (__bridge NSDictionary *) CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
            // GIF属性字典
            NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
            // GIF原始的帧持续时长，秒数
            double duration = [gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime] doubleValue];
            // CGImagePropertyOrientation exifOrientation = [frameProperties[(__bridge NSString *)kCGImagePropertyOrientation] integerValue]; // 方向
            CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, i, NULL);
            // UIImage *image = [[UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:imageOrientation];
            UIImage *image = [UIImage imageWithCGImage:imageRef];
            totalDuration += duration;
            [images addObject:image];
            CGImageRelease(imageRef);
        }
        // 生成动图
        UIImage *animatedImage = [UIImage animatedImageWithImages:images duration:totalDuration];
        self.imageView.image = animatedImage;
        CFRelease(source);
    } else {
        // 输入图像数据的格式不支持
    }
}

@end
