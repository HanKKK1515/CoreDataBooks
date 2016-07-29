//
//  HLSortView.m
//  books
//
//  Created by 韩露露 on 16/7/29.
//  Copyright © 2016年 韩露露. All rights reserved.
//

#import "HLSortView.h"

@interface HLSortView ()
- (IBAction)sortBtn:(UIButton *)sender;
@end

@implementation HLSortView

+ (instancetype)sortView {
    return [[NSBundle mainBundle] loadNibNamed:@"HLSortView" owner:nil options:nil].lastObject;
}

- (IBAction)sortBtn:(UIButton *)sender {
    [self.delegate sortView:self sortType:sender.tag];
}
@end
