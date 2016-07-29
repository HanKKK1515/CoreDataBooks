//
//  HLSortView.h
//  books
//
//  Created by 韩露露 on 16/7/29.
//  Copyright © 2016年 韩露露. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HLSortType) {
    kHLSortTypeNameAscending = 1,
    kHLSortTypeNameDescending,
    kHLSortTypeDateAscending,
    kHLSortTypeDateDescending
};

@class HLSortView;
@protocol HLSortViewDelegate <NSObject>

- (void)sortView:(HLSortView *)sortView sortType:(HLSortType)sortType;

@end

@interface HLSortView : UIView

@property (nonatomic, weak) id<HLSortViewDelegate> delegate;

+ (instancetype)sortView;

@end
