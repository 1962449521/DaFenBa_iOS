/*!
 @header BaseCell.h
 @abstract UITableViewCell的自定义超类
 @author 胡帅
 @version 1.0 2014/08 Creation
 */

#import "BaseObject.h"

@interface AllCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imageView1;
@property (nonatomic, weak) IBOutlet UIImageView *imageView2;

@property (nonatomic, weak) IBOutlet UILabel *label1;
@property (nonatomic, weak) IBOutlet UILabel *label2;

@property (nonatomic, weak) IBOutlet UIButton *btn1;
@property (nonatomic, weak) IBOutlet UIButton *btn2;
@property (nonatomic, weak) IBOutlet UIButton *btn3;



/**
 *	@brief	注册NIB文件
 *
 *	@param 	tableView 	cell所在的tableView
 *
 *	@return	由nib文件生成cell对象
 */
+ (AllCell *)cellRegisterNib:(NSString *) cellIdentifier tableView:(UITableView *)tableView;


- (void)setDataSource:(NSDictionary *)dataSource;

@end
