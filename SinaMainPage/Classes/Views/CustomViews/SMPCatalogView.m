//
//  SMPCatalogView.m
//  SinaMainPage
//
//  Created by helfy on 2017/8/28.
//  Copyright © 2017年 SinaMainPage. All rights reserved.
//

#import "SMPCatalogView.h"
#import <Masonry.h>
@interface SMPCatalogView ()
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSMutableArray *titleButtons;
@property (nonatomic, strong) UIView *flagView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintWidth;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end
@implementation SMPCatalogView

+ (instancetype)loadXib {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleButtons = [NSMutableArray array];
    
    self.flagView = [[UIView alloc] init];
    [self.contentView addSubview:self.flagView];
    self.flagView.backgroundColor = [UIColor redColor];
}

- (void)setupWithTitles:(NSArray *)titles {
    
    [self.titleButtons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat width = [[UIScreen mainScreen] bounds].size.width / 3;

    self.titles = titles;
    for (NSInteger index = 0; index < self.titles.count; index ++) {
        UIButton *titleButton = [[UIButton alloc] init];
        [titleButton setTitle:self.titles[index] forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [titleButton setTitleColor:self.flagView.backgroundColor forState:UIControlStateSelected];
        titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        titleButton.tag = index;
        [titleButton addTarget:self action:@selector(buttonDidSelect:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:titleButton];
        [titleButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(@(width));
            make.left.equalTo(@(index * width));
        }];
        [self.titleButtons addObject:titleButton];
    }
    self.constraintWidth.constant = width * titles.count;
    UIButton *firstButton = [self.titleButtons firstObject];
    firstButton.selected = YES;
    _currentIndex = firstButton.tag;
    [self.flagView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(firstButton.titleLabel);
        make.centerX.equalTo(firstButton);
        make.bottom.equalTo(self);
        make.height.equalTo(@(3));
    }];
}
//外部改变
- (void)changeIndex:(NSInteger)index isOuter:(BOOL)isOuter{
    
    if(self.currentIndex == index)return;
    _currentIndex = index;
    
    for (UIButton *tempButton in self.titleButtons) {
        tempButton.selected = NO;
        if(tempButton.tag == index) {
            tempButton.selected = YES;
            [self.flagView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(tempButton.titleLabel);
                make.centerX.equalTo(tempButton);
                make.bottom.equalTo(self.contentView);
                make.height.equalTo(@(3));
            }];
            [self.scrollView scrollRectToVisible:tempButton.frame animated:YES];
        }
    }
    [UIView beginAnimations:nil context:nil];
    [self.contentView layoutIfNeeded];
    [UIView commitAnimations];
    
    if(!isOuter) {
        !self.indexDidChanged?:self.indexDidChanged(self.currentIndex);
    }
}

- (void)buttonDidSelect:(UIButton *)button {
    [self changeIndex:button.tag isOuter:NO];
}

//外部触发改变index
- (void)outsideChangeIndex:(NSInteger)index {
    [self changeIndex:index isOuter:YES];
}

@end
