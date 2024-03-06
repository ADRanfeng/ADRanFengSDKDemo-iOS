//
//  ADRanFengNativeAdViewController.m
//  ADRanFengSDKDemo-iOS
//
//  Created by 陈则富 on 2021/9/14.
//

#import "ADRanFengNativeAdViewController.h"
#import "ADRanFengNativeTableViewCell.h"
#import <ADRanFengSDK/ADRanFengExpressViewRegisterProtocol.h>
#import <ADRanFengSDK/ADRanFengNativeExpressAd.h>
#import <ADRanFengSDK/ADRanFengNativeExpressView.h>
#import <ADRFMediationKit/ADRFMediationKit.h>
#import <MJRefresh/MJRefresh.h>
#import "UIView+Toast.h"
#import "AdsPosId.h"


@interface ADRanFengNativeAdViewController ()<UITableViewDelegate, UITableViewDataSource,ADRanFengNativeExpressAdDelegate>
{
    NSMutableArray <UIView<ADRanFengExpressViewRegisterProtocol> *>*_adViewArray;
    BOOL _isNormalAd;
    BOOL _isReady;
}

@property (nonatomic ,strong) ADRanFengNativeExpressAd  *nativeAd;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, copy) NSString *posId;

@property (nonatomic, copy) NSString *bidPosId;

@end

@implementation ADRanFengNativeAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isNormalAd = YES;
    
    UIButton *setAdConfigBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [setAdConfigBtn setTitle:@"切换" forState:(UIControlStateNormal)];
    [setAdConfigBtn setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
    setAdConfigBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    setAdConfigBtn.frame = CGRectMake(0, 0, 50, 20);
    [setAdConfigBtn addTarget:self action:@selector(showTypeSelect) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:setAdConfigBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    // Do any additional setup after loading the view.
    [self setUI];
    
    _nativeAd = [[ADRanFengNativeExpressAd alloc]initWithAdSize:CGSizeMake(UIScreen.mainScreen.bounds.size.width, 10)];
    _nativeAd.delegate = self;
    self.posId = normal_nativeAdExpress_posId;
    self.bidPosId = bid_nativeAdExpress_posId;
    _nativeAd.controller = self;
    
    _adViewArray = [NSMutableArray new];
    
    CGFloat margin = self.view.bounds.size.width/5 - 320/5;
    
    UIButton *loadAndShowBtn = [UIButton new];
    [loadAndShowBtn setTitle:@"普通请求" forState:(UIControlStateNormal)];
    [loadAndShowBtn setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
    loadAndShowBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    loadAndShowBtn.backgroundColor = UIColor.lightGrayColor;
    loadAndShowBtn.clipsToBounds = YES;
    loadAndShowBtn.layer.cornerRadius = 3;
    [loadAndShowBtn addTarget:self action:@selector(loadNomarlAd) forControlEvents:(UIControlEventTouchUpInside)];
    loadAndShowBtn.frame = CGRectMake(margin, self.view.bounds.size.height - 60, 80, 30);
    [self.view addSubview:loadAndShowBtn];
    [self.view bringSubviewToFront:loadAndShowBtn];
    
    
    
    UIButton *loadBtn = [UIButton new];
    [loadBtn setTitle:@"竞价请求" forState:(UIControlStateNormal)];
    [loadBtn setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
    loadBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    loadBtn.backgroundColor = UIColor.lightGrayColor;
    loadBtn.clipsToBounds = YES;
    loadBtn.layer.cornerRadius = 3;
    [loadBtn addTarget:self action:@selector(loadBidAd) forControlEvents:(UIControlEventTouchUpInside)];
    loadBtn.frame = CGRectMake(margin*2 + 80, self.view.bounds.size.height - 60, 80, 30);
    [self.view addSubview:loadBtn];
    [self.view bringSubviewToFront:loadBtn];
    
    UIButton *bidWinBtn = [UIButton new];
    [bidWinBtn setTitle:@"竞价成功" forState:(UIControlStateNormal)];
    [bidWinBtn setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
    bidWinBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    bidWinBtn.backgroundColor = UIColor.lightGrayColor;
    bidWinBtn.clipsToBounds = YES;
    bidWinBtn.layer.cornerRadius = 3;
    [bidWinBtn addTarget:self action:@selector(bidWin) forControlEvents:(UIControlEventTouchUpInside)];
    bidWinBtn.frame = CGRectMake(160 + margin*3, self.view.bounds.size.height - 60, 80, 30);
    [self.view addSubview:bidWinBtn];
    [self.view bringSubviewToFront:bidWinBtn];
    
    UIButton *bidFailBtn = [UIButton new];
    [bidFailBtn setTitle:@"竞价失败" forState:(UIControlStateNormal)];
    [bidFailBtn setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
    bidFailBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    bidFailBtn.backgroundColor = UIColor.lightGrayColor;
    bidFailBtn.clipsToBounds = YES;
    bidFailBtn.layer.cornerRadius = 3;
    [bidFailBtn addTarget:self action:@selector(bidFail) forControlEvents:(UIControlEventTouchUpInside)];
    bidFailBtn.frame = CGRectMake(margin*4 + 240, self.view.bounds.size.height - 60, 80, 30);
    [self.view addSubview:bidFailBtn];
    [self.view bringSubviewToFront:bidFailBtn];
    
}

- (void)loadNomarlAd {
    _isNormalAd = YES;
    _isReady = NO;
    _nativeAd.posId = self.posId;
    [_nativeAd loadAdWithCount:3];
}

- (void)loadBidAd {
    _isNormalAd = NO;
    _isReady = NO;
    _nativeAd.posId = self.bidPosId;
    [_nativeAd loadAdWithCount:3];
}

- (void)bidWin {
    if (_isNormalAd) {
        [self.view makeToast:@"当前广告不是竞价广告"];
        return;
    }
    if (_isReady && _nativeAd) {
        for (UIView<ADRanFengExpressViewRegisterProtocol> *adView in _adViewArray) {
            [_nativeAd sendWinNotificationWithAdView:adView price:adView.bidFloor];
            [adView ranfeng_registViews:@[adView]];
            ADRfAsyncMainBlock(^{
                [self->_adViewArray removeObject:adView];
            });
        }
        return;
    }
    [self.view makeToast:@"广告未准备好"];
}

- (void)bidFail {
    if (_isNormalAd) {
        [self.view makeToast:@"当前广告不是竞价广告"];
        return;
    }
    if (_isReady && _nativeAd) {
        for (UIView<ADRanFengExpressViewRegisterProtocol> *adView in _adViewArray) {
            [self.nativeAd sendWinFailNotificationReason:(ADRanFengBiddingLossReasonOther) winnerPirce:100 AdView:adView];
            [adView ranfeng_registViews:@[adView]];
            ADRfAsyncMainBlock(^{
                [self->_adViewArray removeObject:adView];
            });
        }
        return;
    }
    [self.view makeToast:@"广告未准备好"];
}

- (void)setUI{
    _items = [NSMutableArray new];
    
    _tableView = [UITableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerClass:[ADRanFengNativeTableViewCell class] forCellReuseIdentifier:@"adcell"];
    [self.view addSubview:_tableView];
    _tableView.frame = self.view.bounds;
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf cleanAllAd];
//        [weakSelf.nativeAd loadAdWithCount:3];
    }];

    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf.nativeAd loadAdWithCount:3];
    }];
    
