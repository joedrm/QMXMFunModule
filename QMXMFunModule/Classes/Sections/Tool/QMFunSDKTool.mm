//
//  QMFunSDKTool.m
//  Qomo
//
//  Created by wdy on 2020/6/4.
//  Copyright © 2020 sengled. All rights reserved.
//

#import "QMFunSDKTool.h"
#import "UserAccountModel.h"

@interface QMFunSDKTool ()
{
    UserAccountModel* accountModel;
}
@end

@implementation QMFunSDKTool


- (id)init {
    self = [super init];
    accountModel = [[UserAccountModel alloc] init];
    return self;
}

- (void)login {
    
    [accountModel loginWithName:@"wdy123" andPassword:@"wdy123456"];
}

@end
