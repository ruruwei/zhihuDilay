//
//  myTableCell.h
//  zhihuDemo
//
//  Created by ruru on 16/5/25.
//  Copyright © 2016年 ruru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface myTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *contentimages;
@property (strong, nonatomic) IBOutlet UILabel *contentTitle;
-(id)initWithData:(NSMutableDictionary *)info tableView:tableView;
-(id)initWithDataForfirstCell:(NSMutableDictionary *)info tableView:tableView;
@property (strong, nonatomic) IBOutlet UILabel *typeNameLab;
@property (strong, nonatomic) IBOutlet UIScrollView *slideShowScoll;

@end
