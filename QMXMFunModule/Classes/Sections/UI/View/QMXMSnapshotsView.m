//
//  QMXMSnapshotsVIew.m
//  FunSDKDemo
//
//  Created by wf on 2020/8/11.
//  Copyright © 2020 wf. All rights reserved.
//

#import "QMXMSnapshotsView.h"
#import "QMXMSnapshotCCellView.h"
#import <Masonry/Masonry.h>
#import "QMXMSnapshotAddCCell.h"

@interface QMXMSnapshotsView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView * photoCollectionView;
@property (nonatomic, strong, readwrite) NSMutableArray<UIImage*> * snaps;
@end

@implementation QMXMSnapshotsView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.snaps = [NSMutableArray array];
        self.userInteractionEnabled = true;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.photoCollectionView];
        [self.photoCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(self);
            make.height.mas_equalTo(100);
            make.width.mas_equalTo(self);
        }];
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.photoCollectionView.mas_bottom);
            
            make.height.mas_equalTo(100);
        }];
        //        self.photoCollectionView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //    self.photoCollectionView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)reloadSnapshotData:(NSMutableArray *)snaps {
    for (NSString *str in snaps) {
        [self addPhotoWithFilePath:str];
    }
}

- (void)addPhoto:(UIImage *)photo {
    [self.snaps addObject:photo];
    [self.photoCollectionView reloadData];
}

- (void)addPhotoWithFilePath:(NSString *)imageFilePath {
    UIImage* img = [UIImage imageWithContentsOfFile:imageFilePath];
    [self.snaps addObject:img];
    [self.photoCollectionView reloadData];
}

- (void)reloadColllectionData {
    [self.photoCollectionView reloadData];
}

- (void)replacePhotoImageIndex:(NSInteger)originalImageIndex editedImage:(UIImage *)editedImage {
//    NSInteger index = [self.snaps indexOfObject:originalImage];
    [self.snaps replaceObjectAtIndex:originalImageIndex withObject:editedImage];
    [self reloadColllectionData];
}

- (UICollectionView *)photoCollectionView
{
    if (!_photoCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 0;
        //        flowLayout.estimatedItemSize = CGSizeMake(100, 100);
        flowLayout.itemSize = CGSizeMake(100, 90);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _photoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _photoCollectionView.delegate = self;
        _photoCollectionView.dataSource = self;
        _photoCollectionView.bounces = YES;
        _photoCollectionView.scrollEnabled = true;
        _photoCollectionView.backgroundColor = [UIColor whiteColor];
        [_photoCollectionView registerClass:[QMXMSnapshotCCellView class] forCellWithReuseIdentifier:@"QMXMSnapshotCCellView"];
        [_photoCollectionView registerClass:[QMXMSnapshotAddCCell class] forCellWithReuseIdentifier:@"QMXMSnapshotAddCCell"];
        _photoCollectionView.showsVerticalScrollIndicator = false;
        _photoCollectionView.showsHorizontalScrollIndicator = false;
    }
    return _photoCollectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.snaps.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.snaps.count) {
        QMXMSnapshotAddCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QMXMSnapshotAddCCell" forIndexPath:indexPath];
        [cell.addBtn addTarget:self action:@selector(clickedAddBtn) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else {
        QMXMSnapshotCCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QMXMSnapshotCCellView" forIndexPath:indexPath];
        cell.image = self.snaps[indexPath.row];
        cell.deleteBtn.tag = indexPath.row;
        [cell.deleteBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.snaps.count <= 0) {
        return;
    }
    UIImage* image = self.snaps[indexPath.row];
    if (self.itemClicked != NULL) {
        self.itemClicked(image, indexPath.row);
    }
}

- (void)clickedBtn: (UIButton *)sender {
    [self.snaps removeObjectAtIndex:sender.tag];
    [self.photoCollectionView reloadData];
}


- (void) clickedAddBtn {
    
    if (self.callBack != NULL) {
        self.callBack();
    }
}
@end


