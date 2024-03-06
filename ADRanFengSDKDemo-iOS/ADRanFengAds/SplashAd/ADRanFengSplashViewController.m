//
//  ADRanFengSplashViewController.m
//  ADRanFengSDKDemo-iOS
//
//  Created by 陈则富 on 2021/9/13.
//

#import "ADRanFengSplashViewController.h"
#import <ADRanFengSDK/ADRanFengSplashAd.h>
#import <ADRFMediationKit/ADRFMediationKitMacros.h>
#import <ADRFMediationKit/UIColor+ADRFMediationKit.h>
#import "UIView+Toast.h"
#import "AdsPosId.h"

@interface ADRanFengSplashViewController ()<ADRanFengSplashAdDelegate>
{
    BOOL _isHeadBidding;
    BOOL _isSucceed;
}

@property (nonatomic ,strong) ADRanFengSplashAd  *splashAd;

@end

@implementation ADRanFengSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:225/255.0 green:233/255.0 blue:239/255.0 alpha:1];
    
    UIButton *loadBtn = [UIButton new];
    loadBtn.layer.cornerRadius = 3;
    loadBtn.clipsToBounds = YES;
    loadBtn.backgroundColor = UIColor.whiteColor;
    [loadBtn setTitle:@"开始询价" forState:(UIControlStateNormal)];
    [loadBtn setTitleColor:UIColor.blackColor forState:(UIControlStateNormal)];
    [self.view addSubview:loadBtn];
    loadBtn.frame = CGRectMake(30, UIScreen.mainScreen.bounds.size.height/2-60, UIScreen.mainScreen.bounds.size.width-60, 40);
    [loadBtn addTarget:self action:@selector(loadBidAd) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIButton *bidWinBtn = [UIButton new];
    bidWinBtn.layer.cornerRadius = 3;
    bidWinBtn.clipsToBounds = YES;
    bidWinBtn.backgroundColor = UIColor.whiteColor;
    [bidWinBtn setTitle:@"竞价成功" forState:(UIControlStateNormal)];
    [bidWinBtn setTitleColor:UIColor.blackColor forState:(UIControlStateNormal)];
    [self.view addSubview:bidWinBtn];
    [bidWinBtn addTarget:self action:@selector(bidWin) forControlEvents:(UIControlEventTouchUpInside)];
    bidWinBtn.frame = CGRectMake(30, UIScreen.mainScreen.bounds.size.height/2, UIScreen.mainScreen.bounds.size.width-60, 40);
    
    UIButton *bidFailBtn = [UIButton new];
    bidFailBtn.layer.cornerRadius = 3;
    bidFailBtn.clipsToBounds = YES;
    bidFailBtn.backgroundColor = UIColor.whiteColor;
    [bidFailBtn setTitle:@"竞价失败" forState:(UIControlStateNormal)];
    [bidFailBtn setTitleColor:UIColor.blackColor forState:(UIControlStateNormal)];
    [self.view addSubview:bidFailBtn];
    [bidFailBtn addTarget:self action:@selector(bidFail) forControlEvents:(UIControlEventTouchUpInside)];
    bidFailBtn.frame = CGRectMake(30, UIScreen.mainScreen.bounds.size.height/2 + 60, UIScreen.mainScreen.bounds.size.width-60, 40);
    
    
    UIButton *loadAndShowBtn = [UIButton new];
    loadAndShowBtn.layer.cornerRadius = 3;
    loadAndShowBtn.clipsToBounds = YES;
    loadAndShowBtn.backgroundColor = UIColor.whiteColor;
    [loadAndShowBtn setTitle:@"正常加载展示" forState:(UIControlStateNormal)];
    [loadAndShowBtn setTitleColor:UIColor.blackColor forState:(UIControlStateNormal)];
    [self.view addSubview:loadAndShowBtn];
    [loadAndShowBtn addTarget:self action:@selector(loadAndShow) forControlEvents:(UIControlEventTouchUpInside)];
    loadAndShowBtn.frame = CGRectMake(30, UIScreen.mainScreen.bounds.size.height/2+140, UIScreen.mainScreen.bounds.size.width-60, 40);

}

- (void)loadBidAd {
    _isHeadBidding = YES;
    _isSucceed = NO;
    // 初始化开屏广告加载实例
    if (!_splashAd)
        _splashAd = [[ADRanFengSplashAd alloc]init];
    // 开屏广告posid
    _splashAd.posId = bid_splashAd_posId;
    // 开屏广告委托对象
    _splashAd.delegate = self;
    // 设置默认启动图(一般设置启动图的平铺颜色为背景颜色，使得视觉效果更加平滑)
    _splashAd.backgroundColor = [UIColor adrf_getColorWithImage:[UIImage imageNamed:@"750x1334.png"] withNewSize:[UIScreen mainScreen].bounds.size];
    [_splashAd loadAdWithBottomView:self.fullBool ? nil : [self getBottomView]];
    
}

