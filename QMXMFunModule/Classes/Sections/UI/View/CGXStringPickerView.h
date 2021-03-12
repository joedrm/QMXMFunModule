//
//  CGXStringPickerView.h
//  CGXPickerView
//
//  Created by CGX on 2017/8/22.
//  Copyright © 2017年 CGX. All rights reserved.
//

#import "CGXPickerUIBaseView.h"

typedef void(^CGXStringResultBlock)(NSInteger selectValue,id selectRow);

@interface CGXStringPickerView : CGXPickerUIBaseView

+ (void)showStringPickerWithTitle:(NSString *)title
                       DataSource:(NSArray *)dataSource
                  DefaultSelValue:(id)defaultSelValue
                     IsAutoSelect:(BOOL)isAutoSelect
                      ResultBlock:(CGXStringResultBlock)resultBlock;
@end
