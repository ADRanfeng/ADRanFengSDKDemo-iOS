//
//  ADRanFengInterstitialAdViewController.m
//  ADRanFengSDKDemo-iOS
//
//  Created by 陈则富 on 2021/9/14.
//

#import "ADRanFengInterstitialAdViewController.h"
#import <ADRanFengSDK/ADRanFengInterstitialAd.h>
#import "UIView+Toast.h"
#import "AdsPosId.h"
@interface ADRanFengInterstitialAdViewController ()<ADRanFengInterstitialAdDelegate>
{
    BOOL _isNormalAd;
}

@property (nonatomic ,strong) ADRanFengInterstitialAd  *interstitialAd;

@property (nonatomic ,assign) BOOL  isReady;


@end

@implementation ADRanFengInterstitialAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isNormalAd = YES;
    
    self.title = @"插屏";
    self.view.backgroundColor = [UIColor colorWithRed:225/255.0 green:233/255.0 blue:239/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIButton *loadBtn = [UIButton new];
    loadBtn.layer.cornerRadius = 3;
    loadBtn.clipsToBounds = YES;
    loadBtn.backgroundColor = UIColor.whiteColor;
    [loadBtn setTitle:@"加载普通插屏" forState:(UIControlStateNormal)];
    [loadBtn setTitleColor:UIColor.blackColor forState:(UIControlStateNormal)];
    [self.view addSubview:loadBtn];
    loadBtn.frame = CGRectMake(30, 100, UIScreen.mainScreen.bounds.size.width-60, 40);
    [loadBtn addTarget:self action:@selector(loadInterstitialAd) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIButton *showBtn = [UIButton new];
    showBtn.layer.cornerRadius = 3;
    showBtn.clipsToBounds = YES;
    showBtn.backgroundColor = UIColor.whiteColor;
    [showBtn setTitle:@"展示普通插屏" forState:(UIControlStateNormal)];
    [showBtn setTitleColor:UIColor.blackColor forState:(UIControlStateNormal)];
    [self.view addSubview:showBtn];
    [showBtn addTarget:self action:@selector(showInterstitialAd) forControlEvents:(UIControlEventTouchUpInside)];
    showBtn.frame = CGRectMake(30, 160, UIScreen.mainScreen.bounds.size.width-60, 40);
    
    
    UIButton *loadBidBtn = [UIButton new];
    loadBidBtn.layer.cornerRadius = 3;
    loadBidBtn.clipsToBounds = YES;
    loadBidBtn.backgroundColor = UIColor.whiteColor;
    [loadBidBtn setTitle:@"加载竞价插屏" forState:(UIControlStateNormal)];
    [loadBidBtn setTitleColor:UIColor.blackColor forState:(UIControlStateNormal)];
    [self.view addSubview:loadBidBtn];
    loadBidBtn.frame = CGRectMake(30, 220, UIScreen.mainScreen.bounds.size.width-60, 40);
    [loadBidBtn addTarget:self action:@selector(loadBidAd) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIButton *bidWinBtn = [UIButton new];
    bidWinBtn.layer.cornerRadius = 3;
    bidWinBtn.clipsToBounds = YES;
    bidWinBtn.backgroundColor = UIColor.whiteColor;
    [bidWinBtn setTitle:@"竞价成功" forState:(UIControlStateNormal)];
    [bidWinBtn setTitleColor:UIColor.blackColor forState:(UIControlStateNormal)];
    [self.view addSubview:bidWinBtn];
    bidWinBtn.frame = CGRectMake(30, 280, UIScreen.mainScreen.bounds.size.width-60, 40);
    [bidWinBtn addTarget:self action:@selector(bidWin) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIButton *bidFailBtn = [UIButton new];
    bidFailBtn.layer.cornerRadius = 3;
    bidFailBtn.clipsToBounds = YES;
    bidFailBtn.backgroundColor = UIColor.whiteColor;
    [bidFailBtn setTitle:@"竞价失败" forState:(UIControlStateNormal)];
    [bidFailBtn setTitleColor:UIColor.blackColor forState:(UIControlStateNormal)];
    [self.view addSubview:bidFailBtn];
    bidFailBtn.frame = CGRectMake(30, 340, UIScreen.mainScreen.bounds.size.width-60, 40);
    [bidFailBtn addTarget:self action:@selector(bidFail) forControlEvents:(UIControlEventTouchUpInside)];
    
}

- (void)loadInterstitialAd{
    _isNormalAd = YES;
    _isReady = NO;
    // 1、初始化插屏广告
    self.interstitialAd = [[ADRanFengInterstitialAd alloc]init];
    self.interstitialAd.controller = self;
    self.interstitialAd.posId   =   normal_interstitialAd_posId;
    self.interstitialAd.delegate = self;
    // 是否开启倒计时关闭
    // self.interstitialAd.isAutoClose = YES;
    // 设置倒计时关闭时长 [3~100) 区间内有效
    // self.interstitialAd.autoCloseTime = 10;
    [self.interstitialAd loadAdData];
}

- (void)showInterstitialAd{
    if (_isReady && self.interstitialAd) {
        [self.interstitialAd showFromRootViewController:self];
        return;
    }
    [self.view makeToast:@"广告未准备好"];
}

- (void)loadBidAd {
    _isNormalAd = NO;
    _isReady = NO;
    // 1、初始化插屏广告
    self.interstitialAd = [[ADRanFengInterstitialAd alloc]init];
    self.interstitialAd.controller = self;
    self.interstitialAd.posId   =   bid_interstitialAd_posId;
    self.interstitialAd.delegate = self;
    [self.interstitialAd loadAdData];
}

- (void)bidWin {
    if (_isNormalAd) {
        [self.view makeToast:@"当前广告不是竞价广告"];
        return;
    }
    if (_isReady && self.interstitialAd) {
        // 如ADRanFeng从竞价队列中胜出，则传入竞价队列第二高价（单位：分）；如仅有ADRanFeng平台竞价广告，则竞赢上报的价格为当前广告对象的底价，如：[adView bidFloor]（单位：分
        [self.interstitialAd sendWinNotificationWithPrice:[self.interstitialAd bidFloor]];
        [self.interstitialAd showFromRootViewController:self];
        return;
    }
    [self.view makeToast:@"广告未准备好"];
}

- (void)bidFail {
    if (_isNormalAd) {
        [self.view makeToast:@"当前广告不是竞价广告"];
        return;
    }
    if (_isReady && self.interstitialAd) {
        [self.interstitialAd sendWinFailNotificationReason:(ADRanFengBiddingLossReasonLowPrice) winnerPirce:1000];
        [self.interstitialAd showFromRootViewController:self];
        return;
    }
    [self.view makeToast:@"广告未准备好"];
}


/**
 *  插屏广告数据请求成功
 */
- (void)ranfengInterstitialSuccessToLoadAd:(ADRanFengInterstitialAd *)unifiedInterstitial {
    [self.view makeToast:@"广告准备好"];
    if (!_isNormalAd)
        [self.view makeToast:[NSString stringWithFormat:@"当前广告价格：%ld",unifiedInterstitial.bidPrice]];
    _isReady = YES;
}

/**
 *  插屏广告数据请求失败
 */
- (void)ranfengInterstitialFailToLoadAd:(ADRanFengInterstitialAd *)unifiedInterstitial error:(NSError *)error {
    [self.view makeToast:error.description];
    _interstitialAd = nil;
}
/**
 *  插屏广告渲染成功
 */
- (void)ranfengInterstitialRenderSuccess:(ADRanFengInterstitialAd *)unifiedInterstitial {
    
}

/**
 *  插屏广告视图展示成功回调
 *  插屏广告展示成功回调该函数
 */
- (void)ranfengInterstitialDidPresentScreen:(ADRanFengInterstitialAd *)unifiedInterstitial {
    NSLog(@"%s",__func__);
}

/**
 *  插屏广告视图展示失败回调
 *  插屏广告展示失败回调该函数
 */
- (void)ranfengInterstitialFailToPresent:(ADRanFengInterstitialAd *)unifiedInterstitial error:(NSError *)error {
    [self.view makeToast:[NSString stringWithFormat:@"当前广告展示失败%@",error]];
    _interstitialAd = nil;
}


/**
 *  插屏广告曝光回调
 */
- (void)ranfengInterstitialWillExposure:(ADRanFengInterstitialAd *)unifiedInterstitial {
    NSLog(@"%s",__func__);
}

/**
 *  插屏广告点击回调
 */
- (void)ranfengInterstitialClicked:(ADRanFengInterstitialAd *)unifiedInterstitial {
    
}


/**
 *  插屏广告页关闭
 */
- (void)ranfengInterstitialAdDidDismissClose:(ADRanFengInterstitialAd *)unifiedInterstitial {
    _interstitialAd = nil;
}

/**
 插屏视频广告开始播放
 */
- (void)ranfengInterstitialAdVideoPlay:(ADRanFengInterstitialAd *)unifiedInterstitial {
    NSLog(@"插屏视频播放");
}


/**
 插屏视频广告视频播放失败
 */
- (void)ranfengInterstitialAdVideoPlayFail:(ADRanFengInterstitialAd *)unifiedInterstitial error:(NSError *)error {
    NSLog(@"插屏视频播放失败");
}

/**
 插屏视频广告视频暂停
 */
- (void)ranfengInterstitialAdVideoPause:(ADRanFengInterstitialAd *)unifiedInterstitial {
    NSLog(@"插屏视频播放暂停");
}

/**
 插屏视频广告视频播放完成
 */
- (void)ranfengInterstitialAdVideoFinish:(ADRanFengInterstitialAd *)unifiedInterstitial {
    NSLog(@"插屏视频播放完成");
}

- (void)ranfengInterstitialAdDidCloseLandingPage:(ADRanFengInterstitialAd *)unifiedInterstitial {
    
}



@end
