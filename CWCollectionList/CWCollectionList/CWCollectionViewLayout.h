//
//  CWCollectionViewLayout.h
//  CWCollectionList
//
//  Created by wangcyan on 16/12/2.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CWCollectionViewLayout;
@protocol CWCollectionViewLayoutDelegate <NSObject>

@required
 /** item的size，为了避免storyboard默认的宽度1000，这里size的宽度是根据列数计算的（collectionView的宽度-边缘间距(UIEdgeInsets.left+UIEdgeInsets.right)-(列数-1)*列间距），列数默认是2，所有间距默认都是10*/
- (CGSize)collectionViewLayout:(CWCollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional
/** 列数*/
- (CGFloat)columnCountInCollectionViewLayout:(CWCollectionViewLayout *)collectionViewLayout;
/** 列间距*/
- (CGFloat)columnMarginInCollectionViewLayout:(CWCollectionViewLayout *)collectionViewLayout;
/** 行间距*/
- (CGFloat)rowMarginInCollectionViewLayout:(CWCollectionViewLayout *)collectionViewLayout;
/** view边缘间距*/
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(CWCollectionViewLayout *)collectionViewLayout;
/** 更新（加载）item,是否改变Collection的高度*/
- (BOOL)updateViewFrameInWaterflowLayout:(CWCollectionViewLayout *)collectionViewLayout;

@end

@interface CWCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, weak) id<CWCollectionViewLayoutDelegate> layoutDelegate;

@end
