//
//  QMTempleteModel.h
//  FunSDKDemo
//
//  Created by wf on 2020/9/10.
//  Copyright © 2020 wf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 {
   "id" : "0e8cab4e-af3e-0ea2-4724-6198f7079c7c",
   "title" : "test",
   "organization" : "0e8ca4d5-421f-813e-0487-e4e2b5514b06",
   "description" : "afsfd",
   "created_time" : "2020-09-10T18:20:27.091063+08:00",
   "categories" : [
     {
       "grading_set" : [
         {
           "id" : "0e8ca4fe-7848-247d-4432-65d6f6e4d893",
           "title" : "地面整洁度",
           "organization" : "0e8ca4d5-421f-813e-0487-e4e2b5514b06",
           "gradings" : "[{\"label\":\"优\",\"score\":10},{\"label\":\"良\",\"score\":7},{\"label\":\"差\",\"score\":-2}]",
           "category" : "0e8ca4fc-c88a-6032-9de0-c1b7eb7cc25c"
         }
       ],
       "id" : "0e8ca4fc-c88a-6032-9de0-c1b7eb7cc25c",
       "title" : "卫生环境",
       "organization" : "0e8ca4d5-421f-813e-0487-e4e2b5514b06"
     }
   ]
 }
 
 [{
     "label": "优",
     "score": 10
 }, {
     "label": "良",
     "score": 7
 }, {
     "label": "差",
     "score": -2
 }]
 */

/// 模版
@class QMTempleteCategoyModel;
@interface QMTempleteModel : NSObject
@property(nonatomic ,copy) NSString* templeteId;
@property(nonatomic ,copy) NSString* title;
@property(nonatomic ,copy) NSString* organization;
@property(nonatomic ,copy) NSString* des;
@property(nonatomic ,copy) NSString* createdTime;
@property(nonatomic ,strong) NSMutableArray<QMTempleteCategoyModel*>* categories;
@end

/// 模版分类
@class QMCategoyItemModel;
@interface QMTempleteCategoyModel : NSObject
@property(nonatomic ,copy) NSString* categoryId;
@property(nonatomic ,copy) NSString* title;
@property(nonatomic ,copy) NSString* organization;
@property(nonatomic ,strong) NSMutableArray<QMCategoyItemModel*>* gradingSet;
@end

/// 模版分类条目
@class QMScoreItemModel;
@interface QMCategoyItemModel : NSObject
@property(nonatomic ,copy) NSString* itemId;
@property(nonatomic ,copy) NSString* title;
@property(nonatomic ,copy) NSString* organization;
@property(nonatomic ,copy) NSString* category;
@property(nonatomic ,strong) NSArray<QMScoreItemModel*>* gradings;
@end

/// 模版分类条目打分项
@interface QMScoreItemModel : NSObject
@property(nonatomic ,copy) NSString* label;
@property(nonatomic ,copy) NSString* parentID;
@property(nonatomic ,assign) int score;
@property(nonatomic, assign) BOOL isCheck;

@end

NS_ASSUME_NONNULL_END
