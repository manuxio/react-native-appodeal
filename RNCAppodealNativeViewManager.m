//
//  AppodealBannerViewManager.m
//  ULTIMO
//
//  Created by Manuele on 25/06/17.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Appodeal/Appodeal.h>
#import <Appodeal/APDNativeAd.h>
#import <Appodeal/APDNativeAdLoader.h>

#import <React/RCTLog.h>
#import <React/RCTViewManager.h>
#import <React/RCTComponent.h>
#import <React/RCTConvert.h>
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import <React/UIView+React.h>

@interface RNCAppodealNativeView: UIView

  @property (nonatomic, copy) RCTBubblingEventBlock onDidLoadNativeAd;
  @property (nonatomic, copy) RCTBubblingEventBlock onDidFailToLoadNativeAdsWithError;
  @end

@implementation RNCAppodealNativeView
  @end

@interface RNCAppodealNativeViewManager : RCTViewManager <APDNativeAdLoaderDelegate>
  @property (nonatomic, strong) RNCAppodealNativeView* AppodealNativeView;
  @property (nonatomic, strong) APDNativeAdLoader* adLoader;
  @property (nonatomic, strong) APDNativeAd* ad;
  @end

@implementation RNCAppodealNativeViewManager

  RCT_EXPORT_MODULE();
  RCT_EXPORT_VIEW_PROPERTY(onDidLoadNativeAd, RCTBubblingEventBlock)
  RCT_EXPORT_VIEW_PROPERTY(onDidFailToLoadNativeAdsWithError, RCTBubblingEventBlock)

  //return view to js, when import
- (UIView *)view
  {
    if (self.AppodealNativeView == nil) {
      self.AppodealNativeView = [[RNCAppodealNativeView alloc] init];
      self.adLoader = [APDNativeAdLoader new];
      self.adLoader.delegate = self;
      [self.adLoader loadAdWithType:[self appodealAdViewTypeConvert:@"APDNativeAdTypeNoVideo"]];
    }
    return self.AppodealNativeView;
  }

- (NSInteger)appodealAdViewTypeConvert:(NSString*) adViewType
  {
    NSInteger adtype=0;
    if([adViewType isEqualToString:@"APDNativeAdTypeVideo"])
      adtype=APDNativeAdTypeVideo;
    if([adViewType isEqualToString:@"APDNativeAdTypeNoVideo"])
      adtype=APDNativeAdTypeNoVideo;
    if([adViewType isEqualToString:@"APDNativeAdTypeAuto"])
      adtype=APDNativeAdTypeAuto;
    return adtype;
  }

  RCT_EXPORT_METHOD(loadNativeAdWithType:(NSString *)adViewType)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.adLoader loadAdWithType:[self appodealAdViewTypeConvert:adViewType]];
    });
  }

#pragma mark native delegate
  - (void)nativeAdLoader:(APDNativeAdLoader *)loader didLoadNativeAds:(NSArray <__kindof APDNativeAd *> *)nativeAds{
    APDNativeAd * nativeAd = [nativeAds firstObject];
    self.ad = nativeAd;
    NSDictionary *passProperties = @{
      @"nativeTitle" : nativeAd.title,
      @"nativeSubtitle" : (nativeAd.subtitle == nil ? @"" : nativeAd.subtitle),
      @"nativeDescriptionText" : (nativeAd.descriptionText == nil ? @"" : nativeAd.descriptionText),
      @"nativeStarRating" : (nativeAd.starRating == nil ? [NSNumber numberWithInt:0] : nativeAd.starRating),
      @"nativeCallToActionText" : nativeAd.callToActionText,
      @"nativeContentRating" : nativeAd.contentRating,
      @"nativeImageUrl" : nativeAd.mainImage.url.absoluteString,
      @"nativeImageHeight" : [NSNumber numberWithFloat:nativeAd.mainImage.size.height],
      @"nativeImageWidth" : [NSNumber numberWithFloat:nativeAd.mainImage.size.width],
      @"nativeIconImageHeight" : [NSNumber numberWithFloat:nativeAd.iconImage.size.height],
      @"nativeIconImageWidth" : [NSNumber numberWithFloat:nativeAd.iconImage.size.width],
      @"nativeIconImageUrl" : nativeAd.iconImage.url.absoluteString,
      @"nativeHasAdChoicesView" : (nativeAd.adChoicesView ? @YES : @NO)
    };
    RCTLogTrace(@"[Appodeal MREC View] %@ did load native ad", self.ad);
    if (self.AppodealNativeView.onDidLoadNativeAd) {
      self.AppodealNativeView.onDidLoadNativeAd(@{@"nativeProperties": passProperties});
    } else {
      RCTLogError(@"[Appodeal NATIVE View] has no didLoadNativeAd method!");
    }
  }

  RCT_EXPORT_METHOD(attachToView)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.ad attachToView:self.AppodealNativeView viewController:[[UIApplication sharedApplication] keyWindow].rootViewController];
    });
  }
  RCT_EXPORT_METHOD(attachAdChoicesViewIfExistsWithFrame:(int)x y:(int)y width:(int)width height:(int)height)
  {

    dispatch_async(dispatch_get_main_queue(), ^{
      if (self.ad.adChoicesView) {
        [self.ad.adChoicesView setFrame:CGRectMake(x, y, width, height)];
        [self.AppodealNativeView addSubview:self.ad.adChoicesView];
      }
    });

  }

  @end
