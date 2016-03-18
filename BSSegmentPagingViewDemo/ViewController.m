//
//  ViewController.m
//  BSSegmentPagingViewDemo
//
//  Created by juxingzhutou on 15/12/18.
//  Copyright © 2015年 bluntsword. All rights reserved.
//

#import "ViewController.h"
#import "BSSegmentPagingView.h"
#import "Masonry.h"
#import "SecondPageViewController.h"
#import "DZNSegmentedControl.h"

#define ColorWithRGB(r, g, b) [UIColor colorWithRed: (r) / 255.0f green: (g) / 255.0f blue: (b) / 255.0f alpha:1.0]

@interface ViewController () <BSSegmentPagingViewDataSource, BSSegmentPagingViewDelegate>

@property (weak, nonatomic) DZNSegmentedControl *segmentControl;
@property (weak, nonatomic) BSSegmentPagingView *pagingView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    BSSegmentPagingView *pagingView = [[BSSegmentPagingView alloc] init];
    [self.view addSubview:pagingView];
    [pagingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
    }];
    pagingView.dataSource = self;
    pagingView.delegate = self;
    self.pagingView = pagingView;
    
    [self setupTopSegment];
}

#pragma - mark Setup Methods

- (void)setupTopSegment {
    DZNSegmentedControl *segmentControl = [[DZNSegmentedControl alloc] initWithItems:@[@"1", @"2", @"3"]];
    self.segmentControl = segmentControl;
    [self.view addSubview:segmentControl];
    
    [segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.pagingView.mas_top);
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
    
    [self.segmentControl addTarget:self action:@selector(handleSegmentAction:) forControlEvents:UIControlEventValueChanged];
    
    self.segmentControl.selectedSegmentIndex = 2;
    [self handleSegmentAction:self.segmentControl];
}

#pragma - mark Actions

- (void)handleSegmentAction:(DZNSegmentedControl *)topSegment {
    self.pagingView.selectedIndex = topSegment.selectedSegmentIndex;
}

#pragma - mark BSSegmentPagingViewDelegate

- (void)bsPagingView:(BSSegmentPagingView *)pagingView didScrollToPage:(NSUInteger)pageIndex {
    self.segmentControl.selectedSegmentIndex = pageIndex;
}

#pragma - mark BSSegmentPagingViewDataSource

- (NSUInteger)numberOfPageInPagingView:(BSSegmentPagingView *)pagingView {
    return 3;
}

- (UIView *)pageAtIndex:(NSUInteger)index {
    UIView *view = [[UIView alloc] init];
    
    switch (index) {
        case 0:
            view.backgroundColor = [UIColor greenColor];
            break;
        case 1:
        {
            SecondPageViewController *secondPageVC = [[SecondPageViewController alloc] init];
            [self addChildViewController:secondPageVC];
            [secondPageVC didMoveToParentViewController:self];
            
            return secondPageVC.view;
        }
            break;
        case 2:
            view.backgroundColor = [UIColor blueColor];
            break;
            
        default:
            break;
    }
    
    return view;
}

@end
