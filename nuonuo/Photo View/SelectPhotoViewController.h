//
//  SelectPhotoViewController.h
//  nuonuo
//
//  Created by LXX on 2019/11/22.
//  Copyright © 2019年 LXX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectPhotoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;

@property (nonatomic) UIImage *image;
@property (nonatomic, strong) NSString *carImageID;                      /**< 图片上传返回ID */


@end

NS_ASSUME_NONNULL_END
