//
//  ViewController.h
//  zhihuDemo
//
//  Created by ruru on 16/5/25.
//  Copyright © 2016年 ruru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myTableCell.h"
#import "detailsView.h"
#import "Common.h"
#import "TpyeListCell.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
//#import "UIKit+AFNetworking.h"


@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *homeListTableView;
@property (strong, nonatomic) NSString *listSeIDstr;
- (IBAction)goLastPage:(id)sender;
-(NSDictionary *)getNextItem:(int)currentIndex;

@property (strong, nonatomic) IBOutlet UIView *listView;
@property (strong, nonatomic) IBOutlet UITableView *ListTableView;
@property (strong, nonatomic) IBOutlet UIView *sildeRangeView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIcon;
@property (assign,nonatomic) NSInteger selectRow;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *refreshIco;
@property (strong, nonatomic) IBOutlet UILabel *networkErrortipLab;


@end

