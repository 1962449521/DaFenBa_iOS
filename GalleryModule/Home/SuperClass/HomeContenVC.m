//
//  TuijianVC.m
//  DaFenBa
//
//  Created by 胡 帅 on 14-7-25.
//  Copyright (c) 2014年 胡 帅. All rights reserved.
//

#define cellspace 5.0
#define headspace 5.0
#define homeContentVCAutoDownloadPagesCount 8

#import "HomeVC.h"
#import "HomeContenVC.h"
#import "HomeContentCell.h"
#import "HomeCategoryTuijian.h"
#import "TuiJianSectionHeaderView.h"
#import "WaterFallFooter.h"

#import "ScoreVC.h"


@interface HomeContenVC ()<UIScrollViewDelegate>

@property float leftBottom;//左边瀑布流的底部Y值
@property float rightBottom;//右边瀑布流的底部Y值

@property BOOL isHaveAppeared;

@end

@implementation HomeContenVC
{
    BOOL _isRefreshFinished;
    float oldOffsetY;
    UIView *loadMoreView;
    NSMutableArray *sizeDataSource;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        oldOffsetY = 0;
        sizeDataSource = [NSMutableArray array];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   
    if (!loadMoreView) {
        loadMoreView = self.customRefreshControl.loadMoreView;
        [self.view addSubview:loadMoreView];
        [loadMoreView setTop:DEVICE_screenHeight - 64 - 44 - loadMoreView.height];//64.. 44 topscrollview
    }
    
    //if(scrollView.isDecelerating)return;
    UIViewController<MainModuleDelegate> *mainVC = APPDELEGATE.mainVC;
    HomeVC *homeVC = (HomeVC *)[(UINavigationController *)[APPDELEGATE.mainVC selectedViewController]topViewController];
    
    float newOffsetY;
    if (scrollView.contentOffset.y < 0) {
        newOffsetY = 0;
    }
    else if(scrollView.contentOffset.y > scrollView.contentSize.height - (DEVICE_screenHeight - 64 - 44))
        newOffsetY = scrollView.contentSize.height - (DEVICE_screenHeight - 64 - 44);
    else
        newOffsetY = scrollView.contentOffset.y;
    if (newOffsetY <= 0) {
        [homeVC.GoToTheTop setAlpha:0];
        return;
    }
     //NSLog(@"oldY:%f   newY:%f", oldOffsetY, newOffsetY);
    if (newOffsetY > oldOffsetY + 60 ) {
        //向上
        oldOffsetY = newOffsetY;
        if (mainVC.isHidenTabBar) {
            return;
        }

        [mainVC hideTabBar];
//        [mainVC.view layoutIfNeeded];
//        [self.scrollView setHeight:self.view.height];
        UIViewBeginAnimation;
        homeVC.GoToTheTop.alpha = 0;
        CGPoint center = homeVC.GoToTheTop.center;
        [homeVC.GoToTheTop setSize:CGSizeMake(1, 1)];
        [homeVC.GoToTheTop setCenter:center];
        [UIView commitAnimations];

    }
    else if(newOffsetY < oldOffsetY - 60  ) {
        //向下
        oldOffsetY = newOffsetY;
        if (!mainVC.isHidenTabBar)
        {
            return;
        }
        [mainVC showTabBar];
//        [mainVC.view layoutIfNeeded];
//        [self.scrollView setHeight:self.view.height];
        UIViewBeginAnimation;
        homeVC.GoToTheTop.alpha = 0.3;
        CGPoint center = homeVC.GoToTheTop.center;
        [homeVC.GoToTheTop setSize:CGSizeMake(40, 40)];
        [homeVC.GoToTheTop setCenter:center];
        [UIView commitAnimations];
        
    }
}

#pragma mark - 公共方法
/**
 *	@brief	当视图处于当前选择卡时
 */
- (void)viewDidCurrentView
{
    if (self.pullDownRefreshed && !self.isHaveAppeared) {
        [self setupRefreshControl];
       // if (![self isKindOfClass:[HomeCategoryTuiJian class] ]) {
        // }
        
        [self startPullDownRefreshing];
        self.isHaveAppeared = YES;
        
        
    }
    
}
/**
 *	@brief	数据源
 */
- (void)loadDataSource
{
    
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1.5);
        NSMutableArray *newDataSource = [NSMutableArray arrayWithCapacity:0];
        NSArray *sizeArr =
        @[[NSValue valueWithCGSize:CGSizeMake(600, 903)],
        [NSValue valueWithCGSize:CGSizeMake(800, 571)],
        [NSValue valueWithCGSize:CGSizeMake(413, 567)],
        [NSValue valueWithCGSize:CGSizeMake(640, 960)],
          [NSValue valueWithCGSize:CGSizeMake(310, 230)]];
#ifdef isUseMockData
        for (int i = 0; i < 5; i++) {
            
            PostProfile *postProfile = [PostProfile new];
        
            postProfile.user = [UserProfile new];
            postProfile.user.userId = @1234;
            postProfile.postId = [NSNumber numberWithInt:i];
            postProfile.pic = [NSString stringWithFormat:@"photo%i.jpg", i];
            postProfile.distance = [NSNumber numberWithInt:i*50 +500];
            postProfile.comment = @"超喜欢的一条裙子，穿着它就像飞在天上一样，有种莫名的喜悦和憧憬，若是天有情，天亦会开心的笑出声来吧，觉得好看吗，那就给我打个分哦";
            postProfile.gradeCount = [NSNumber numberWithInt:i+500];
            postProfile.picH = [NSNumber numberWithFloat:[sizeArr[i] CGSizeValue].height];
            postProfile.picW = [NSNumber numberWithFloat:[sizeArr[i] CGSizeValue].width];
            
            
            
                                
            [newDataSource addObject:postProfile];
                                }
