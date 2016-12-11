//
//  FindPeoplePhotoController.m
//  助手猫
//
//  Created by ping on 16/6/6.
//  Copyright © 2016年 ping. All rights reserved.
//

#import "FindPeoplePhotoController.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+NJ.h"
@implementation FindPeoplePhotoController
@synthesize photoUrl;
-(void) viewDidLoad
{
    [super viewDidLoad];
    //NSLog(@"this:%@",photoUrl.filePathURL);
   // [self.photoIv sd_setImageWithURL:photoUrl];
 
//    [MBProgressHUD showMessage:@"加载中。。。"];
    [self showTextDialog];
    
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:photoUrl options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        NSLog(@"%d", receivedSize);
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        [self.photoIv setImage:image];
//        [MBProgressHUD showSuccess:@"加载完毕！！！"];
        [self hideDialog];
        NSLog(@"下载完成");
    }];
    
    
    
}
- (void)showTextDialog {
    //初始化进度框，置于当前的View当中
    self.pro = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.pro];
    
    //如果设置此属性则当前的view置于后台
    self.pro.dimBackground = YES;
    
    //设置对话框文字
    self.pro.labelText = @"请稍等";
    [self.pro show:true];
}

-(void)hideDialog{
    //操作执行完后取消对话框
    [self.pro removeFromSuperview];
   // [self.pro release];
    self.pro = nil;
}


@end
