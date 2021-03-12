//
//  AlbumService.h
//  FunSDKDemo
//
//  Created by wf on 2020/9/11.
//  Copyright © 2020 wf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^doneSelectBlock)(UIImage *image);

@interface AlbumService : NSObject
@property (nonatomic,assign) UIImagePickerControllerSourceType sType;
@property (nonatomic,strong) UIImage *selectedImage;
@property (nonatomic,assign) id imageStateKey;
@property (nonatomic,copy) doneSelectBlock callBack;
+ (AlbumService *)sharedContactsService;
- (void)showAlbumInViewController:(UIViewController *)curVc;;
- (void)hideAlbum;


@property (nonatomic, assign) BOOL isFull;
@end

NS_ASSUME_NONNULL_END
