//
//  BSSegmentPagingView.h
//  BSSegmentPagingViewDemo
//
//  Created by juxingzhutou on 15/12/18.
//  Copyright © 2015年 bluntsword. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSSegmentPagingView;

@protocol BSSegmentPagingViewDataSource <NSObject>

@required
- (NSUInteger)numberOfPageInPagingView:(BSSegmentPagingView *)pagingView;
- (UIView *)pageAtIndex:(NSUInteger)index;

@end

@protocol BSSegmentPagingViewDelegate <NSObject>

@optional
- (void)bsPagingView:(BSSegmentPagingView *)pagingView didScrollToPage:(NSUInteger)pageIndex;

@end

@interface BSSegmentPagingView : UIView

@property (assign, nonatomic) NSInteger selectedIndex;
@property (weak, nonatomic) id<BSSegmentPagingViewDataSource>   dataSource;
@property (weak, nonatomic) id<BSSegmentPagingViewDelegate>     delegate;

- (void)reloadData;

@end
