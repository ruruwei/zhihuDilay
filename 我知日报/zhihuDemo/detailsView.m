//
//  detailsView.m
//  zhihuDemo
//
//  Created by ruru on 16/5/25.
//  Copyright © 2016年 ruru. All rights reserved.
//

#import "detailsView.h"

@interface detailsView ()

@end

@implementation detailsView{
    NSString *contentLink;
    int index;
    BOOL isRefreshState;
}
- (void)viewDidLoad {
    self.errorTipLable.hidden=YES;
    [super viewDidLoad];
    isRefreshState=NO;
    self.webView.scrollView.alwaysBounceHorizontal=YES;
    index=(int)self.selectRow;
    NSLog(@"index==%d",index);
    [self addGesture];
    self.webView.scrollView.delegate=self;
    self.webView.delegate=self;
    self.nextLoadingtip.hidden=YES;
    contentLink=[NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/news/%@",self.selectIDStr];
    [self obtainData];
}
-(void)obtainData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[[NSURL alloc] initWithString:@"hostname"]];
    [manager GET:contentLink parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSString *contentStr=[responseObject valueForKey:@"body"];
             NSString * css = @"<style>*{color:#444;}a{color:#f00;text-decoration:none;}img{width:90%;padding:3px;border:1px solid #ddd;}</style>";
             NSString * html = [NSString stringWithFormat:@"%@<body>%@</body>",css,contentStr];
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             self.nextLoadingtip.hidden=YES;
             
             [self.webView loadHTMLString:html baseURL:nil];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             self.errorTipLable.hidden=NO;
             self.errorTipLable.text=@"请检查你的网络是否正常";
             NSLog(@"%@", error);
         }];
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    //a?b:c  条件表达式,表示如果a为真,则表达式值为b,如果a为假,则表达式值为c
    float height=scrollView.contentSize.height>=self.webView.frame.size.height?self.webView.frame.size.height:scrollView.contentSize.height;
    float slideOffset=height-scrollView.contentSize.height + scrollView.contentOffset.y;
    if (slideOffset/height > 0.1) {
        [self refreshData];
        index++;
        NSLog(@"index33==%i",index);
    }
    if (-scrollView.contentOffset.y / self.webView.frame.size.height > 0.2) {
        [self refreshData];
        index--;
        NSLog(@"index44==%i",index);
    }
}
-(void)refreshData{
    
    self.nextLoadingtip.hidden=NO;
    NSString *idStr=[self.homePage getNextItem:index];
    contentLink=[NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/news/%@",idStr];
    //    [self initWithData];
    [self obtainData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)addGesture{
    UISwipeGestureRecognizer *swipeGestureToRight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(goBack:)];
    [self.view addGestureRecognizer:swipeGestureToRight];
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}
- (IBAction)nextBtn:(id)sender {
    [self refreshData];
    index++;
    NSLog(@"index222==%d",index);
}
@end
