//
//  HomeVC.m
//  DaFenBa
//
//  Created by 胡 帅 on 14-7-24.
//  Copyright (c) 2014年 胡 帅. All rights reserved.
//

#import "HomeVC.h"
#import "NSDate+TimeAgo.h"


@interface HomeVC ()< UIScrollViewDelegate>
{
    HomeContenVC *currentVC;
    UIButton *callBtn;
    NSArray *filterBtns;
}
@end

@implementation HomeVC
@synthesize GoToTheTop;
@synthesize currentVC;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        filterBtns = @[@"filter_boy", @"filter_girl", @"filter_all"];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavBar];
    [self setSwitchView];
    [self setChildViews];
    
 
    
    //返回顶部按钮
    if (GoToTheTop == nil) {
        GoToTheTop = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        GoToTheTop.alpha = 0.5;
        GoToTheTop.layer.cornerRadius = 20;
        GoToTheTop.clipsToBounds = YES;
        GoToTheTop.backgroundColor = [UIColor redColor];
        [GoToTheTop setBottom:DEVICE_screenHeight - 64 - 44 - 20];
        [GoToTheTop setRight:DEVICE_screenWidth - 20];
        [self.view addSubview:GoToTheTop];
        [GoToTheTop setBackgroundImage:[UIImage imageNamed:@"gotoTheTop"] forState:UIControlStateNormal];
       // [GoToTheTop setTitle:@"上" forState:UIControlStateNormal];
        [GoToTheTop addTarget:self action:@selector(scorllToTop) forControlEvents:UIControlEventTouchUpInside];
        GoToTheTop.alpha = 0;
        CGPoint center = GoToTheTop.center;
        [GoToTheTop setSize:CGSizeMake(1, 1)];
        [GoToTheTop setCenter:center];
    }
    


    // Do any additional setup after loading the view from its nib.
}



- (void)viewWillAppear:(BOOL)animated
{
    
    UIView *contentView;
    if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    else
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width,DEVICE_screenHeight);
    
    
    
    self.badge.hidden = YES;
    if ([Coordinator isLogined])
    {
        self.GuangzhuBtn.hidden = YES;
    }
    else
        self.GuangzhuBtn.hidden = NO;
    
    
    [self.view setHeight:DEVICE_screenHeight - 64];
    [self.slideSwitchView setHeight:self.view.height];
    [self.view layoutIfNeeded];
    [self.currentVC.collectionView setHeight:self.currentVC.view.height];

    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated {
    [self setFilterView];
    
    if (![currentVC isKindOfClass:[HomeCategoryGuangzhu class]]) {//非关注栏目时查看关注栏是否有更新
        if ([Coordinator isLogined])
        {
            /*
             * request: {userId: login user id, type: [2], lastReqTime: last request time (server time)}
             * response: {counts: [{type: 2, count: new posts count}], ts: request time}
             */
            LastRefreshTime *lrt = [LastRefreshTime shareInstance];
            NSNumber *lastReqTime = lrt.requestTime_GuangzhuPost;
#ifdef isUseMockData
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                sleep(3);
                if ([lastReqTime isEqual:lrt.requestTime_GuangzhuPost] ) {
                    //lrt.requestTime_GuangzhuPost = ts;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.badge setHidden:NO];
                    });
                }
                
            });
            
#endif
        }
    }

    [super viewDidAppear:animated];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.filterFujingView removeFromSuperview];
    

//    UIView *contentView;
//    if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
//        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
//    else
//        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
//    contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width,DEVICE_screenHeight - 49);
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 私有方法
/**
 *	@brief	设置导航栏
 */
