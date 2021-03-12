//
//  UIButton+ImageTextButton.m
//  LBEeacher
//
//  Created by lowell on 9/21/16.
//  Copyright © 2016 lebaoedu. All rights reserved.
//

#import "UIButton+ImageTextButton.h"

@implementation UIButton (ImageTextButton)

- (void)alignmentVertically {
    [self alignmentVertically:10.0f];
}

- (void)alignmentVertically:(CGFloat)offset {
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -self.imageView.frame.size.width, -self.imageView.frame.size.height-offset/2, 0);
    self.imageEdgeInsets = UIEdgeInsetsMake(-self.titleLabel.intrinsicContentSize.height-offset/2, 0, 0, -self.titleLabel.intrinsicContentSize.width);
}

- (void)alignmentHorizontally:(CGFloat)offset {
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -self.imageView.frame.size.width-offset/2, 0, self.imageView.frame.size.width + offset/2);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, self.titleLabel.intrinsicContentSize.width + offset/2, 0, -self.titleLabel.intrinsicContentSize.width-offset/2);
}

@end