//    [self.tableView.mj_header beginRefreshing];
}

- (void)showTypeSelect {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"" message:@"选择信息流类型" preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *expressType = [UIAlertAction actionWithTitle:@"模板" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self cleanAllAd];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.posId = normal_nativeAdExpress_posId;
            self.bidPosId = bid_nativeAdExpress_posId;
        });
    }];
    UIAlertAction *nativeType = [UIAlertAction actionWithTitle:@"自渲染" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self cleanAllAd];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.posId = normal_nativeAd_posId;
            self.bidPosId = bid_nativeAd_posId;
        });
        
    }];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alertVc addAction:expressType];
    [alertVc addAction:nativeType];
    [alertVc addAction:cancle];
    [self presentViewController:alertVc animated:YES completion:nil];
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id item = [_items objectAtIndex:indexPath.row];
    if([item isKindOfClass:[ADRanFengNativeExpressView class]]) {
        return [(UIView *)item frame].size.height;
    } else {
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if([cell isKindOfClass:[ADRanFengNativeTableViewCell class]]) {
        [(ADRanFengNativeTableViewCell *)cell setAdView:nil];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id item = [_items objectAtIndex:indexPath.row];
    if([item isKindOfClass:[ADRanFengNativeExpressView class]]) {
        ADRanFengNativeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"adcell" forIndexPath:indexPath];
        cell.adView = item;
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = [NSString stringWithFormat:@"ListViewitem %ld", indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)cleanAllAd {
    [_adViewArray removeAllObjects];
    [_items removeAllObjects];
    _items = [NSMutableArray new];
    [self.tableView reloadData];
}

#pragma mark - ADRanFengNativeExpressAdDelegate

// 模板信息流广告加载成功
- (void)ranfengExpressAdSucceedToLoad:(ADRanFengNativeExpressAd *)expressAd views:(NSArray<__kindof UIView<ADRanFengExpressViewRegisterProtocol> *> *)views {
    _isReady = YES;
    for (ADRanFengNativeExpressView *adView in views) {
        if (adView.renderType == ADRanFengRenderTypeNative) {
            [self setUpUnifiedTopImageNativeAdView:adView];
        }
        if (_isNormalAd) {
            [adView ranfeng_registViews:@[adView]];
        }
        else {
            [_adViewArray addObject:adView];
            [self.view makeToast:[NSString stringWithFormat:@"该信息流广告价格：%ld",adView.bidPrice]];
        }
    }
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

// 模板信息流广告加载失败
- (void)ranfengExpressAdFailToLoad:(ADRanFengNativeExpressAd *)expressAd error:(NSError *)error {
    NSLog(@"信息流广告加载失败%@",error);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    });
}

// 模板信息流广告渲染成功
- (void)ranfengExpressAdRenderSucceed:(ADRanFengNativeExpressAd *)expressAd adView:(UIView<ADRanFengExpressViewRegisterProtocol> *)expressAdView {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i = 0; i < 6; i ++) {
            [self.items addObject:[NSNull null]];
        }
        [self.items addObject:expressAdView];
        NSLog(@"当前广告=====%@",self.items);
        [self.tableView reloadData];
    });
}

