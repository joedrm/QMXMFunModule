//
//  QMBundleTool.m
//  QMXMFunModule
//
//  Created by wf on 2021/3/12.
//

#import "QMBundleTool.h"

@implementation QMBundleTool

+ (NSBundle *) getBundleSourcePath:(NSString * )subBundleName{
    NSString * bundleNameWithExtension = [NSString stringWithFormat:@"QMXMFunModule.bundle/%@", subBundleName];
    NSString * bundlePath = [[NSBundle bundleForClass:[QMBundleTool class]].resourcePath
                             stringByAppendingPathComponent:bundleNameWithExtension];
    NSBundle * bundle = [NSBundle bundleWithPath:bundlePath];
    return bundle;
}

+ (UIImage *) getBundleSourceImg:(NSString * )name{
    NSBundle * bundle = [self getBundleSourcePath:@"SVProgressHUD.bundle"];
    UIImage * image = [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    return image;
}

+ (UIImage *) getSectionsImg:(NSString * )name{
    NSBundle * bundle = [self getBundleSourcePath:@"SectionsImages.bundle"];
    NSString* imageName = [NSString stringWithFormat:@"%@@2x", name];
    if ([UIScreen mainScreen].scale == 3) {
        imageName = [NSString stringWithFormat:@"%@@3x", name];
    }
    UIImage * image = [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
    return image;
}
@end
