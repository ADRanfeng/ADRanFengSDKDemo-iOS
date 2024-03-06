//
//  ADRanFengNativeTableViewCell.m
//  //  ADRanFengSDKDemo-iOS
//
//  Created by 陈则富 on 2021/9/18.
//

#import "ADRanFengNativeTableViewCell.h"

@implementation ADRanFengNativeTableViewCell

- (void)setAdView:(UIView *)adView {
    [_adView removeFromSuperview];
    
    _adView = adView;
    _adView.frame = self.contentView.bounds;
    [self.contentView addSubview:_adView];
}

@end
