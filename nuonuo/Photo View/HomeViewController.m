//
//  HomeViewController.m
//  nuonuo
//
//  Created by LXX on 2019/11/9.
//  Copyright © 2019年 LXX. All rights reserved.
//

#import "HomeViewController.h"
#import "SearchViewController.h"
#import "SelectPhotoViewController.h"

#import "LxxInterfaceConnection.h"
#import "UIViewController+XHPhoto.h"

#import "OwerViewController.h"


@interface HomeViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITextField *idTextField;

@property (nonatomic, strong) UIImageView *carImageView;
@property (nonatomic, strong) NSString *carImageID;                      /**< 图片上传返回ID */
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self dataConfiguration];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
//}

#pragma mark - Private DataConfiguration
- (void)dataConfiguration{
    
    _backView.layer.shadowOffset = CGSizeMake(0, 0);
    _backView.layer.shadowOpacity=0.8f;
    _backView.layer.shadowColor=[UIColor grayColor].CGColor;

    _idTextField.keyboardType = UIReturnKeyDefault;
    _idTextField.delegate = self;
    _idTextField.textColor = [UIColor blackColor];
    _idTextField.placeholder = @"请输入车牌号";

}

- (IBAction)photoAction:(UIButton *)sender {
    NSLog(@"开始拍照");

    [self chooseHeaderImage];
}

- (IBAction)confirmAction:(UIButton *)sender {
    NSString *cardId = [self.idTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"%@!",cardId);
    
    NSString *getStr = [NSString stringWithFormat:@"photo/%@",cardId];

    NSMutableDictionary * parm = [[NSMutableDictionary alloc]init];
    LxxInterfaceConnection *connect = [[LxxInterfaceConnection alloc] init];
    [connect connetNetWithGetMethod:getStr parms:parm block:^(int fail,NSString *dataMessage,NSDictionary *dictionary) {
        if (fail ==0) {
            NSLog(@"search dataMessage：%@",dataMessage);
            
            //获取匹配到的车信息
            NSMutableArray *arr = [[NSMutableArray alloc]init];
            arr = [dictionary objectForKey:@"data"];
            NSLog(@"search arr：%@",arr);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(arr.count == 0){//无相关信息
                    UIAlertController *sorryAlert = [UIAlertController alertControllerWithTitle:nil message:@"sorry~未找到该车主呢" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
                    [sorryAlert addAction:confirmAction];
                    [self presentViewController:sorryAlert animated:YES completion:nil];
                    
                }else{
                    SearchViewController *svc = [[SearchViewController alloc]init];
                    svc.infoArr = arr;
                    svc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:svc animated:YES];
                }
            
                
            });
        }
    }];
}

- (void)chooseHeaderImage {
    //选择图片
    [self showCanEdit:YES photo:^(UIImage *image) {
        
        SelectPhotoViewController *svc = [[SelectPhotoViewController alloc]init];
        //svc.carImageView.image = image;
        svc.image = image;
        //svc.carImageID = imageId;
        svc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:svc animated:YES];
        
        
//        NSData *originData = UIImageJPEGRepresentation(image, 1.0f);
//        UIImage *resultImage;
//        if (originData.length > 1000) {
//            if(image.size.width > 1000) {
//                CGFloat ratio = image.size.height / image.size.width;
//                CGFloat width = 1000;
//                CGFloat height = ratio * width;
//                CGSize toSize = CGSizeMake(width, height);
//                resultImage = [self imageWithImageSimple:image scaledToSize:toSize];
//            } else {
//                resultImage = image;
//            }
//            NSData *data = UIImageJPEGRepresentation(resultImage, 1.0f);
//            if(data.length > 1000) {
//                data = [self convertImage:resultImage];
//            }
//            resultImage = [UIImage imageWithData:data];
//        } else {
//            resultImage = [UIImage imageWithData:originData];
//        }
//        self.carImageView.image = resultImage ;
//        LxxInterfaceConnection* picConnect = [[LxxInterfaceConnection alloc] init];
//        [picConnect sendImageWithImage:resultImage  block:^(NSString *imageId ,BOOL isFailed) {
////            [LCProgressHUD hide];
//            if(!isFailed) {
//                dispatch_async(dispatch_get_main_queue(), ^{
////                    [LCProgressHUD showFailure:@"头像上传失败，请重试"];
//                    NSLog(@"头像上传失败，请重试");
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////                        [LCProgressHUD hide];
//                    });
////                    self.tableView.userInteractionEnabled = YES;
////                    self.headerImageView.image = beforeImage;
////                    self.isFailed = YES;
//                });
//                return;
//            } else {
//                dispatch_async(dispatch_get_main_queue(), ^{
////                    [LCProgressHUD showSuccess:@"头像上传成功"];
////                    self.headImageModify = true;
//                    NSLog(@"头像上传成功");
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////                        [LCProgressHUD hide];
//                        SelectPhotoViewController *svc = [[SelectPhotoViewController alloc]init];
//                        svc.carImageView.image = image;
//                        svc.image = image;
//                        svc.carImageID = imageId;
//                        svc.hidesBottomBarWhenPushed = YES;
//                        [self.navigationController pushViewController:svc animated:YES];
//                    });
////                    self.tableView.userInteractionEnabled = YES;
////                    self.isFailed = NO;
////                    self.headerImageID = imageId;
////                    self.isReady = YES;
//
//                });
//            }
//        }];
    }];
}
- (NSData *)convertImage:(UIImage *)image {
    CGFloat lowRate = 0.0, highRate = 1.0;
    for (int i = 0; i < 16; ++i) {
        CGFloat midRate = (lowRate + highRate) * 0.5;
        NSData *midData = UIImageJPEGRepresentation(image, midRate);
        if (midData.length < 1000) {
            lowRate = midRate;
        } else {
            highRate = midRate;
        }
    }
    NSData *result = UIImageJPEGRepresentation(image, lowRate);
    return result;
}

- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - UITextFieldDelegate
//点击return收起键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
