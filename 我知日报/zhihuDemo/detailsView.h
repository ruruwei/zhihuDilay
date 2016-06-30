//
//  detailsView.h
//  zhihuDemo
//
//  Created by ruru on 16/5/25.
//  Copyright © 2016年 ruru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "ViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"



@interface detailsView : UIViewController<UIWebViewDelegate,UIScrollViewDelegate>
- (IBAction)goBack:(id)sender;

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong,nonatomic) NSString *selectIDStr;
@property (strong,nonatomic) NSString *nextIDStr;

@property (assign,nonatomic) NSInteger selectRow;
@property (strong,nonatomic) NSMutableArray *idArray;
@property (strong, nonatomic) IBOutlet UILabel *nextLoadingtip;
- (IBAction)nextBtn:(id)sender;
@property (weak,nonatomic) id homePage;
@property (strong, nonatomic) IBOutlet UILabel *errorTipLable;
@end


