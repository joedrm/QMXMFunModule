//
//  QMXMSnapshotsVIew.h
//  FunSDKDemo
//
//  Created by wf on 2020/8/11.
//  Copyright © 2020 wf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^AddImageCallBack)();
typedef void(^ItemClickedCallBack)(UIImage *img, NSInteger index);

@interface QMXMSnapshotsView : UIView
@property (nonatomic, strong, readonly) NSMutableArray<UIImage*> * snaps;
- (void)reloadSnapshotData:(NSMutableArray *)snaps;
- (void)addPhoto:(UIImage *)photo;
- (void)addPhotoWithFilePath:(NSString *)imageFilePath;
- (void)reloadColllectionData;
- (void)replacePhotoImageIndex:(NSInteger)originalImageIndex editedImage:(UIImage *)editedImage;

@property(nonatomic, copy) AddImageCallBack callBack;
@property(nonatomic, copy) ItemClickedCallBack itemClicked;
@end

NS_ASSUME_NONNULL_END