- (void)setNavBar
{
    self.isNeedBackBTN = NO;
    [self setNavTitle:@"打分吧"];
    //    CGRect frame = CGRectMake(20, 5, 40, 34);
    //    UIColor *textColor = ColorRGB(244.0, 149.0, 42.0);
    CGRect frame = CGRectMake(0, 12, 60, 20);
    if (DEVICE_versionAfter7_0) {
        frame.origin.x = 20;
        
    }
    UIColor *textcolor = ColorRGB(244.0, 149.0, 42.0);
    UIView *rightBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    //rightBarView.backgroundColor = [UIColor redColor];
    NSString *title = @"筛选";
    callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    callBtn.frame = frame;
    callBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    
    callBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [callBtn setTitleColor:textcolor forState:UIControlStateNormal];
    [callBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [callBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
    [callBtn setTitle:title forState:UIControlStateNormal];
    [callBtn addTarget:self action:@selector(filterFujing:)forControlEvents:UIControlEventTouchUpInside];
    [callBtn setBackgroundImage:[UIImage imageNamed:@"filter"] forState:UIControlStateSelected];
    [rightBarView addSubview:callBtn];
    [callBtn setAlpha:0];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:rightBarView];
    self.navigationItem.rightBarButtonItem = rightBtn;

}
/**
 *	@brief	调整网络指示器位置
 */
//- (void)ajustAview
//{
//    [super ajustAview];
//    [self.aview setY:self.aview.top - (20 + 44 - 49)/2];
//}
/**
 *	@brief	初始化选项卡视图容器
 */
- (void)setSwitchView
{
    self.slideSwitchView.tabItemNormalColor = [SUNSlideSwitchView colorFromHexRGB:@"868686"];
    self.slideSwitchView.tabItemSelectedColor = [SUNSlideSwitchView colorFromHexRGB:@"bb0b15"];
    self.slideSwitchView.shadowImage = [UIImage imageNamed:@"red_line_and_shadow.png"];
//    CGRect ff = self.slideSwitchView.frame;
//    self.slideSwitchView.frame = CGRectMake(0, 0, DEVICE_screenWidth, DEVICE_screenHeight - 20 - 44);
//    ff = self.slideSwitchView.frame;
}
/**
 *	@brief	初始化tab选项卡下的各子视图
 */
- (void)setChildViews
{
    self.vc1 = [[HomeCategoryTuiJian alloc] init];
    self.vc2 = [[HomeCategoryGuangzhu alloc] init];
    self.vc3 = [[HomeCategoryFujing alloc] init];
    //badge 设为圆角
    UIView *view = self.slideSwitchView.topScrollView.bageGuanzhu;
    view.layer.cornerRadius = view.width / 2;
    view.clipsToBounds = YES;
    
    self.badge = view;
    
    [self.slideSwitchView buildUI];
//    UITapGestureRecognizer *tapFilter = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(filterFujing)];
//    self.slideSwitchView.topScrollView.filterFujing.userInteractionEnabled = YES;
//    [self.slideSwitchView.topScrollView.filterFujing addGestureRecognizer:tapFilter];
}
/**
 *	@brief	加载数据 更新AppDataSource
 */
/*
- (void)refresh
{
    [self startAview];
    self.view.userInteractionEnabled = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        sleep(5);
        
        NSMutableArray *dataSource = [NSMutableArray arrayWithCapacity:0];
        
        for (int i = 0; i < 200; i++) {
            HomeContentModel *aContentModel = [[HomeContentModel alloc]init];
            aContentModel.headIcon = @"headIcon";
            aContentModel.name     = [NSString stringWithFormat:@"阿美%d",currentVC.requestCurrentPage];
            aContentModel.gender   = YES;
            aContentModel.photo    = @"photo";
            aContentModel.description = @"超喜欢的一条裙子，穿着它就像飞在天上一样，有种莫名的喜悦和憧憬，若是天有情，天亦会开心的笑出声来吧，觉得好看吗，那就给我打个分哦";
            [dataSource addObject:aContentModel];
        }
        APPDELEGATE.appDataSource = dataSource;
        
        //更新当前显示的栏目视图
        dispatch_async(dispatch_get_main_queue(), ^{
        [currentVC.scrollView setContentOffset:CGPointMake(0, 0)];
        [currentVC startPullDownRefreshing];
            self.view.userInteractionEnabled = YES;
            [self stopAview];
        });
        
    });
}*/
/**
 *	@brief	初始化附近选择菜单
 */
- (void)setFilterView;
{
    self.filterFujingView.clipsToBounds = YES;
    [self.filterFujingView setFrame:CGRectMake(6, 48, 309, 108)];
    [self.tabBarController.view addSubview:self.filterFujingView];
    [self.filterFujingView setHeight:0];
    for (int index = 0; index < [filterBtns count]; index++) {
        UIButton *btn = (UIButton *)[self.filterFujingView viewWithTag:index +100 ];
       
        [btn setBackgroundImage:[UIImage imageNamed:STRING_joint(filterBtns[index], @"_selected")] forState:UIControlStateSelected];
        if (index == 2) {
            [btn setSelected:YES];
        }
    }

}
/**
 *	@brief	弹出附近选择菜单
 */
- (void)filterFujing:(UIButton *)sender
{
  
    UIViewBeginAnimation;
    [self.filterFujingView setHeight:108];
    //[self.filterFujingView setAlpha:1];
    
    [UIView commitAnimations];}
/**
 *	@brief	确定过滤附近条件
 *
 *	@param 	sender 	按钮
 */
- (IBAction)filerFujingFinished:(id)sender
{
    
    UIViewBeginAnimation;
    [self.filterFujingView setHeight:0];
   // [self.filterFujingView setAlpha:0];

    [UIView commitAnimations];
    for (int index = 0; index < [filterBtns count]; index++) {
        UIButton *btn = (UIButton *)[self.filterFujingView viewWithTag:index+100];
        [btn setSelected:NO];
    }
    [sender setSelected:YES];

}




#pragma mark - slideSwitchView Delegate

- (NSUInteger)numberOfTab:(SUNSlideSwitchView *)view
{
    return 3;
}

- (UIViewController *)slideSwitchView:(SUNSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    if (number == 0) {
        return self.vc1;
    } else if (number == 1) {
        return self.vc2;
    } else if (number == 2) {
        return self.vc3;
    } else {
        return nil;
    }
}


- (void)slideSwitchView:(SUNSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    HomeContenVC *vc = nil;
    CGPoint point = callBtn.center;
    UIViewBeginAnimation;
    [callBtn setAlpha:0];
    [callBtn setWidth:60];
    [callBtn setHeight:2];
    callBtn.center = point;
    [UIView commitAnimations];

    //[self.filterFujingView setHidden:YES];
    [self.filterFujingView setHeight:0];
    //[self.filterFujingView setAlpha:0];
    if (number == 0) {
        vc = self.vc1;
        
    } else if (number == 1) {
        
        vc = self.vc2;
        
    } else if (number == 2) {
        vc = self.vc3;
        
        UIViewBeginAnimation;
        [callBtn setAlpha:1];
        [callBtn setHeight:20];
        [callBtn setWidth:60];
        [callBtn setCenter:point];
        [UIView commitAnimations];
    }
    if (number != 1) {//非关注栏目时查看关注栏是否有更新
        if ([Coordinator isLogined])
        {
        /*
         * request: {userId: login user id, type: [2], lastReqTime: last request time (server time)}
         * response: {counts: [{type: 2, count: new posts count}], ts: request time}
         */
            LastRefreshTime *lrt = [LastRefreshTime shareInstance];
            NSNumber *lastReqTime = lrt.requestTime_GuangzhuPost;
#ifdef isUseMockData
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                sleep(3);
                    if ([lastReqTime isEqual:lrt.requestTime_GuangzhuPost] ) {
                        //lrt.requestTime_GuangzhuPost = ts;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.badge setHidden:NO];
                        });
                    }
                
            });

