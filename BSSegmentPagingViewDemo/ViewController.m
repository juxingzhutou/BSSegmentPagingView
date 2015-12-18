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

@interface ViewController () <BSSegmentPagingViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    BSSegmentPagingView *pagingView = [[BSSegmentPagingView alloc] init];
    [self.view addSubview:pagingView];
    [pagingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(20, 0, 0, 0));
    }];
    pagingView.dataSource = self;
}

#pragma mark - BSSegmentPagingViewDataSource

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

- (NSString *)titleInSegmentAtIndex:(NSUInteger)index {
    return [[NSNumber numberWithUnsignedInteger:index] stringValue];
}

@end
