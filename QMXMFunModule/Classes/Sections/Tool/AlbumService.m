//
//  AlbumService.m
//  FunSDKDemo
//
//  Created by wf on 2020/9/11.
//  Copyright © 2020 wf. All rights reserved.
//

#import "AlbumService.h"
 
 
@interface AlbumService ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIImagePickerController *imagePicker;
}
 
@end
 
@implementation AlbumService
static AlbumService *contacts;
+(AlbumService *)sharedContactsService{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        contacts = [AlbumService new];
    });
    return contacts;
}
 
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isFull = false;
    }
    return self;
}
 
#pragma mark - setter
-(void)setSType:(UIImagePickerControllerSourceType)sType
{
    _sType = sType;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        _sType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
}
 
#pragma mark - public
-(void)showAlbumInViewController:(UIViewController *)curVc
{
    UIImagePickerControllerSourceType sourceType = self.sType?:UIImagePickerControllerSourceTypePhotoLibrary;
    if (!imagePicker) {
        imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
    }
    imagePicker.sourceType = sourceType;
    
    [curVc presentViewController:imagePicker animated:YES completion:nil];
   
}
 
-(void)hideAlbum
{
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}
 
#pragma mark - UIImagePickerViewDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *stateKey = self.imageStateKey?:UIImagePickerControllerEditedImage;
    UIImage *resultImage = [info valueForKey:stateKey];
    
    __weak typeof(self) weakSelf = self;
    if (weakSelf.callBack) {
        weakSelf.callBack(resultImage);
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
 
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
