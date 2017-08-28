//
//  SMPCollectionLayout.m
//  SinaMainPage
//
//  Created by helfy on 2017/8/28.
//  Copyright © 2017年 SinaMainPage. All rights reserved.
//

#import "SMPCollectionLayout.h"

@implementation SMPCollectionLayout


- (void)prepareLayout
{
    [super prepareLayout];
    // 水平滚动
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.sectionInset = UIEdgeInsetsZero;
    self.itemSize = self.collectionView.frame.size;
    self.minimumLineSpacing = 0;
    self.collectionView.pagingEnabled = YES;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end
