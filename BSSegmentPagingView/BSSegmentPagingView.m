//
//  BSSegmentPagingView.m
//  BSSegmentPagingViewDemo
//
//  Created by juxingzhutou on 15/12/18.
//  Copyright © 2015年 bluntsword. All rights reserved.
//

#import "BSSegmentPagingView.h"
#import "Masonry.h"

#define ColorWithRGB(r, g, b) [UIColor colorWithRed: (r) / 255.0f green: (g) / 255.0f blue: (b) / 255.0f alpha:1.0]

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
    [self setupTopSegment];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.segmentControl.mas_bottom);
    }];
    
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
}

#pragma mark - Setup Methods

- (void)setupTopSegment {
    DZNSegmentedControl *segmentControl = [[DZNSegmentedControl alloc] init];
    self.segmentControl = segmentControl;
    [self addSubview:segmentControl];
    
    [segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];
    
    segmentControl.bouncySelectionIndicator = YES;
    segmentControl.adjustsFontSizeToFitWidth = NO;
    segmentControl.autoAdjustSelectionIndicatorWidth = NO;
    segmentControl.showsCount = NO;
    
    [segmentControl setBackgroundColor:[UIColor whiteColor]];
    [segmentControl setTintColor:ColorWithRGB(0, 122, 255)];
    [segmentControl setHairlineColor:ColorWithRGB(153, 153, 153)];
    [segmentControl setFont:[UIFont systemFontOfSize:13.0]];
    [segmentControl setSelectionIndicatorHeight:1.5];
    [segmentControl setAnimationDuration:0.125];
    
    [self setupSegmentControlAction];
    self.segmentControl.selectedSegmentIndex = 0;
}

- (void)setupSegmentControlAction {
    [self.segmentControl addTarget:self action:@selector(handleSegmentAction:) forControlEvents:UIControlEventValueChanged];
}

- (void)reloadData {
    _numberOfPagesInScrollView = [self.dataSource numberOfPageInPagingView:self];
    NSMutableArray *segmentTitles = [NSMutableArray array];
    for (int i = 0; i < self.numberOfPagesInScrollView; ++i) {
        NSString *title = [self.dataSource titleInSegmentAtIndex:i];
        NSAssert(title != nil, @"Segment title return by BSSegmentPagingViewDataSource must be not nil.");
        [segmentTitles addObject:title];
    }
    self.segmentControl.items = segmentTitles;
    [self setupScrollViewWithPageCount:self.numberOfPagesInScrollView];
}

#pragma mark - Actions

- (void)handleSegmentAction:(DZNSegmentedControl *)topSegment {
    [self.scrollView setContentOffset:CGPointMake(topSegment.selectedSegmentIndex * self.scrollView.frame.size.width, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger currentPageIndex = floor((scrollView.contentOffset.x - CGRectGetWidth(scrollView.frame) / 2) / CGRectGetWidth(scrollView.frame)) + 1;
    currentPageIndex = currentPageIndex > 0 ? currentPageIndex : 0;
    [self loadPageAtIndex:currentPageIndex];
    
    if (scrollView.dragging || scrollView.decelerating) {
        [self.segmentControl removeTarget:self action:NULL forControlEvents:UIControlEventValueChanged];
        self.segmentControl.selectedSegmentIndex = currentPageIndex;
        [self setupSegmentControlAction];
    }
}

#pragma mark - Accessors

- (void)setDataSource:(id<BSSegmentPagingViewDataSource>)dataSource {
    _dataSource = dataSource;
    
    [self reloadData];
}

#pragma makr - Internal Methods

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
