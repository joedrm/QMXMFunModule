//
//  QMUserModel.h
//  FunSDKDemo
//
//  Created by wf on 2020/9/10.
//  Copyright © 2020 wf. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface QMUserModel : NSObject
@property(nonatomic ,copy) NSString* userId;
@property(nonatomic ,copy) NSString* photo;
@property(nonatomic ,copy) NSString* phone;
@property(nonatomic ,copy) NSString* organization;
@property(nonatomic ,copy) NSString* username;
@property(nonatomic ,copy) NSString* name;
@property(nonatomic ,copy) NSString* lastLogin;
@property(nonatomic ,copy) NSString* dateJoined;
@property(nonatomic ,copy) NSString* adminOrganization;
@property(nonatomic, assign) BOOL active;
@property(nonatomic, assign) BOOL isStaff;

@property(nonatomic, assign) BOOL isCheck;
@end

NS_ASSUME_NONNULL_END
