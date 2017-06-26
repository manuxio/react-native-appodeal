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
#import <Appodeal/APDMRECView.h>
#import <React/RCTLog.h>

#import <React/RCTViewManager.h>
#import <React/RCTComponent.h>
#import <React/UIView+React.h>

@interface RNCAppodealMRECView: AppodealMRECView

  @property (nonatomic, copy) RCTBubblingEventBlock onDidLoad;
  @property (nonatomic, copy) RCTBubblingEventBlock onDidFailToLoad;
  @property (nonatomic, copy) RCTBubblingEventBlock onDidRefresh;
  @property (nonatomic, copy) RCTBubblingEventBlock onDidInteract;
  @property (nonatomic, copy) RCTBubblingEventBlock onDidShow;
  @end

@implementation RNCAppodealMRECView
  @end

@interface RNCAppodealMRECViewManager : RCTViewManager <AppodealBannerViewDelegate>
  @end

@implementation RNCAppodealMRECViewManager

  RCT_EXPORT_MODULE();
  RCT_EXPORT_VIEW_PROPERTY(onDidLoad, RCTBubblingEventBlock)
  RCT_EXPORT_VIEW_PROPERTY(onDidFailToLoad, RCTBubblingEventBlock)
  RCT_EXPORT_VIEW_PROPERTY(onDidRefresh, RCTBubblingEventBlock)
  RCT_EXPORT_VIEW_PROPERTY(onDidInteract, RCTBubblingEventBlock)
  RCT_EXPORT_VIEW_PROPERTY(onDidShow, RCTBubblingEventBlock)

  //return view to js, when import
- (UIView *)view
  {
    RNCAppodealMRECView *bannerView = [
      [RNCAppodealMRECView alloc]
      initWithRootViewController:[[UIApplication sharedApplication] keyWindow].rootViewController
    ];
    bannerView.delegate = self;
    [bannerView loadAd];
    RCTLogTrace(@"[Appodeal MREC View] is loading new banner!");
    return bannerView;
  }


  - (void)bannerViewDidLoadAd:(RNCAppodealMRECView *)bannerView {
    RCTLogTrace(@"[Appodeal MREC View] %@ did load!", bannerView);
    if (!bannerView.onDidLoad) {
      RCTLogTrace(@"[Appodeal MREC View] has no onDidLoad method!");
    } else {
      bannerView.onDidLoad(@{
       @"loaded": @(YES)
      });
    }
  }

  - (void)bannerViewDidShow:(RNCAppodealMRECView *)bannerView {
    RCTLogTrace(@"[Appodeal MREC View]  %@ did show!", bannerView);
    if (!bannerView.onDidShow) {
      RCTLogTrace(@"[Appodeal MREC View] has no onDidShow method!");
    } else {
      bannerView.onDidShow(@{
        @"show": @(YES)
      });
    }
  }

  - (void)bannerViewDidRefresh:(RNCAppodealMRECView *)bannerView {
    RCTLogTrace(@"[Appodeal MREC View] %@ did refresh!", bannerView);
    if (!bannerView.onDidRefresh) {
      RCTLogTrace(@"[Appodeal MREC View] has no onDidRefresh method!");
    } else {
      bannerView.onDidRefresh(@{
        @"refresh": @(YES)
      });
    }
  }

  - (void)bannerViewDidInteract:(RNCAppodealMRECView *)bannerView {
    RCTLogTrace(@"[Appodeal MREC View] %@ did interact!", bannerView);
    if (!bannerView.onDidInteract) {
      RCTLogTrace(@"[Appodeal MREC View] has no onDidInteract method!");
    } else {
      bannerView.onDidInteract(@{
        @"interact": @(YES)
      });
    }
  }

  - (void)bannerView:(RNCAppodealMRECView *)bannerView didFailToLoadAdWithError:(NSError *)error {
    RCTLogTrace(@"[Appodeal MREC View] %@ did fail to load with error %@", bannerView, error);
    if (!bannerView.onDidFailToLoad) {
      RCTLogTrace(@"[Appodeal MREC View] has no onDidFailToLoad method!");
    } else {
      bannerView.onDidFailToLoad(@{@"error": [error localizedDescription]});
    }
  }

  @end
