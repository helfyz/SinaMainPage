//
//  SMPContainerCollectionViewCell.m
//  SinaMainPage
//
//  Created by helfy on 2017/8/28.
//  Copyright © 2017年 SinaMainPage. All rights reserved.
//

#import "SMPContainerCollectionViewCell.h"
#import <HFTableViewManger.h>
#import <Masonry.h>
#import "SMPDefine.h"
@interface SMPContainerCollectionViewCell () <UIScrollViewDelegate>
@property (nonatomic, strong) HFTableViewManger *tableViewManger;
@end

@implementation SMPContainerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        [self setupView];
        
    }
    return self;
}

- (void)setupView {
    
    self.tableViewManger  = [HFTableViewManger mangerForTableViewStyle:UITableViewStyleGrouped];
    self.tableViewManger.delegate = (id)self;
    self.tableViewManger.dataSource = (id)self;
    
    self.tableViewManger.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, K_HEADER_HEIGTH)];
    [self addSubview:self.tableViewManger.tableView];
    [self.tableViewManger.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetOffset:) name:@"contentOffset" object:nil];
    //检测y值变化
    [self.tableViewManger.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self setupTestDatas];
}

- (void)setupTestDatas {
    
    NSMutableArray *datas = [NSMutableArray array];
    for (NSInteger index =0; index < 100; index ++) {
        [datas addObject:@(index).stringValue];
    }
    [self.tableViewManger setupDataSourceModelsForData:datas cellClassName:@"SMPDataTableViewCell" isAddmore:NO];
}

//当触发横向滚动时，计算偏移
- (void)resetOffset:(NSNotification *)notiy {
    
    float offset = [notiy.object floatValue] * -1;
    if(offset > K_HEADER_HEIGTH) {
        offset = K_HEADER_HEIGTH;
    }
    [self.tableViewManger.tableView setContentOffset:CGPointMake(0, offset)];
    
}
#pragma -- 检测y值变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if([self.delegate respondsToSelector:@selector(tableViewYDidChanged:)]) {
        [self.delegate tableViewYDidChanged:[[change objectForKey:NSKeyValueChangeNewKey] CGPointValue].y];
    }
}
#pragma --- scrollView代理
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if([self.delegate respondsToSelector:@selector(tableViewDidScroll:)]) {
        [self.delegate tableViewDidScroll:self.tableViewManger.tableView];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
