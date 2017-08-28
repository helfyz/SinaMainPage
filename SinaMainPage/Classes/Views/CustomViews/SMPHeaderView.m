//
//  SMPHeaderView.m
//  SinaMainPage
//
//  Created by helfy on 2017/8/28.
//  Copyright © 2017年 SinaMainPage. All rights reserved.
//

#import "SMPHeaderView.h"

@implementation SMPHeaderView

+ (instancetype)loadXib {
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    
}

@end
