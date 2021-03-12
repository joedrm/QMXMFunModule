//
//  QMUserModel.m
//  FunSDKDemo
//
//  Created by wf on 2020/9/10.
//  Copyright © 2020 wf. All rights reserved.
//

#import "QMUserModel.h"
#import <MJExtension/MJExtension.h>

@implementation QMUserModel

- (instancetype)init
{
    self = [super init];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [QMUserModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                @"userId" : @"id",
                @"lastLogin" : @"last_login",
                @"dateJoined" : @"date_joined",
                @"adminOrganization" : @"admin_organization",
                @"isStaff" : @"is_staff"
            };
        }];
        
        [QMUserModel mj_setupIgnoredPropertyNames:^NSArray *{
            return @[@"isCheck"];
        }];
    });
    
    if (self) {
        
    }
    return self;
}
@end
