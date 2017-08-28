//
//  SMPDataTableViewCell.m
//  SinaMainPage
//
//  Created by helfy on 2017/8/28.
//  Copyright © 2017年 SinaMainPage. All rights reserved.
//

#import "SMPDataTableViewCell.h"
@interface SMPDataTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end
@implementation SMPDataTableViewCell

- (void)setupView {
    self.titleLabel.textColor = [UIColor grayColor];
}

- (void)bindData:(HFTableViewCellModel *)cellModel {
    [super bindData:cellModel];
    self.titleLabel.text = cellModel.cellData;
}
@end
