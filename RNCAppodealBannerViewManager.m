//
//  AppodealBannerViewManager.m
//  ULTIMO
//
//  Created by Manuele on 25/06/17.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Appodeal/Appodeal.h>
#import <Appodeal/APDBannerView.h>
#import <React/RCTLog.h>

#import <React/RCTViewManager.h>
#import <React/RCTComponent.h>
#import <React/UIView+React.h>

@interface RNCAppodealBANNERView: AppodealBannerView

  @property (nonatomic, copy) RCTBubblingEventBlock onDidLoad;
  @property (nonatomic, copy) RCTBubblingEventBlock onDidFailToLoad;
  @property (nonatomic, copy) RCTBubblingEventBlock onDidRefresh;
  @property (nonatomic, copy) RCTBubblingEventBlock onDidInteract;
  @property (nonatomic, copy) RCTBubblingEventBlock onDidShow;

  @end
@implementation RNCAppodealBANNERView

  @end

@interface RNCAppodealBANNERViewManager : RCTViewManager <AppodealBannerViewDelegate>
  @property (nonatomic, strong) UIView* AppodealNativeView;
  @end

@implementation RNCAppodealBANNERViewManager

  RCT_EXPORT_MODULE();
  RCT_EXPORT_VIEW_PROPERTY(onDidLoad, RCTBubblingEventBlock)
  RCT_EXPORT_VIEW_PROPERTY(onDidFailToLoad, RCTBubblingEventBlock)
  RCT_EXPORT_VIEW_PROPERTY(onDidRefresh, RCTBubblingEventBlock)
  RCT_EXPORT_VIEW_PROPERTY(onDidInteract, RCTBubblingEventBlock)
  RCT_EXPORT_VIEW_PROPERTY(onDidShow, RCTBubblingEventBlock)


  //return view to js, when import
- (UIView *)view
  {
    RCTLogTrace(@"Appodeal Banner View is loading new banner!");
    RNCAppodealBANNERView *bannerView = [
      [RNCAppodealBANNERView alloc]
      initWithSize:kAppodealUnitSize_320x50
      rootViewController:[[UIApplication sharedApplication] keyWindow].rootViewController
    ];
    bannerView.delegate = self;
    [bannerView loadAd];
    return bannerView;
  }


  - (void)bannerViewDidLoadAd:(RNCAppodealBANNERView *)bannerView {
    RCTLogTrace(@"[Appodeal BANNER View] %@ did load!", bannerView);
    if (!bannerView.onDidLoad) {
      RCTLogTrace(@"[Appodeal BANNER View] has no onDidLoad method!");
    } else {
      bannerView.onDidLoad(@{
        @"loaded": @(YES)
      });
    }
  }

  - (void)bannerViewDidInteract:(RNCAppodealBANNERView *)bannerView {
    RCTLogTrace(@"[Appodeal BANNER View] %@ did interact!", bannerView);
    if (!bannerView.onDidInteract) {
      RCTLogTrace(@"[Appodeal BANNER View] has no onDidInteract method!");
    } else {
      bannerView.onDidInteract(@{
        @"interact": @(YES)
      });
    }
  }

  - (void)bannerViewDidShow:(RNCAppodealBANNERView *)bannerView {
    RCTLogTrace(@"[Appodeal BANNER View] %@ did show!", bannerView);
    if (!bannerView.onDidShow) {
      RCTLogTrace(@"[Appodeal BANNER View] has no onDidShow method!");
    } else {
      bannerView.onDidShow(@{
        @"show": @(YES)
      });
    }
  }

  - (void)bannerViewDidRefresh:(RNCAppodealBANNERView *)bannerView {
    RCTLogTrace(@"[Appodeal BANNER View] %@ did refresh!", bannerView);
    if (!bannerView.onDidRefresh) {
      RCTLogTrace(@"[Appodeal BANNER View] has no onDidRefresh method!");
    } else {
      bannerView.onDidRefresh(@{
        @"refresh": @(YES)
      });
    }
  }

  - (void)bannerView:(RNCAppodealBANNERView *)bannerView didFailToLoadAdWithError:(NSError *)error {
    RCTLogTrace(@"[Appodeal BANNER View] %@ did fail to load!", bannerView);
    if (!bannerView.onDidFailToLoad) {
      RCTLogTrace(@"[Appodeal BANNER View] has no onDidFailToLoad method!");
    } else {
      bannerView.onDidFailToLoad(@{@"error": [error localizedDescription]});
    }
  }

  @end
