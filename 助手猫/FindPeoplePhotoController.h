//
//  FindPeoplePhotoController.h
//  助手猫
//
//  Created by ping on 16/6/6.
//  Copyright © 2016年 ping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD+NJ.h"

@interface FindPeoplePhotoController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *photoIv;
@property NSURL *photoUrl;
@property MBProgressHUD *pro;
@end
