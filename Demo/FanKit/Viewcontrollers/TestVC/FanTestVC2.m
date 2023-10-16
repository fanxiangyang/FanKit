//
//  CRTestVC2.m
//  FanKit
//
//  Created by 向阳凡 on 2023/10/13.
//  Copyright © 2023 凡向阳. All rights reserved.
//

#import "FanTestVC2.h"
#import <Photos/Photos.h>

@interface FanTestVC2 ()

@end

@implementation FanTestVC2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self testUI1];
}
///iOS17  UIGraphicsBeginImageContext废弃替代方法测试
-(void)testUI1{
    CGFloat w=FanWidth;
//    CGFloat h=FanHeight;
//    CGFloat top=0;
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 60, w*0.3, w*0.3)];
    imgView.backgroundColor = [UIColor clearColor];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.layer.borderWidth = 1;
    [self.view addSubview:imgView];
    
    UIImageView *imgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(20+w*0.3+20, 60, w*0.3, w*0.3)];
    imgView2.backgroundColor = [UIColor clearColor];
    imgView2.contentMode = UIViewContentModeScaleAspectFit;
    imgView2.layer.borderWidth = 1;
    [self.view addSubview:imgView2];
    //FanKit_circleColor 190*190 2x
    UIImage *colorImage = FanImageName(@"FanKit_circleColor");
    //等比填充
//    UIImage *image1 = [FanUIKit fan_scalImage:colorImage scalingForSize:CGSizeMake(300, 300)];
//    imgView.image = image1;
//    [self saveAlbum:image1];
    //等比适配
//    UIImage *image2 = [FanUIKit fan_scalImage:colorImage scaleAspectFitSize:CGSizeMake(50, 800)];
//    imgView.image = image2;
//    [self saveAlbum:image2];
    //不变形裁剪
//    UIImage *image3 = [FanUIKit fan_clipImage:colorImage imageViewSize:CGSizeMake(1000, 1000) clipRect:CGRectMake(100, 0, 900, 1000) isOval:NO];
//    imgView.image = image3;
//    [self saveAlbum:image3];
    //根据color生成图片
    UIImage *image4 = [FanUIKit fan_imageWithColor:[UIColor redColor] size:CGSizeMake(300, 200) cornerRadius:30];
    imgView.image = image4;
//    [self saveAlbum:image4];
    
    //截屏-裁剪
//    UIImage *image5 = [FanUIKit fan_beginImageContext:CGRectMake(0, 0, 300, 300) fromView:self.view];
    UIImage *image5 = [FanUIKit fan_snapshotLayerImage:self.view];
    imgView2.image = image5;
//    [self saveAlbum:image4];
}
-(void)saveAlbum:(UIImage*)data{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest *request = [PHAssetChangeRequest creationRequestForAssetFromImage:data];
        // request.placeholderForCreatedAsset.localIdentifier;        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        NSLog(@"图片保存:%d  error:%@",success,error);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