#endif

//            UserProfile *userProfile = [Coordinator userProfile];
//            
//            NSNumber *userId = userProfile.userId;
//
//            NSDictionary *para = @{@"userId" : userId, @"type" : @2, @"lastReqTime" : lastReqTime};
//            
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                NSDictionary *resultObject = [self.netAccess passUrl:PostModule_count andParaDic:para withMethod:PostModule_count_method andRequestId:PostModule_count_tag thenFilterKey:nil useSyn:YES dataForm:0];
//                NSDictionary *result = resultObject[@"result"];
//                if (NETACCESS_Success) {
//                    NSNumber *ts = resultObject[@"ts"];
//                    if ([lastReqTime isEqual:lrt.requestTime_GuangzhuPost] && [resultObject[@"counts"][@"count"] intValue] > 0) {
//                            lrt.requestTime_GuangzhuPost = ts;
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [self.badge setHidden:NO];
//                        });
//                    }
//                }
//            });
//            
        }
    }
    
    [[GalleryManager shareInstance]setSelectedIndex:number];
    currentVC = vc;
    
    vc.refreshControlDelegate = vc;
    
    UIViewController<MainModuleDelegate> *mainVC = APPDELEGATE.mainVC;
    [mainVC showTabBar];
    [self.view setHeight:DEVICE_screenHeight - 64];
    [self.slideSwitchView setHeight:self.view.height];
    [self.view layoutIfNeeded];
    [self.currentVC.collectionView setHeight:self.currentVC.view.height];
    [vc viewDidCurrentView];
    
    //    [mainVC.view layoutIfNeeded];
//    [self.currentVC.scrollView setHeight:self.view.height];
//
//    [vc.view setHeight:DEVICE_screenHeight - 64];
//    // Layout
//    float curHeight = APPDELEGATE.mainVC.tabBar.top;
//    if(curHeight == DEVICE_screenHeight - 49)
//    {
//        [self.view setHeight:DEVICE_screenHeight - 64 - 49];
//        [self.view layoutIfNeeded];
//        [self.currentVC.scrollView setHeight:self.currentVC.view.height];
//        self.GoToTheTop.alpha = 0;
//        CGPoint center = self.GoToTheTop.center;
//        [self.GoToTheTop setSize:CGSizeMake(1, 1)];
//        [self.GoToTheTop setCenter:center];
//    }
//    else
//    {
//        [self.view setHeight:DEVICE_screenHeight - 64];
//        [self.view layoutIfNeeded];
//        [self.currentVC.scrollView setHeight:self.currentVC.view.height];
//        self.GoToTheTop.alpha = 0;
//        CGPoint center = self.GoToTheTop.center;
//        [self.GoToTheTop setSize:CGSizeMake(40, 40)];
//        [self.GoToTheTop setCenter:center];
//
//    }
}

#pragma mark - /点击滚至顶部
- (void)scorllToTop
{
    [currentVC.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];

}
#pragma mark - 确认登录权限
- (IBAction)ensureLogin:(id)sender {
    [self startAview];
    [Coordinator ensureLoginFromVC:self successBlock:^{
        UIButton *btn = (UIButton *)[self.slideSwitchView.topScrollView viewWithTag:101];
        [self.slideSwitchView selectNameButton:btn];
        [self stopAview];
    } failBlock:^{
        [self stopAview];
    } cancelBlock:^{
        [self stopAview];
    }];
}

- (IBAction)hideWizardView:(id)sender
{
    self.wizardView.hidden = YES;
}
@end
