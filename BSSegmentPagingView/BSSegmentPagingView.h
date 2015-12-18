//
//  BSSegmentPagingView.h
//  BSSegmentPagingViewDemo
//
//  Created by juxingzhutou on 15/12/18.
//  Copyright © 2015年 bluntsword. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZNSegmentedControl.h"

@class BSSegmentPagingView;

@protocol BSSegmentPagingViewDataSource <NSObject>

@required
- (NSUInteger)numberOfPageInPagingView:(BSSegmentPagingView *)pagingView;
- (UIView *)pageAtIndex:(NSUInteger)index;
- (NSString *)titleInSegmentAtIndex:(NSUInteger)index;

@end

@interface BSSegmentPagingView : UIView

@property (weak, nonatomic) DZNSegmentedControl *segmentControl;

@property (weak, nonatomic) id<BSSegmentPagingViewDataSource> dataSource;

- (void)reloadData;

@end
