//
//  RecordInfo.m
//  XMEye
//
//  Created by Wangchaoqun on 15/1/20.
//  Copyright (c) 2015年 Megatron. All rights reserved.
//

#import "RecordInfo.h"
#import "VideoFileDownloadConfig.h"

@interface RecordInfo()<FileDownloadDelegate>
@property(nonatomic, strong) VideoFileDownloadConfig* downloadConf;
@property(nonatomic, copy) DownloadImageCompleteCallBack downImgCompleteCallBack;
@end

@implementation RecordInfo
- (instancetype)init
{
    self = [super init];
    if (self) {
        _downloadConf = [[VideoFileDownloadConfig alloc] init];
        _downloadConf.delegate = self;
    }
    return self;
}

- (void)startDownloadImageWithComplete:(DownloadImageCompleteCallBack)callBack {
    [_downloadConf downloadThumbImage:self];
    self.downImgCompleteCallBack = callBack;
}

- (void)thumbDownloadResult:(NSInteger)result path:(NSString*)thumbPath {
    if (self.downImgCompleteCallBack) {
        NSData *data = [NSData dataWithContentsOfFile:thumbPath];
        UIImage* thumbImage = [UIImage imageWithData:data];
        self.downImgCompleteCallBack(thumbImage);
    }
}
@end
