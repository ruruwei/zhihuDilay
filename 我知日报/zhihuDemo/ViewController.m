//
//  ViewController.m
//  zhihuDemo
//
//  Created by ruru on 16/5/25.
//  Copyright © 2016年 ruru. All rights reserved.
//

#import "ViewController.h"
#import <CommonCrypto/CommonDigest.h>


@interface ViewController ()

@end

@implementation ViewController{
    NSMutableArray *dataArray;
    NSMutableDictionary *dataDic;
    NSMutableArray *listDataArray;
    NSDictionary *listDataDict;
    NSString *dataChangeStr;
    int kimageCount;
    NSTimer *timer;
    int count;
    NSString *tpyeNameStr;
    UIScrollView *slideShow;
    UILabel * tpyeNameC;
    UIPageControl *pageControl;
    BOOL isLoading;
    int dateIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];//隐藏导航栏

    [self initData];
    [self addGesture];
    slideShow.contentSize=CGSizeMake(kimageCount*self.view.frame.size.width, 0);
    slideShow.delegate=self;
    pageControl.numberOfPages=kimageCount;
    [pageControl addTarget:self action:@selector(pageChange:) forControlEvents:UIControlEventValueChanged];

#pragma mark===加载listView
    NSArray * arr = [[NSBundle mainBundle] loadNibNamed:@"listView" owner:self options:nil];
    self.listView = arr[0];
    CGRect frame = self.listView.frame;
    frame.origin.y =0;
    frame.origin.x = 0;
    self.listView.frame = frame;
    [self.view addSubview:self.listView];
    self.listView.alpha = 0;
    
}
-(void)initData{
    dateIndex=1;
    dataDic=[[NSMutableDictionary alloc]init];
    dataArray=[[NSMutableArray alloc]init];
    listDataArray=[[NSMutableArray alloc]init];
    listDataDict=[[NSDictionary alloc]init];
    kimageCount=3;
    count=0;
    isLoading=NO;
    self.listView.hidden=YES;
}
-(void)viewDidAppear:(BOOL)animated{
    [self setupTimer];
}
-(void)viewWillAppear:(BOOL)animated{
    self.loadingIcon.hidden=YES;
    self.refreshIco.hidden=YES;
    self.networkErrortipLab.hidden=YES;

    [self homeObtainData];
    [self listObtainData];
    self.ListTableView.delegate=self;
    self.ListTableView.dataSource=self;
    self.homeListTableView.delegate=self;
    self.homeListTableView.dataSource=self;
}
#pragma mark===刷新数据
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{//即将停止滚动事件方法（拖拽松开后开始减速时执行）
    if (isLoading){
        return;
    }
    //a?b:c  条件表达式,表示如果a为真,则表达式值为b,如果a为假,则表达式值为c
    float height=scrollView.contentSize.height>=self.homeListTableView.frame.size.height?self.homeListTableView.frame.size.height : scrollView.contentSize.height;
    float slideOffset=height-scrollView.contentSize.height + scrollView.contentOffset.y;
    if (slideOffset/height > 0.1) {
        [self refreshPushUp];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (-scrollView.contentOffset.y / self.homeListTableView.frame.size.height > 0.2) {
        [self refreshDropDown];
    }
}
-(void)refreshPushUp{
    NSDate *beforeDate = [NSDate dateWithTimeIntervalSinceNow:-(dateIndex*24*60*60)];
    NSLog(@"date%@",beforeDate);
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMdd"];
    NSString *beforeDateStr=[dateformatter stringFromDate:beforeDate];
    NSLog(@"beforeDate:%@",beforeDateStr);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
 //    self.loadingIcon.hidden=NO;
//    [self.loadingIcon startAnimating];//上拉刷新
    NSString *LinkStr=[NSString stringWithFormat:@"http://news-at.zhihu.com/api/3/stories/before/%@",beforeDateStr];
    [Common initWithDate:LinkStr finishedLoad:^(NSDictionary *HomeDataDic) {
        NSArray *array=[HomeDataDic objectForKey:@"stories"];
        for (int i; i<array.count; i++) {
            NSDictionary *dic=array[i];
            isLoading=YES;
            [dataArray addObject:dic];
        }
        dateIndex++;
        isLoading=NO;
        [self.homeListTableView reloadData];//回调或者说是通知主线程刷新，
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }];
}
-(void)refreshDropDown{
//    [self loadData];
    self.refreshIco.hidden=NO;
    [self.refreshIco startAnimating];
    isLoading=YES;
    [dataArray removeAllObjects];
    NSLog(@"dataChStr=%@",dataChangeStr);
    NSString *LinkStr=[NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/theme/%@",dataChangeStr];
    [Common initWithDate:LinkStr finishedLoad:^(NSDictionary *HomeDataDic) {
        dataArray=[[HomeDataDic objectForKey:@"stories"]mutableCopy];
        tpyeNameStr=[HomeDataDic objectForKey:@"name"];
            [self.homeListTableView reloadData];//回调或者说是通知主线程刷新，
            [self.refreshIco stopAnimating];
            isLoading=NO;
            self.refreshIco.hidden=YES;
            dateIndex=1;
    }];
    NSLog(@"dataArr==%@",dataArray);

}
#pragma mark====加载数据
-(void)listObtainData{
    NSString *ListUrl=[[NSString alloc]initWithFormat:@"http://news-at.zhihu.com/api/4/themes"];

    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[[NSURL alloc] initWithString:@"hostname"]];
    [manager GET:ListUrl parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             listDataArray=[responseObject valueForKey:@"others"];
             [self.ListTableView reloadData];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             self.networkErrortipLab.hidden=NO;
             NSLog(@"%@", error);
         }];
}
-(void)homeObtainData{
    [dataArray removeAllObjects];
    if (!dataChangeStr) {
        dataChangeStr=@"11";
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSLog(@"dataChStr=%@",dataChangeStr);
    NSString *LinkStr=[NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/theme/%@",dataChangeStr];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[[NSURL alloc] initWithString:@"hostname"]];
    [manager GET:LinkStr parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             dataArray=[[responseObject objectForKey:@"stories"]mutableCopy];
             tpyeNameStr=[responseObject objectForKey:@"name"];
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [self.homeListTableView reloadData];//回调或者说是通知主线程刷新，
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"%@", error);
             self.networkErrortipLab.hidden=NO;
             [MBProgressHUD hideHUDForView:self.view animated:YES];
         }];
}
-(void)firstRowData{
    tpyeNameC.text=tpyeNameStr;
    for (int i=0; i<5;i++) {
        NSString *urlImage=[dataArray[i] valueForKey:@"images" ][0];
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:slideShow.bounds];
        [Common loadImage:imageView url:urlImage];
        [slideShow addSubview:imageView];
        CGRect frame=imageView.frame;
        frame.origin.x=count *frame.size.width;
        imageView.frame=frame;
        if (urlImage) {
            count++;
        }
    }
    kimageCount=count;
    pageControl.numberOfPages=count;
}
#pragma mark===绘制tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==500) {
        return dataArray.count;
    }
    if (tableView.tag==501) {
        return listDataArray.count;
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        [timer invalidate];
        count=0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==500) {
        if (indexPath.row==0) {
            static NSString *CellIdentifier=@"CellIdentifier";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"firstRow" owner:self options:nil] lastObject];
            }
            cell.userInteractionEnabled=NO;
            tpyeNameC =[cell viewWithTag:2000];
            slideShow=[cell viewWithTag:2002];
            pageControl=[cell viewWithTag:2001];
            [self firstRowData];
            return cell;
        }else{
            return [[myTableCell alloc]initWithData:dataArray[indexPath.row] tableView:tableView];
        }
    }
    if (tableView.tag==501){
        return [[TpyeListCell alloc]initWithData:listDataArray[indexPath.row] tableView:tableView];
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_homeListTableView) {
        if (indexPath.row==0) {
            return 168;
        }else{
            return 80;
        }
    }else{
        return 50;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==500) {
        count=0;
        [timer invalidate];
        detailsView * detialPage=[[detailsView alloc]init];
        [self.navigationController pushViewController:detialPage animated:YES];
        detialPage.selectIDStr=[dataArray[indexPath.row] valueForKey:@"id"];
        detialPage.idArray=[[NSMutableArray alloc]init];
        detialPage.selectRow=indexPath.row;
        detialPage.homePage = self;
        for (int i;i<dataArray.count; i++) {
            [detialPage.idArray addObject:[dataArray[i] valueForKey:@"id"]];
        }
    }if (tableView.tag==501) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self ListHidden];
        dataChangeStr=[listDataArray[indexPath.row] valueForKey:@"id"];
        [self homeObtainData];
        [self.homeListTableView reloadData];
    }
}
-(NSString *)getNextItem:(int)currentIndex{
    if (currentIndex>=(dataArray.count-1)) {
        NSString *lastIDStr=[[dataArray lastObject] valueForKey:@"id"];
        return lastIDStr;
    }else{
    NSString *nextIDStr=[dataArray[currentIndex+1]valueForKey:@"id"];
    NSLog(@"nextIDStr==%@",nextIDStr);
        return nextIDStr;
    }
}
- (IBAction)goLastPage:(id)sender {
    [self listViewShow];
}
#pragma mark===头部图片slideShow
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    double page=scrollView.contentOffset.x/scrollView.bounds.size.width;
    pageControl.currentPage=page;
}
//初始化定时器
-(void)setupTimer{
    timer=[NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(timerChanged) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
-(void)timerChanged{
    int page=(pageControl.currentPage+1)%kimageCount;
    pageControl.currentPage=page;
    [self pageChange:pageControl];
}
-(void)pageChange:(UIPageControl *)pageCont{
    CGFloat x=(pageCont.currentPage) *slideShow.bounds.size.width;
    [slideShow setContentOffset:CGPointMake(x, 0) animated:YES];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //停止定时器
    [timer invalidate];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self setupTimer];
}
#pragma mark===添加手势
-(void)addGesture{
    /*添加轻扫手势*/
    //注意一个轻扫手势只能控制一个方向，默认向右，通过direction进行方向控制
    UISwipeGestureRecognizer *swipeGestureToRight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(listViewShow)];
    //swipeGestureToRight.direction=UISwipeGestureRecognizerDirectionRight;//默认为向右轻扫
    [self.sildeRangeView addGestureRecognizer:swipeGestureToRight];
    
    UISwipeGestureRecognizer *swipeGestureToLeft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(ListHidden)];
    swipeGestureToLeft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeGestureToLeft];
}
#pragma mark===菜单栏显示隐藏动画
-(void)listViewShow{
    self.listView.hidden=NO;
    self.listView.alpha=0;
    CGRect oldFrame=self.listView.frame;
    oldFrame.origin.x-=200;
    self.listView.frame=oldFrame;
    [UIView animateWithDuration:0.2 animations:^{
        self.listView.alpha=1;
        CGRect oldFrame=self.listView.frame;
        oldFrame.origin.x+=200;
        self.listView.frame=oldFrame;
    }];
    self.homeListTableView.userInteractionEnabled=NO;
    [timer invalidate];
}
-(void)ListHidden{
    [self setupTimer];
    [UIView animateWithDuration:0.2 animations:^{
        self.listView.alpha=0;
        CGRect oldFrame=self.listView.frame;
        oldFrame.origin.x-=200;
        self.listView.frame=oldFrame;
    } completion:^(BOOL finished) {
        CGRect oldFrame=self.listView.frame;
        oldFrame.origin.x+=200;
        self.listView.frame=oldFrame;
    }];
    self.homeListTableView.userInteractionEnabled=YES;
    count=0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
