//
//  CGXStringPickerView.m
//  CGXPickerView
//
//  Created by CGX on 2017/8/22.
//  Copyright © 2017年 CGX. All rights reserved.
//

#import "CGXStringPickerView.h"

@interface CGXStringPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
// 字符串选择器(默认大小: 320px × 216px)
@property (nonatomic, strong) UIPickerView *pickerView;
// 是否是单列
@property (nonatomic, assign) BOOL isSingleColumn;
// 数据源是否合法（数组的元素类型只能是字符串或数组类型）
@property (nonatomic, assign) BOOL isDataSourceValid;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray  *dataSource;
// 是否开启自动选择
@property (nonatomic, assign) BOOL isAutoSelect;
@property (nonatomic, copy) CGXStringResultBlock resultBlock;

// 单列选中的项
@property (nonatomic, copy) NSString *selectedItem;
// 多列选中的项
@property (nonatomic, strong) NSMutableArray *selectedItems;

@end
@implementation CGXStringPickerView

#pragma mark - 显示自定义字符串选择器
+ (void)showStringPickerWithTitle:(NSString *)title
                       DataSource:(NSArray *)dataSource
                  DefaultSelValue:(id)defaultSelValue
                     IsAutoSelect:(BOOL)isAutoSelect
                      ResultBlock:(CGXStringResultBlock)resultBlock
{
    if (dataSource == nil || dataSource.count == 0) {
        return;
    }
    CGXStringPickerView *strPickerView = [[CGXStringPickerView alloc] initWithTitle:title DataSource:dataSource DefaultSelValue:defaultSelValue IisAutoSelect:isAutoSelect ResultBlock:resultBlock];
    [strPickerView showWithAnimation:YES];
}

#pragma mark - 初始化自定义字符串选择器
- (instancetype)initWithTitle:(NSString *)title
                   DataSource:(NSArray *)dataSource
              DefaultSelValue:(id)defaultSelValue
                IisAutoSelect:(BOOL)isAutoSelect
                  ResultBlock:(CGXStringResultBlock)resultBlock
{
    if (self = [super init]) {
        self.title = title;
        self.dataSource = dataSource;
        self.isAutoSelect = isAutoSelect;
        self.resultBlock = resultBlock;
        if (defaultSelValue) {
            if ([defaultSelValue isKindOfClass:[NSString class]]) {
                self.selectedItem = defaultSelValue;
            } else if ([defaultSelValue isKindOfClass:[NSArray class]]){
                self.selectedItems = [defaultSelValue mutableCopy];
            }
        }
        [self loadData];
        [self initUI];
    }
    return self;
}

#pragma mark - 初始化子视图
- (void)initUI {
    [super initUI];
    self.titleLabel.text = self.title;
    // 添加字符串选择器
    [self.alertView addSubview:self.pickerView];
}

#pragma mark - 加载自定义字符串数据
- (void)loadData {
    if (self.dataSource == nil || self.dataSource.count == 0) {
        self.isDataSourceValid = NO;
        return;
    } else {
        self.isDataSourceValid = YES;
    }
    
    __weak typeof(self) weakSelf = self;
    // 遍历数组元素 (遍历多维数组一般用这个方法)
    [self.dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        static Class itemType;
        if (idx == 0) {
            itemType = [obj class];
            // 判断数据源数组的第一个元素是什么类型
            if ([obj isKindOfClass:[NSArray class]]) {
                weakSelf.isSingleColumn = NO; // 非单列
            } else if ([obj isKindOfClass:[NSString class]]) {
                weakSelf.isSingleColumn = YES; // 单列
            } else {
                weakSelf.isDataSourceValid = NO; // 数组不合法
                return;
            }
        } else {
            // 判断数组的元素类型是否相同
            if (itemType != [obj class]) {
                weakSelf.isDataSourceValid = NO; // 数组不合法
                *stop = YES;
                return;
            }
            
            if ([obj isKindOfClass:[NSArray class]]) {
                if (((NSArray *)obj).count == 0) {
                    weakSelf.isDataSourceValid = NO;
                    *stop = YES;
                    return;
                } else {
                    for (id subObj in obj) {
                        if (![subObj isKindOfClass:[NSString class]]) {
                            weakSelf.isDataSourceValid = NO;
                            *stop = YES;
                            return;
                        }
                    }
                }
            }
        }
    }];
    
    if (self.isSingleColumn) {
        if (self.selectedItem == nil) {
            // 如果是单列，默认选中数组第一个元素
            self.selectedItem = _dataSource.firstObject;
        }
    } else {
        BOOL isSelectedItemsValid = YES;
        for (id obj in self.selectedItems) {
            if (![obj isKindOfClass:[NSString class]]) {
                isSelectedItemsValid = NO;
                break;
            }
        }
        if (self.selectedItems == nil || self.selectedItems.count != self.dataSource.count || !isSelectedItemsValid) {
            NSMutableArray *mutableArray = [NSMutableArray array];
            for (NSArray* componentItem in _dataSource) {
                [mutableArray addObject:componentItem.firstObject];
            }
            self.selectedItems = [NSMutableArray arrayWithArray:mutableArray];
        }
    }
}

