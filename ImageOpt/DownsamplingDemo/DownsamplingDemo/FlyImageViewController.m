//
//  FlayImageViewController.m
//  DownsamplingDemo
//
//  Created by Tian on 2021/6/2.
//

#import "FlyImageViewController.h"
#import <FlyImage/FlyImage.h>
#import "Macro.h"

@interface FlyImageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation FlyImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.imageView setPlaceHolderImageName:nil thumbnailURL:nil originalURL:[NSURL URLWithString:IMAGE_URL]];
}

@end