// 模板信息流广告渲染失败
- (void)ranfengExpressAdRenderFail:(ADRanFengNativeExpressAd *)expressAd error:(NSError *)error {
    [self.view makeToast:[NSString stringWithFormat:@"信息流渲染失败：%@",error]];
}

// 模板信息流广告关闭
- (void)ranfengExpressAdClosed:(ADRanFengNativeExpressAd *)expressAd adView:(UIView<ADRanFengExpressViewRegisterProtocol> *)expressAdView {
    [self.items removeObject:expressAdView];
    [self.tableView reloadData];
}

// ，模板信息流广告点击
- (void)ranfengExpressAdClick:(ADRanFengNativeExpressAd *)expressAd adView:(UIView<ADRanFengExpressViewRegisterProtocol> *)expressAdView {
    
}


// ，模板信息流广告展示
- (void)ranfengExpressAdDidExpourse:(ADRanFengNativeExpressAd *)expressAd adView:(UIView<ADRanFengExpressViewRegisterProtocol> *)expressAdView {
    
}

/**
 *以下为视频信息流相关回调
 */

/**
 模板信息流视频广告开始播放
 */
- (void)ranfengExpressAdVideoPlay:(ADRanFengNativeExpressAd *)expressAd adView:(UIView<ADRanFengExpressViewRegisterProtocol> *)expressAdView {
    NSLog(@"视频信息流播放");
}

/**
 模板信息流视频广告视频播放失败
 */
- (void)ranfengExpressAdVideoPlayFail:(ADRanFengNativeExpressAd *)expressAd adView:(UIView<ADRanFengExpressViewRegisterProtocol> *)expressAdView error:(NSError *)error {
    NSLog(@"视频信息流播放失败，%@",error);
}

/**
 模板信息流视频广告视频暂停
 */
- (void)ranfengExpressAdVideoPause:(ADRanFengNativeExpressAd *)expressAd adView:(UIView<ADRanFengExpressViewRegisterProtocol> *)expressAdView {
    NSLog(@"视频信息流播放暂停");
}

/**
 模板信息流视频广告视频播放完成
 */
- (void)ranfengExpressAdVideoFinish:(ADRanFengNativeExpressAd *)expressAd adView:(UIView<ADRanFengExpressViewRegisterProtocol> *)expressAdView {
    NSLog(@"视频信息流播放完成");
}

/**
 关闭落地页
 */
- (void)ranfengExpressAdDidCloseLandingPage:(ADRanFengNativeExpressAd *)expressAd adView:(UIView<ADRanFengExpressViewRegisterProtocol> *)expressAdView {
    
}

