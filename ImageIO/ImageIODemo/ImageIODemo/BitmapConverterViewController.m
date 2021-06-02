//
//  BitmapConverterViewController.m
//  ImageIODemo
//
//  Created by Tian on 2021/6/2.
//

#import "BitmapConverterViewController.h"

@interface BitmapConverterViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
- (IBAction)bitmapCreateImageAction:(id)sender;
- (IBAction)imageToBitmapAction:(id)sender;

@end

@implementation BitmapConverterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Bitmap Converter";
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sunflower" ofType:@"jpg"];
    self.imageView.image = [UIImage imageWithContentsOfFile:filePath];
}

- (IBAction)bitmapCreateImageAction:(id)sender {
    
}

- (IBAction)imageToBitmapAction:(id)sender {
    CGImageRef imageRef = self.imageView.image.CGImage;
    CGBitmapInfo bitmap = CGImageGetBitmapInfo(imageRef);
    NSData *imageData;
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    // 大部分编码器需要知道bytesPerRow，或者叫做stride
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    CFDataRef dataRef = CGDataProviderCopyData(dataProvider);
    uint8_t *rgba = (uint8_t *)CFDataGetBytePtr(dataRef);
}
@end
