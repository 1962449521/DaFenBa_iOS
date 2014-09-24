//
//  MainVCNew.m
//  DaFenBa
//
//  Created by 胡 帅 on 14-9-5.
//  Copyright (c) 2014年 胡 帅. All rights reserved.
//

#import "ConcreteMainVC.h"


@implementation ConcreteMainVC
{
    UIView *maskView;//遮挡当前VC层和前个VC层，避免当前VC动画时露出前个VC层
}


@synthesize tabBar = _tabBar, viewControllers = _viewControllers, selectedIndex = _selectedIndex, selectedViewController = _selectedViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.autoresizesSubviews = NO;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tabBar = (ConcreteTabBarView *)[[[NSBundle mainBundle]loadNibNamed:@"ConcreteTabBarView" owner:self options:nil]firstObject];
    CGFloat orginHeight = self.view.frame.size.height- _tabBar.height;
    [_tabBar setTop:orginHeight];
    _tabBar.delegate = self;
    [self.view addSubview:_tabBar];
    _viewControllers = [self getViewcontrollers];
    
    [self setSelectedIndex:0];
}


/**
 *	@brief	初始化tabBar外观和子视图
 */
-(NSArray *)getViewcontrollers
{
    NSArray *VCNames      = @[@"HomeVC", @"MessageVC", @"UIViewController", @"DiscoverVC", @"MeVC"];
    int tabCount          = [VCNames count];
    //NSMutableArray *controllers = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < tabCount; i++)
    {
        Class vcClass = NSClassFromString(VCNames[i]);
        BaseVC *vc = [[vcClass alloc]init];
        UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:vc];
//        [controllers addObject:navC];
        [self addChildViewController:navC];
        if(i == 0)
            [self.view addSubview:navC.view];
    }
    return self.childViewControllers;
    
}
#pragma mark - MainModuleDelegate
- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if ([self shouldSelectIndex:selectedIndex]) {
        [self.tabBar setSelectedIndex:selectedIndex];
        [self didSelectedIndex:selectedIndex];
    }
}
- (BOOL)shouldSelectIndex:(NSInteger)index
{
    
    BaseVC *fromVC = (BaseVC *)self.selectedViewController.topViewController;
    
    switch (index) {
        case 0:
        case 3:
            return YES;
            break;
        case 1:
        case 4:
        {
            if ([Coordinator isLogined]) {
                return YES;
            }
            else
            {
                [fromVC startAview];
                [Coordinator ensureLoginFromVC:fromVC successBlock:^{
                    [self setSelectedIndex:index];
                    [fromVC stopAview];
                    ;
                } failBlock:^{
                    [fromVC stopAview];
                } cancelBlock:^{
                    [fromVC stopAview];
                }];
                return NO;
            }
        }
            break;
        case 2:
            return NO;
        default:
            break;
    }
    return NO;

}
- (void)didSelectedIndex:(NSInteger)index
{
    _selectedIndex = index;
    UIViewController *oldVC = _selectedViewController;
    _selectedViewController = _viewControllers[index];
    switch (index) {
        case 0:
        case 1:
        case 3:
        case 4:
        {
            _selectedViewController.view.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height- 50);
            if(!maskView)
            {
                maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_screenWidth, DEVICE_screenHeight)];
                maskView.backgroundColor = [UIColor whiteColor];
            }
            if(oldVC != nil && ![oldVC isEqual:_selectedViewController])
            {
                [self.view insertSubview:maskView belowSubview:_tabBar];
                [self transitionFromViewController:oldVC toViewController:_selectedViewController duration:0 options:UIViewAnimationOptionTransitionNone animations:nil completion:nil];
            }
//            [self.view insertSubview:_selectedViewController.view belowSubview:_tabBar];
        }
            break;
            
        default:
            break;
    }
}
- (void)didSelectedMiddle
{
    [self popPostModule:nil];
}
- (void)hideTabBar
{
    if (self.isHidenTabBar)
        return;
    self.isHidenTabBar = YES;
    float originTop = _tabBar.top;
    UIViewBeginAnimation;
    [_tabBar setTop:originTop + _tabBar.height ];
    [_selectedViewController.view setHeight:_selectedViewController.view.height  + _tabBar.height];
    [UIView commitAnimations];
}
- (void)showTabBar
{
    if (!self.isHidenTabBar)
        return;
    self.isHidenTabBar = NO;
    float originTop = _tabBar.top;
    UIViewBeginAnimation;
    [_tabBar setTop:originTop - _tabBar.height ];
    
    [_selectedViewController.view setHeight:_selectedViewController.view.height  - _tabBar.height];
    [UIView commitAnimations];
}
#pragma mark - 用户交互 弹出照片上传模块
- (void)popPostModule:(id)sender
{
    BaseVC *fromVC = (BaseVC *)((UINavigationController *)self.selectedViewController).topViewController;
    [Coordinator ensureLoginFromVC:fromVC successBlock:^{
    
        [fromVC stopAview];
        [APPDELEGATE.mainVC setSelectedIndex:2];
        [[PostManager shareInstance]envokeUploadModule];
 
    } failBlock:^{
        [fromVC stopAview];
    } cancelBlock:^{
        [fromVC stopAview];
    }];
    
    
}

@end
