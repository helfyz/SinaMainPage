//
//  SMPCatalogView.h
//  SinaMainPage
//
//  Created by helfy on 2017/8/28.
//  Copyright © 2017年 SinaMainPage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMPCatalogView : UIView
@property (nonatomic, readonly) NSInteger currentIndex; //当前选择的index
@property (nonatomic, copy) void(^indexDidChanged)(NSInteger index);

+ (instancetype)loadXib;
- (void)setupWithTitles:(NSArray *)titles;
- (void)outsideChangeIndex:(NSInteger)index; //外部引发改变index

@end
