//
//  HomeContentView.m
//  DaFenBa
//
//  Created by 胡 帅 on 14-7-25.
//  Copyright (c) 2014年 胡 帅. All rights reserved.
//

#import "HomeContentCell.h"

@implementation HomeContentCell
{
    UIView *hitView;
    BOOL isClick;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    hitView = [super hitTest:point withEvent:event];
//    
//    return hitView;
//}
//
//-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//    [super touchesBegan:touches withEvent:event];
//    isClick = YES;
//
//}
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesMoved:touches withEvent:event];
//    isClick = NO;
//    
//}
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesEnded:touches withEvent:event];
//    //UITouch *touch = [touches anyObject];
//    if (!isClick) {
//        return;
//    }
//    if ([hitView isEqual: self.photo]) {
//        
//        NSDictionary *paras = @{@"photo" : self.photo.image,
//                                @"avatar" : self.headIcon.image,
//                                @"userId" : self.userId,
//                                @"userName" :self.name.text,
//                                @"photoIntro" : self.photoIntro};
//        BaseVC *fromeVC = (BaseVC *)((UINavigationController *)APPDELEGATE.mainVC.selectedViewController).topViewController;
//        [[ScoreManager shareInstance]setIndexWithDataSource:self.indexWinthDataSource];
//        [[ScoreManager shareInstance]evokeScoreWithParas:paras FromVC:fromeVC];
//
//    }
//    else if([hitView isEqual:self.headIcon]
//            || [hitView isEqual:self.name])
//    {
//        POPUPINFO(@"name or avatar clicked");
//    }
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
//{
//}

#pragma mark - assign Value
- (void)assignValue:(PostProfile *)contentModel
{
    self.userId = @"123433";
    //NSString *str = contentModel.photo;
    float ratio = [contentModel.picH floatValue]/[contentModel.picW floatValue];
    float height = 150.0 * ratio;
    CGSize size = {150, height};
    [self.photo setSize:size];
    self.photo.clipsToBounds = YES;
//    [self.photo setPost:contentModel.photo];
    [self.photo setImage:[UIImage imageNamed:contentModel.pic]];
    [self.scoreView setBottom:self.photo.bottom];
    self.distanceLabel.text = STRING_joint(STRING_fromInt([contentModel.distance intValue]), @"米");
    self.gradeCountLabel.text =STRING_joint(STRING_fromInt([contentModel.gradeCount intValue]), @"人打分");
    [self.descriptionLabel setY:self.scoreView.bottom + 5.0];
    NSString *desStr = contentModel.comment;
    //    self.photoIntro = [NSString stringWithString:desStr];
    //    CGSize newSize = CGSizeMake(self.descriptionLabel.width, 200);
    //    while ([desStr sizeWithFont:self.descriptionLabel.font constrainedToSize: newSize].height > self.descriptionLabel.height/2){
    //        desStr = [desStr substringToIndex:desStr.length - 1];
    //    }
    //    NSString *desStr2 = [contentModel.description substringToIndex:desStr.length + 6];
    //    self.descriptionLabel.text = STRING_joint(desStr2, @"...");
    self.descriptionLabel.text = desStr;
    
    
    
        self.layer.borderColor = [TheMeBorderColor CGColor];
        self.layer.borderWidth = 1.0;
    [self setHeight:self.descriptionLabel.bottom + 5.0];
    

    
}
@end
