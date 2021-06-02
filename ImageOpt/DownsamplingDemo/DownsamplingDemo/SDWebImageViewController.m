//
//  SDWebImageViewController.m
//  DownsamplingDemo
//
//  Created by Tian on 2021/6/2.
//

#import "SDWebImageViewController.h"
#import <SDWebImage/SDWebImage.h>
#import "Macro.h"

@interface SDWebImageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation SDWebImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:IMAGE_URL]];
}

@end
