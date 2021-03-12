//
//  QMBundleTool.h
//  QMXMFunModule
//
//  Created by wf on 2021/3/12.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QMBundleTool : NSObject
+ (NSBundle *) getBundleSourcePath:(NSString * )subBundleName;
+ (UIImage *) getBundleSourceImg:(NSString * )name;
@end

NS_ASSUME_NONNULL_END