#pragma mark - 背景视图的点击事件
- (void)didTapBackgroundView:(UITapGestureRecognizer *)sender {
    [self dismissWithAnimation:NO];
}

#pragma mark - 弹出视图方法
- (void)showWithAnimation:(BOOL)animation {
    //1. 获取当前应用的主窗口
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    if (animation) {
        // 动画前初始位置
        CGRect rect = self.alertView.frame;
        rect.origin.y = QMScreen_Height;
        self.alertView.frame = rect;
        
        // 浮现动画
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = self.alertView.frame;
            rect.origin.y -= self.manager.kTopViewH + self.manager.kPickerViewH;
            self.alertView.frame = rect;
        }];
    }
}

#pragma mark - 关闭视图方法
- (void)dismissWithAnimation:(BOOL)animation {
    // 关闭动画
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = self.alertView.frame;
        rect.origin.y += self.manager.kTopViewH + self.manager.kPickerViewH;
        self.alertView.frame = rect;
        
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - 取消按钮的点击事件
- (void)clickLeftBtn {
    [self dismissWithAnimation:YES];
}

#pragma mark - 确定按钮的点击事件
- (void)clickRightBtn {
    //    NSLog(@"点击确定按钮后，执行block回调");
    [self dismissWithAnimation:YES];
    if(_resultBlock) {
        NSString  *str = [NSString stringWithFormat:@"%ld",[_dataSource indexOfObject:self.selectedItem]];
        NSInteger index = [_dataSource indexOfObject:self.selectedItem];
        _resultBlock(index, [str copy]);
    }
}

#pragma mark - 字符串选择器
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.manager.kTopViewH + 0.5, SCREEN_WIDTH, self.manager.kPickerViewH)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        
        __weak typeof(self) weakSelf = self;
        [_dataSource enumerateObjectsUsingBlock:^(NSString *rowItem, NSUInteger rowIdx, BOOL *stop) {
            if ([weakSelf.selectedItem isEqualToString:rowItem]) {
                [weakSelf.pickerView selectRow:rowIdx inComponent:0 animated:NO];
                *stop = YES;
            }
        }];
    }
    return _pickerView;
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _dataSource.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _dataSource[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedItem = _dataSource[row];
    [pickerView reloadAllComponents];
    // 设置是否自动回调
    if (self.isAutoSelect) {
        if(_resultBlock) {
            NSString  *str = [NSString stringWithFormat:@"%ld",[_dataSource indexOfObject:self.selectedItem]];
            NSInteger index = [_dataSource indexOfObject:self.selectedItem];
            _resultBlock(index,[str copy]);
        }
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    NSLog(@"row:%ld--%ld--%@" , row,component,self.selectedItem);
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 1)
        {
            singleLine.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
        }
    }
    //可以通过自定义label达到自定义pickerview展示数据的方式
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel)
    {
        float width = SCREEN_WIDTH;
        if (self.isSingleColumn) {
            width = SCREEN_WIDTH;
        } else {
            width = SCREEN_WIDTH / 3.0;
        }
        pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, self.manager.rowHeight)];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor whiteColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:self.manager.pickerTitleSize]];
        [pickerLabel setTextColor:self.manager.pickerTitleColor];
    }
    //    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];//调用上一个委托方法，获得要展示的title
    pickerLabel.attributedText = [self pickerView:pickerView attributedTitleForRow:row forComponent:component];
    return pickerLabel;
}
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *normalRowString = [self pickerView:pickerView titleForRow:row forComponent:component];
    NSString *selectRowString = [self pickerView:pickerView titleForRow:[pickerView selectedRowInComponent:component] forComponent:component];
    
    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:normalRowString];
    [attriStr addAttribute:NSForegroundColorAttributeName value:self.manager.pickerTitleColor range:NSMakeRange(0, normalRowString.length)];
    [attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:self.manager.pickerTitleSize] range:NSMakeRange(0, normalRowString.length)];
    
    NSMutableAttributedString * attriSelStr = [[NSMutableAttributedString alloc] initWithString:selectRowString];
    [attriSelStr addAttribute:NSForegroundColorAttributeName value:self.manager.pickerTitleSelectColor range:NSMakeRange(0, selectRowString.length)];
    [attriSelStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:self.manager.pickerTitleSelectSize] range:NSMakeRange(0, selectRowString.length)];
    
    
    if (row == [pickerView selectedRowInComponent:component]) {
        return attriSelStr;
    } else {
        return attriStr;
    }
}

// 设置分组的宽
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return SCREEN_WIDTH;
}

//设置单元格的高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}

@end
