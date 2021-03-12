//
//  QMPhotoPickerService.m
//  FunSDKDemo
//
//  Created by wf on 2020/9/12.
//  Copyright © 2020 wf. All rights reserved.
//

#import "QMPhotoPickerService.h"
#import "TZImagePickerController.h"
#import "AuthorizationService.h"
#import "UIColor+LBECategory.h"

@interface QMPhotoPickerService () <TZImagePickerControllerDelegate>
@property (nonatomic, strong) TZImagePickerController* pickerVC;
@property (nonatomic, copy) ImagePickerBlock callBack;
@end

@implementation QMPhotoPickerService


+ (instancetype) createServiceSelectedImage:(ImagePickerBlock)callBack {
    QMPhotoPickerService* service = [[QMPhotoPickerService alloc] init];
    service.callBack = callBack;
    return service;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        TZImagePickerController* pickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self];
        pickerVC.allowPickingVideo = false;
        pickerVC.naviBgColor = [UIColor colorWithHexString:@"D93124"];
        self.pickerVC = pickerVC;
    }
    return self;
}


- (void)presentWithVC:(UIViewController *)vc {
    [vc presentViewController:self.pickerVC animated:true completion:nil];
}


- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    if (self.callBack) {
        self.callBack(photos.firstObject);
    }
}
@end