#else
#endif
        NSNumber *lastRequestTime = @555;
        
        BOOL isLoadDataFail = NO;
//        if (self.requestCurrentPage == 4 || self.requestCurrentPage == 6)
//            isLoadDataFail = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray *arr = [[[GalleryManager shareInstance]selectedDataSource] mutableCopy];
            if (self.requestCurrentPage)
            {//加载更多
                if (isLoadDataFail)
                    [self handleLoadMoreError];
                else
                {
                    [arr addObjectsFromArray:newDataSource];
                    [self endLoadMoreRefreshing];
                }
            }
            else//刷新
            {
                if ([[GalleryManager shareInstance]selectedIndex] == 1) {//当前栏目是关注栏目
                    HomeVC *homeVC = (HomeVC *)((UINavigationController *)APPDELEGATE.mainVC.selectedViewController).topViewController;
                    [homeVC.badge setHidden:YES];
                    LastRefreshTime *lrq = [LastRefreshTime shareInstance];
                    lrq.requestTime_GuangzhuPost = lastRequestTime;
                    
                }                
                //[self dumpAllContentCell];
                arr = newDataSource;
                [self endPullDownRefreshing];
            }
            [[[GalleryManager shareInstance] selectedDataSource] removeAllObjects];
            [[[GalleryManager shareInstance] selectedDataSource] addObjectsFromArray:arr];
           // NSArray *arr2 = [[GalleryManager shareInstance] selectedDataSource];

            [self.collectionView reloadData];
            
            //首次访问
            HomeVC *homeVC = (HomeVC *)((UINavigationController *)APPDELEGATE.mainVC.selectedViewController).topViewController;
            FirstEnterTime *first = [FirstEnterTime shareInstance];
            [FirstEnterTime getUserDefault];
            if (first.isFirstEnterGalleryPage && [first.isFirstEnterGalleryPage boolValue]) {
                [APPDELEGATE.mainVC.view addSubview:homeVC.wizardView];
                [homeVC.wizardView setX:0];
                [homeVC.wizardView setY:0];
                
                homeVC.wizardView.hidden = NO;
                first.isFirstEnterGalleryPage = @NO;
                [FirstEnterTime storeUserDeault];

            }
            else
            {
                homeVC.wizardView.hidden = YES;
            }            //[currentVC endPullDownRefreshing];
        });
    });
}
//删除所有内容图片
- (void)dumpAllContentCell
{
    
    [[[GalleryManager shareInstance] selectedDataSource] removeAllObjects];
    [self.collectionView reloadData];

}
#pragma mark UICollectionViewDataSource
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *arr = [[GalleryManager shareInstance] selectedDataSource];

    return [arr count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"HomeContentCell";
    UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:[NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:cellIdentifier];
    HomeContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier
                                                     owner:self options:nil];
        
        for (id oneObject in nib) {
            if ([oneObject isKindOfClass:[UICollectionViewCell class]]) {
                cell = oneObject;
                break;
            }
        }
    }
    
    PostProfile *model = [[GalleryManager shareInstance] selectedDataSource][indexPath.row];
    [cell assignValue:model];
    return cell;

}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    PostProfile *model = [[GalleryManager shareInstance] selectedDataSource][indexPath.row];
    [[ScoreManager shareInstance]setIndexWithDataSource:indexPath.row];
    BaseVC *baseVC = (BaseVC *)[APPDELEGATE.mainVC.viewControllers[0] topViewController];
    [[ScoreManager shareInstance]evokeScoreWithPost:model FromVC:baseVC];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = [[GalleryManager shareInstance] selectedDataSource];
    PostProfile *model = arr[indexPath.row];
    float ratio = [model.picH floatValue]/[model.picW floatValue];
    float height = 150.0 * ratio;
    CGSize size = {150, height + 38};
    return size;
}

#pragma mark - XHRefreshControl Delegate

- (void)beginPullDownRefreshing {
    self.requestCurrentPage = 0;
    [self loadDataSource];
    //[currentVC loadDataSource];
}

- (void)beginLoadMoreRefreshing {
    self.requestCurrentPage ++;
    [self loadDataSource];
    
    // [currentVC loadDataSource];
}

- (NSString *)lastUpdateTimeString {
    
    NSDate *nowDate = [NSDate date];
    
    NSString *destDateString = [nowDate timeAgo];
    
    return destDateString;
}
- (BOOL)isPullDownRefreshed {
    return self.pullDownRefreshed;
}
- (BOOL)isLoadMoreRefreshed {
    return self.loadMoreRefreshed;
}
- (XHRefreshViewLayerType)refreshViewLayerType {
    return XHRefreshViewLayerTypeOnScrollViews;
}

- (XHPullDownRefreshViewType)pullDownRefreshViewType {
    return self.refreshViewType;
}

- (NSInteger)autoLoadMoreRefreshedCountConverManual {
    return homeContentVCAutoDownloadPagesCount;
}
- (NSString *)displayAutoLoadMoreRefreshedMessage
{
    return @"查看下二十二条";
}

@end