- (void)bidWin {
    if (!_isHeadBidding) {
        [self.view makeToast:@"当前广告不是竞价广告"];
        return;
    }
    if (!_isSucceed || !_splashAd) {
        [self.view makeToast:[NSString stringWithFormat:@"开屏广告未加载成功"]];
        return;
    }
//    发送竞价成功通知
    // 如ADRanFeng从竞价队列中胜出，则传入竞价队列第二高价（单位：分）；如仅有ADRanFeng平台竞价广告，则竞赢上报的价格为当前广告对象的底价，如：[adView bidFloor]（单位：分
    [_splashAd sendWinNotificationWithPrice:[_splashAd bidFloor]];
    [_splashAd showInWindow:[UIApplication sharedApplication].keyWindow withBottomView:self.fullBool ? nil : [self getBottomView]];
    
}

- (void)bidFail {
    if (!_isHeadBidding) {
        [self.view makeToast:@"当前广告不是竞价广告"];
        return;
    }
    if (!_isSucceed || !_splashAd) {
        [self.view makeToast:[NSString stringWithFormat:@"开屏广告未加载成功"]];
        return;
    }
//    发送竞价成功通知
    [_splashAd sendWinFailNotificationReason:(ADRanFengBiddingLossReasonLowPrice) winnerPirce:100];
    [_splashAd showInWindow:[UIApplication sharedApplication].keyWindow withBottomView:self.fullBool ? nil : [self getBottomView] ];
    
}

- (void)loadAndShow {
    _isHeadBidding = NO;
    _isSucceed = NO;
        // 初始化开屏广告加载实例
    if (!_splashAd)
        _splashAd = [[ADRanFengSplashAd alloc]init];
    // 开屏广告posid
    _splashAd.posId = normal_splashAd_posId;
    // 开屏广告委托对象
    _splashAd.delegate = self;
    // 设置默认启动图(一般设置启动图的平铺颜色为背景颜色，使得视觉效果更加平滑)
    _splashAd.backgroundColor = [UIColor adrf_getColorWithImage:[UIImage imageNamed:@"750x1334.png"] withNewSize:[UIScreen mainScreen].bounds.size];
    // 开屏广告加载并展示
    [_splashAd loadAndShowInWindow:[UIApplication sharedApplication].keyWindow withBottomView:self.fullBool ? nil : [self getBottomView]];
}
- (UIView *)getBottomView{
    CGFloat bottomViewHeight = [UIScreen mainScreen].bounds.size.height * 0.15;
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, bottomViewHeight);
    UIImageView *logoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ADRanFeng_Logo.png"]];
    logoImageView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-92)/2, (bottomViewHeight-36)/2, 92, 36);
    [bottomView addSubview:logoImageView];
    return bottomView;
}
// 开屏广告回调方法
#pragma mark - ADRanFengSplashAdDelegate

/**
 *  开屏广告请求成功
 */
- (void)ranfengSplashAdSuccessLoad:(ADRanFengSplashAd *)splashAd {
    _isSucceed = YES;
    if (_isHeadBidding) {
        [self.view makeToast:[NSString stringWithFormat:@"询价成功：%ld",[splashAd bidPrice]]];
    }
        
}

/**
 *  开屏广告素材加载成功
 */
- (void)ranfengSplashAdDidLoad:(ADRanFengSplashAd *)splashAd {
    
}

/**
 *  开屏广告请求失败
 */
- (void)ranfengSplashAdFailLoad:(ADRanFengSplashAd *)splashAd withError:(NSError *)error {
    NSLog(@"splash开屏广告加载失败%@",error);
}
/**
 *  开屏广告展示失败
 */
- (void)ranfengSplashAdRenderFaild:(ADRanFengSplashAd *)splashAd withError:(NSError *)error {
    [self.view makeToast:[NSString stringWithFormat:@"开屏广告渲染失败：%@",error]];
    _isSucceed = NO;
}

/**
 *  开屏广告曝光回调
 */
- (void)ranfengSplashAdExposured:(ADRanFengSplashAd *)splashAd {
    
}

/**
 *  开屏广告点击回调
 */
- (void)ranfengSplashAdClicked:(ADRanFengSplashAd *)splashAd {
    _isSucceed = NO;
}

/**
 *  开屏广告关闭回调
 */
- (void)ranfengSplashAdClosed:(ADRanFengSplashAd *)splashAd {
    _isSucceed = NO;
    _splashAd = nil;
}

/**
 *  开屏广告倒计时结束回调
 */
- (void)ranfengSplashAdCountdownToZero:(ADRanFengSplashAd *)splashAd {
    
}

/**
 *  开屏广告点击跳过回调
 */
- (void)ranfengSplashAdSkiped:(ADRanFengSplashAd *)splashAd {
    
}


- (void)ranfengSplashAdCloseLandingPage:(ADRanFengSplashAd *)splashAd {
    _isSucceed = NO;
    _splashAd = nil;
}

- (void)ranfengSplashAdFailToShow:(ADRanFengSplashAd *)splashAd error:(NSError *)error {
    _isSucceed = NO;
    NSLog(@"%@",error);
    [self.view makeToast:[NSString stringWithFormat:@"splash开屏广告展示失败%@",error]];
}






@end
