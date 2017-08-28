//
//  SMPContainerCollectionViewCell.h
//  SinaMainPage
//
//  Created by helfy on 2017/8/28.
//  Copyright © 2017年 SinaMainPage. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SMPContainerCollectionViewCellDeleagte <NSObject>
//子控件竖向滚动
- (void)tableViewDidScroll:(UITableView *)tableView;
//控件竖向滚动 y值变化
- (void)tableViewYDidChanged:(CGFloat)y;

@end


@interface SMPContainerCollectionViewCell : UICollectionViewCell
@property (nonatomic, weak) id<SMPContainerCollectionViewCellDeleagte> delegate;

@end
