//
//  CWCollectionViewLayout.m
//  CWCollectionList
//
//  Created by wangcyan on 16/12/2.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "CWCollectionViewLayout.h"

/** 默认设置*/
static const CGFloat CWDefaultColumnMargin = 10;//列间距
static const CGFloat CWDefaultRowMargin = 10;//行间距
static const UIEdgeInsets CWDefaultEdgeInsets = {10, 10, 10, 10};//边间距
static const CGFloat CWDefaultColumnCount = 2;//列数
static const BOOL CWDefaultUpdateViewFrame = NO;//加载完不更新collectionView的高度

@interface CWCollectionViewLayout ()

@property (nonatomic, strong) NSMutableArray <UICollectionViewLayoutAttributes *>*attrsArray; //所有cell的布局属性
@property (nonatomic, strong) NSMutableDictionary *columnHeightDict;//所有列的当前高度
@property (nonatomic, assign) CGFloat contentHeight; //当前内容的高度

- (CGFloat)rowMargin;
- (CGFloat)columnMargin;
- (NSInteger)columnCount;
- (UIEdgeInsets)edgeInsets;
- (BOOL)updateViewFrame;

@end

@implementation CWCollectionViewLayout

#pragma mark -- 基本数据设置
- (CGFloat)rowMargin {
    if ([self.layoutDelegate respondsToSelector:@selector(rowMarginInCollectionViewLayout:)]) {
        return [self.layoutDelegate rowMarginInCollectionViewLayout:self];
    } else {
        return CWDefaultRowMargin;
    }
}

- (CGFloat)columnMargin {
    if ([self.layoutDelegate respondsToSelector:@selector(columnMarginInCollectionViewLayout:)]) {
        return [self.layoutDelegate columnMarginInCollectionViewLayout:self];
    } else {
        return CWDefaultColumnMargin;
    }
}

- (NSInteger)columnCount {
    if ([self.layoutDelegate respondsToSelector:@selector(columnCountInCollectionViewLayout:)]) {
        return [self.layoutDelegate columnCountInCollectionViewLayout:self];
    } else {
        return CWDefaultColumnCount;
    }
}

- (UIEdgeInsets)edgeInsets {
    if ([self.layoutDelegate respondsToSelector:@selector(edgeInsetsInWaterflowLayout:)]) {
        return [self.layoutDelegate edgeInsetsInWaterflowLayout:self];
    } else {
        return CWDefaultEdgeInsets;
    }
}

- (BOOL)updateViewFrame {
    if ([self.layoutDelegate respondsToSelector:@selector(updateViewFrameInWaterflowLayout:)]) {
        return [self.layoutDelegate updateViewFrameInWaterflowLayout:self];
    } else {
        return CWDefaultUpdateViewFrame;
    }
}

#pragma mark -- 懒加载
- (NSMutableArray<UICollectionViewLayoutAttributes *> *)attrsArray {
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

- (NSMutableDictionary *)columnHeightDict {
    if (!_columnHeightDict) {
        _columnHeightDict = [NSMutableDictionary dictionary];
    }
    return _columnHeightDict;
}

#pragma mark -- 初始化
- (void)prepareLayout {
    [super prepareLayout];
    self.contentHeight = 0;
    
    //每次计算之前清除之前高度
    [self.columnHeightDict removeAllObjects];
    for (NSInteger i = 0; i < self.columnCount; i++) {
        [self.columnHeightDict setObject:@(self.edgeInsets.top) forKey:@(i)];
    }
    
    //清除所有布局属性
    [self.attrsArray removeAllObjects];
    
    //获取section下的cell数量,这里只做了单个section的瀑布流
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
    }
    
}

#pragma mark -- UICollectionViewLayout,通过改变UICollectionViewLayoutAttributes，改变其frame/center/size/bounds/transform3D/transform/alpha/zIndex/hidden...
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attrsArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //布局属性中item的size
    CGSize size = [self.layoutDelegate collectionViewLayout:self sizeForItemAtIndexPath:indexPath];
    //最短列高度
    CGFloat minColumnHeight = 0;
    //最短列列数
    NSInteger minColumn = 0;
    
    if (self.columnHeightDict.count != 0) {
        minColumnHeight = [[self.columnHeightDict objectForKey:@(0)] floatValue];
        for (NSInteger i = 1; i < self.columnHeightDict.count; i++) {
            CGFloat columnHeight = [[self.columnHeightDict objectForKey:@(i)] floatValue];
            if (minColumnHeight > columnHeight) {
                minColumnHeight = columnHeight;
                minColumn = i;
            }
        }
        
        //每次item都放在最短列
        CGRect frame = attrs.frame;
        frame.origin.x = self.edgeInsets.left + minColumn*(size.width+self.columnMargin);
        if (indexPath.item < self.columnHeightDict.count) {
            frame.origin.y = minColumnHeight;
        } else {
            frame.origin.y = minColumnHeight+self.rowMargin;
        }
        frame.size.width = size.width;
        frame.size.height = size.height;
        attrs.frame = frame;
        [self.columnHeightDict setObject:@(CGRectGetMaxY(attrs.frame)) forKey:@(minColumn)];
    }
    
    return attrs;
}

- (CGSize)collectionViewContentSize {
    
    for (NSInteger i = 0; i < self.columnHeightDict.count; i++) {
        CGFloat height = [[self.columnHeightDict objectForKey:@(i)] floatValue];
        if (self.contentHeight < height) {
            self.contentHeight = height;
        }
    }
    
    if (self.contentHeight == self.edgeInsets.top) {
        [self updataCollectionViewWithHeight:0];
        return CGSizeMake(0, 0);
    }
    [self updataCollectionViewWithHeight:self.contentHeight+self.edgeInsets.bottom];
    return CGSizeMake(0, self.contentHeight+self.edgeInsets.bottom);
}

#pragma mark -- 更新collectionView的frame
- (void)updataCollectionViewWithHeight:(CGFloat)height {
    
    if (self.updateViewFrame) {
        CGRect frame = self.collectionView.frame;
        frame.size.height = height;
        self.collectionView.frame = frame;
//        NSLog(@"🍎🍎🍎🍎🍎🍎%f", height);
    }
}

@end
