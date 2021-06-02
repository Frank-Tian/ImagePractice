//
//  YYImageViewController.m
//  DownsamplingDemo
//
//  Created by Tian on 2021/6/2.
//

#import "YYImageViewController.h"
#import <YYImage/YYImage.h>
#import <YYWebImage/YYWebImage.h>
#import "Macro.h"

@interface YYImageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation YYImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.imageView yy_setImageWithURL:[NSURL URLWithString:IMAGE_URL] options:0];
}

@end
