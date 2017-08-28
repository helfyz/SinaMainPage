//
//  SMPMainViewController.m
//  SinaMainPage
//
//  Created by helfy on 2017/8/28.
//  Copyright © 2017年 SinaMainPage. All rights reserved.
//

#import "SMPMainViewController.h"
#import "SMPCollectionLayout.h"
#import "SMPContainerCollectionViewCell.h"
#import "SMPHeaderView.h"
#import "SMPDefine.h"
#import "SMPCatalogView.h"
#import <Masonry.h>

@interface SMPMainViewController () <UICollectionViewDelegate, UICollectionViewDataSource, SMPContainerCollectionViewCellDeleagte>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) SMPHeaderView *headerView;
@property (nonatomic, strong) SMPCatalogView *catalogView;
@property (nonatomic, strong) NSArray *catalogs;
@end

@implementation SMPMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.catalogs = @[@"标题1",@"标题2",@"标题3",@"标题4"];
    
    SMPCollectionLayout *layout = [[SMPCollectionLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    [self.collectionView registerClass:[SMPContainerCollectionViewCell class] forCellWithReuseIdentifier:@"SMPContainerCollectionViewCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    //初始化 headerView
    self.headerView = [SMPHeaderView loadXib];
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(@(K_HEADER_HEIGTH));
    }];
    //初始化catalogView
    self.catalogView = [SMPCatalogView loadXib];
    [self.catalogView setupWithTitles:self.catalogs];
    [self.headerView addSubview:self.catalogView];
    [self.catalogView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.headerView);
        make.height.equalTo(@(K_CATALOG_HEIGTH));
    }];
    
    __weak typeof(self) ws = self;
    [self.catalogView setIndexDidChanged:^(NSInteger index){
        [ws.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }];
}

- (void)changeToCatlogIndex:(NSInteger)index {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

#pragma mark -- UICollectionViewDataSource
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SMPContainerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SMPContainerCollectionViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.catalogs.count;
}

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark -- 横向 & 纵向 滚动 代理
//当前横向滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect rect = [self.headerView convertRect:self.headerView.bounds toView:self.view];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"contentOffset" object:@(rect.origin.y)];
    
    if([self.headerView superview] == self.view) return;
    [self.view addSubview:self.headerView];
    [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(rect.origin.y));
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(K_HEADER_HEIGTH));
    }];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger newIndex = scrollView.contentOffset.x / scrollView.frame.size.width + 0.5;
    [self.catalogView outsideChangeIndex:newIndex];
    
}
//子控件竖向滚动
- (void)tableViewDidScroll:(UITableView *)tableView {
    if([self.headerView superview] == tableView.tableHeaderView) return;
    [tableView.tableHeaderView addSubview : self.headerView];
    [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.equalTo(tableView.tableHeaderView);
    }];
    [tableView.tableHeaderView layoutSubviews];
}

#pragma mark -- 目录到顶之后不出去，这种网上一搜一堆，我就简单实现一下,主要逻辑就是监控当前滚动的tableView的offset,如果超出之后，就把catalog 脱离headView ，正常范围则回到headerView
- (void)tableViewYDidChanged:(CGFloat)y {
    if(y > K_HEADER_HEIGTH - K_CATALOG_HEIGTH) {
        [self.view addSubview:self.catalogView];
        [self.catalogView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.height.equalTo(@(K_CATALOG_HEIGTH));
        }];
    }
    else {
        [self.headerView addSubview:self.catalogView];
        [self.catalogView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.headerView);
            make.height.equalTo(@(K_CATALOG_HEIGTH));
        }];
    }
}
@end
