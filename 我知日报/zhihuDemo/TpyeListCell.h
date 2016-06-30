//
//  TpyeListCell.h
//  zhihuDemo
//
//  Created by ruru on 16/5/26.
//  Copyright © 2016年 ruru. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TpyeListCellDelegate
-(void)finished:(NSString *)info;
@end

@interface TpyeListCell : UITableViewCell

@property (assign,nonatomic) id ss;
@property (strong, nonatomic) IBOutlet UILabel *tpyeListLab;
@property (strong, nonatomic) IBOutlet UIImageView *imageVie;
-(id)initWithData:(NSMutableDictionary *)info tableView:(id)tableView;

@end
