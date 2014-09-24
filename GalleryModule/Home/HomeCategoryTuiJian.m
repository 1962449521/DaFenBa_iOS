//
//  HomeCategoryTuiJian.m
//  DaFenBa
//
//  Created by 胡 帅 on 14-7-26.
//  Copyright (c) 2014年 胡 帅. All rights reserved.
//

#import "HomeCategoryTuiJian.h"
#import "TuiJianSectionHeaderView.h"
#import "WaterFallFooter.h"
@interface HomeCategoryTuiJian ()

@end

@implementation HomeCategoryTuiJian

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.collectionView registerClass:[TuiJianSectionHeaderView class]  forSupplementaryViewOfKind:@"TuiJianSectionHeaderView" withReuseIdentifier:@"TuiJianSectionHeaderView"];
    
    // self.collectionView.collectionViewLayout.headerReferenceSize = CGSizeMake(300.0f, 50.0f);
    // Do any additional setup after loading the view.
}
- (void)viewDidCurrentView
{
    [super viewDidCurrentView];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - dataSource
/**
 *	@brief	数据源
 */
//- (void)loadDataSource
//{
//    /*
//     * list: GET
//     ** request: {userId: login user id, type: 1, gender: 1, longitude: request longitude, latitude: request latitude, , pager:{pageNumber: 2, pageSize: 20}, lastRefreshTime: last refresh time for access first page} // type => 0: all, 1: recommend?, 2: following, 3: nearby; gender => 1: male, 2: female, no gender => all; distance: m
//     */
//    NSNumber *userId = [[MemberManager shareInstance]userProfile].userId;
//    
//    
//}

#pragma mark ADD Header AND Footer
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section
{
    return 286;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    HSLog(@"collectionViewCell draw begin!row:%i", indexPath.row);
    UICollectionReusableView *reusableView ;
    if ([kind isEqualToString:WaterFallSectionHeader])
    {
        UINib *nib = [UINib nibWithNibName:@"TuiJianSectionHeaderView" bundle:[NSBundle mainBundle]];
        [collectionView registerNib:nib forSupplementaryViewOfKind:WaterFallSectionHeader withReuseIdentifier:WaterFallSectionHeader];
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:WaterFallSectionHeader
                                                                 forIndexPath:indexPath];
        if(reusableView == nil)
            reusableView = (UICollectionReusableView *)[[[NSBundle mainBundle]loadNibNamed:@"TuiJianSectionHeaderView" owner:self options:nil]lastObject];
    }
    else if ([kind isEqualToString:WaterFallSectionFooter])
    {
        [collectionView registerClass:[WaterFallFooter class] forSupplementaryViewOfKind:WaterFallSectionFooter withReuseIdentifier:WaterFallSectionFooter];
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:WaterFallSectionFooter forIndexPath:indexPath];
    }
    return reusableView;
    HSLog(@"collectionViewCell draw begin!");
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
