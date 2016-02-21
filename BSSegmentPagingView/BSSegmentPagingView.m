//
//  BSSegmentPagingView.m
//  BSSegmentPagingViewDemo
//
//  Created by juxingzhutou on 15/12/18.
//  Copyright © 2015年 bluntsword. All rights reserved.
//

#import "BSSegmentPagingView.h"
#import "Masonry.h"

@interface BSSegmentPagingView () <UIScrollViewDelegate>

@property (readonly, nonatomic) NSUInteger    numberOfPagesInScrollView;

@property (weak, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSArray *scrollPageViews;

@property (readonly, nonatomic) NSMutableArray *pagesLoadStates;

@end

@implementation BSSegmentPagingView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initializer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializer];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initializer];
}

- (void)initializer {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
}

#pragma - mark Actions

- (void)reloadData {
    _numberOfPagesInScrollView = [self.dataSource numberOfPageInPagingView:self];
    
    [self setupScrollViewWithPageCount:self.numberOfPagesInScrollView];
}

- (void)scrollToPage:(NSInteger)pageIndex {
    if (pageIndex < 0) {
        return;
    }
    
    [self.scrollView setContentOffset:CGPointMake(pageIndex * self.scrollView.frame.size.width, 0) animated:YES];
}

#pragma - mark Accessors

- (void)setDataSource:(id<BSSegmentPagingViewDataSource>)dataSource {
    _dataSource = dataSource;
    
    [self reloadData];
}

#pragma - mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger currentPageIndex = floor((scrollView.contentOffset.x - CGRectGetWidth(scrollView.frame) / 2) / CGRectGetWidth(scrollView.frame)) + 1;
    currentPageIndex = currentPageIndex > 0 ? currentPageIndex : 0;
    [self loadPageAtIndex:currentPageIndex];
    
    if (scrollView.dragging || scrollView.decelerating) {
        if ([self.delegate respondsToSelector:@selector(bsPagingView:didScrollToPage:)]) {
            [self.delegate bsPagingView:self didScrollToPage:currentPageIndex];
        }
    }
}

#pragma makr - Private Methods

- (void)loadPageAtIndex:(NSUInteger)index {
    if (index >= self.numberOfPagesInScrollView
        || [self.pagesLoadStates[index] boolValue]) {
        return;
    }
    
    UIView *pageView = [self.dataSource pageAtIndex:index];
    
    self.pagesLoadStates[index] = @(YES);
    [self setupPageView:pageView atIndex:index];
}

- (void)setupPageView:(UIView *)pageView atIndex:(NSUInteger)index {
    NSAssert(pageView, @"Page view return by BSSegmentPagingViewDataSource must be not nil.");
    
    if (index >= self.numberOfPagesInScrollView) {
        return;
    }
    
    [self.scrollPageViews[index] addSubview:pageView];
    [pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollPageViews[index]);
    }];
}

- (void)setupScrollViewWithPageCount:(NSUInteger)pageCount {
    NSMutableArray *pageStates = [NSMutableArray arrayWithCapacity:pageCount];
    for (int i = 0; i < pageCount; ++i) {
        [pageStates addObject:@(NO)];
    }
    _pagesLoadStates = pageStates;
    
    for (UIView *subview in self.scrollPageViews) {
        [subview removeFromSuperview];
    }
    
    NSMutableArray *scrollViewPages = [NSMutableArray array];
    for (int i = 0; i < pageCount; ++i) {
        UIView *pageView = [[UIView alloc] init];
        pageView.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:pageView];
        [scrollViewPages addObject:pageView];
        [pageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.scrollView.mas_height);
            make.width.equalTo(self.scrollView.mas_width);
            make.top.equalTo(self.scrollView.mas_top);
            
            if (i == 0) {
                make.left.equalTo(self.scrollView.mas_left);
            } else {
                make.left.equalTo([scrollViewPages[i-1] mas_right]);
            }
        }];
    }
    
    [scrollViewPages.lastObject mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.scrollView.mas_right);
    }];
    
    self.scrollPageViews = scrollViewPages;
    
    [self loadPageAtIndex:0];
}

@end