// 3、上图下文样式
- (void)setUpUnifiedTopImageNativeAdView:(UIView<ADRanFengExpressViewRegisterProtocol> *)adView {
    // 设计的adView实际大小，其中宽度和高度可以自己根据自己的需求设置
    CGFloat adWidth = self.view.frame.size.width;
    CGFloat adHeight = (adWidth - 17 * 2) / 16.0 * 9 + 70;
    adView.frame = CGRectMake(0, 0, adWidth, adHeight);
    
    // 显示logo图片（必要）
    UIImageView *logoImage = [UIImageView new];
    [adView addSubview:logoImage];
    [adView ranfeng_platformLogoImageDarkMode:NO loadImageBlock:^(UIImage * _Nullable image) {
        CGFloat maxWidth = 40;
        CGFloat logoHeight = maxWidth / image.size.width * image.size.height;
        logoImage.frame = CGRectMake(adWidth - maxWidth, adHeight - logoHeight, maxWidth, logoHeight);
        logoImage.image = image;
    }];
    
    // 设置主图/视频（主图可选，但强烈建议带上,如果有视频试图，则必须带上）
    CGRect mainFrame = CGRectMake(17, 0, adWidth - 17 * 2, (adWidth - 17 * 2) / 16.0 * 9);
    if(adView.adData.isVideoAd) {
        UIView *mediaView = [adView ranfeng_mediaViewForWidth:mainFrame.size.width];
        mediaView.frame = mainFrame;
        [adView addSubview:mediaView];
    } else {
        UIImageView *imageView = [UIImageView new];
        imageView.backgroundColor = [UIColor adrf_colorWithHexString:@"#CCCCCC"];
        [adView addSubview:imageView];
        imageView.frame = mainFrame;
        NSString *urlStr = adView.adData.imageUrl;
        if(urlStr.length > 0) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    imageView.image = image;
                });
            });
        }
    }
    
    // 设置广告标识（可选）
    UILabel *adLabel = [[UILabel alloc]init];
    adLabel.backgroundColor = [UIColor adrf_colorWithHexString:@"#CCCCCC"];
    adLabel.textColor = [UIColor adrf_colorWithHexString:@"#FFFFFF"];
    adLabel.font = [UIFont adrf_PingFangLightFont:12];
    adLabel.text = @"广告";
    [adView addSubview:adLabel];
    adLabel.frame = CGRectMake(17, (adWidth - 17 * 2) / 16.0 * 9 + 9, 36, 18);
    adLabel.textAlignment = NSTextAlignmentCenter;
    
    // 设置广告描述(可选)
    UILabel *descLabel = [UILabel new];
    descLabel.textColor = [UIColor adrf_colorWithHexString:@"#333333"];
    descLabel.font = [UIFont adrf_PingFangLightFont:12];
    descLabel.textAlignment = NSTextAlignmentLeft;
    descLabel.text = adView.adData.desc;
    [adView addSubview:descLabel];
    descLabel.frame = CGRectMake(17 + 36 + 4, (adWidth - 17 * 2) / 16.0 * 9 + 9, self.view.frame.size.width - 57 - 17 - 20, 18);
    
    // 设置标题文字（可选，但强烈建议带上）
    UILabel *titlabel = [UILabel new];
    [adView addSubview:titlabel];
    titlabel.font = [UIFont adrf_PingFangMediumFont:14];
    titlabel.textColor = [UIColor adrf_colorWithHexString:@"#333333"];
    titlabel.numberOfLines = 2;
    titlabel.text = adView.adData.title;
    CGSize textSize = [titlabel sizeThatFits:CGSizeMake(adWidth - 17 * 2, 999)];
    titlabel.frame = CGRectMake(17, (adWidth - 17 * 2) / 16.0 * 9 + 30, adWidth - 17 * 2, textSize.height);
    
    // 展示关闭按钮（必要）
    UIButton *closeButton = [UIButton new];
    [adView addSubview:closeButton];
    [adView bringSubviewToFront:closeButton];
    closeButton.frame = CGRectMake(adWidth - 44, 0, 44, 44);
    [closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    // ranfeng_close方法为协议中方法 直接添加target即可 无需实现
    [closeButton addTarget:adView action:@selector(ranfeng_close) forControlEvents:UIControlEventTouchUpInside];
    
}


-(void)dealloc{
#if DEBUG
    NSLog(@"%s",__func__);
#endif
}

@end
