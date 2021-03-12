//
//  QMTempleteModel.m
//  FunSDKDemo
//
//  Created by wf on 2020/9/10.
//  Copyright © 2020 wf. All rights reserved.
//

#import "QMTempleteModel.h"
#import <MJExtension/MJExtension.h>

@implementation QMTempleteModel
- (instancetype)init
{
    self = [super init];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [QMTempleteModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                @"templeteId" : @"id",
                @"createdTime" : @"created_time",
                @"des" : @"description"
            };
        }];
        
        [[self class] mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"categories": @"QMTempleteCategoyModel"};
        }];
    });
    if (self) {
        
    }
    return self;
}
@end


@implementation QMTempleteCategoyModel

- (instancetype)init
{
    self = [super init];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                @"categoryId" : @"id",
                @"gradingSet" : @"grading_set"
            };
        }];
        
        [[self class] mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"gradingSet": @"QMCategoyItemModel"};
        }];
    });
    if (self) {
        
    }
    return self;
}

@end



@implementation QMCategoyItemModel

- (instancetype)init
{
    self = [super init];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                @"itemId" : @"id"
            };
        }];
        [[self class] mj_setupNewValueFromOldValue:^id(id object, id oldValue, MJProperty *property) {
            if ([property.name isEqualToString:@"gradings"]) {
                return [QMScoreItemModel mj_objectArrayWithKeyValuesArray:[oldValue mj_JSONObject]];
            }
            return oldValue;
        }];
    });
    if (self) {
        
    }
    return self;
}

@end


@implementation QMScoreItemModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[self class] mj_setupIgnoredPropertyNames:^NSArray *{
            return @[@"parentID"];
        }];
    }
    return self;
}

@end
