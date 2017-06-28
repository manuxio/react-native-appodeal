//  Created by Manuele on 25/06/17.
//

#import "RCTAppodealModule.h"
#import <Appodeal/Appodeal.h>
#import <React/RCTLog.h>

const int INTERSTITIAL        = 1;
const int VIDEO               = 2;
const int BANNER              = 4;
const int BANNER_BOTTOM       = 8;
const int BANNER_TOP          = 16;
const int NATIVE_AD           = 32;
const int REWARDED_VIDEO      = 128;
const int NON_SKIPPABLE_VIDEO = 256;
const int MREC                = 512;

int nativeAdTypesForType(int adTypes) {
  int nativeAdTypes = 0;

  if ((adTypes & INTERSTITIAL) > 0) {
    nativeAdTypes |= AppodealAdTypeInterstitial;
  }

  if ((adTypes & VIDEO) > 0) {
    nativeAdTypes |= AppodealAdTypeInterstitial;
  }

  if ((adTypes & BANNER) > 0 ||
      (adTypes & BANNER_TOP) > 0 ||
      (adTypes & BANNER_BOTTOM) > 0) {

    nativeAdTypes |= AppodealAdTypeBanner;
  }

  if ((adTypes & REWARDED_VIDEO) > 0) {
    nativeAdTypes |= AppodealAdTypeRewardedVideo;
  }

  if ((adTypes & NON_SKIPPABLE_VIDEO) >0) {
    nativeAdTypes |= AppodealAdTypeNonSkippableVideo;
  }

  if ((adTypes & NATIVE_AD) > 0) {
    nativeAdTypes |= AppodealAdTypeNativeAd;
  }

  if ((adTypes & MREC) > 0) {
    nativeAdTypes |= AppodealAdTypeMREC;
  }

  return nativeAdTypes;
}

int nativeShowStyleForType(int adTypes) {
  bool isInterstitial = (adTypes & INTERSTITIAL) > 0;
  bool isVideo = (adTypes & VIDEO) > 0;

  if (isInterstitial && isVideo) {
    return AppodealShowStyleInterstitial | AppodealShowStyleSkippableVideo;
  } else if (isVideo) {
    return AppodealShowStyleSkippableVideo;
  } else if (isInterstitial) {
    return AppodealShowStyleInterstitial;
  }

  if ((adTypes & BANNER_TOP) > 0) {
    return AppodealShowStyleBannerTop;
  }

  if ((adTypes & BANNER_BOTTOM) > 0) {
    return AppodealShowStyleBannerBottom;
  }

  if ((adTypes & REWARDED_VIDEO) > 0) {
    return AppodealShowStyleRewardedVideo;
  }

  if ((adTypes & NON_SKIPPABLE_VIDEO) > 0) {
    return AppodealShowStyleNonSkippableVideo;
  }

  return 0;
}

@implementation RCTAppodealModule

  RCT_EXPORT_MODULE(AppodealModule);

  - (NSArray<NSString *> *)supportedEvents
  {
    return @[
    @"onBannerDidShow",
    @"onBannerLoadAd",
    @"onBannerDidClick",
    @"onBannerFailToLoadAd",
    @"onInterstitialDidLoadAd",
    @"onInterstitialDidFailToLoadAd",
    @"onInterstitialDidFailToPresent",
    @"onInterstitialWillPresent",
    @"onInterstitialDidDismiss",
    @"onInterstitialDidClick",
    @"onRewardedVideoDidLoadAd",
    @"onRewardedVideoDidFailToLoadAd",
    @"onRewardedVideoDidFailToPresent",
    @"onRewardedVideoDidPresent",
    @"onRewardedVideoWillDismiss",
    @"onRewardedVideoDidFinish",
    @"onNonSkippableVideoDidLoadAd",
    @"onNonSkippableVideoDidFailToLoadAd",
    @"onNonSkippableVideoDidPresent",
    @"onNonSkippableVideoDidFailToPresent",
    @"onNonSkippableVideoWillDismiss",
    @"onNonSkippableVideoDidFinish"
    ];
  }

#pragma mark init

  RCT_EXPORT_METHOD(initializeWithApiKey:(NSString *)appKey types:(int)adType)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      RCTLogInfo(@"Initializing Appodeal with apiKey %@ and types %i", appKey, adType);
      [Appodeal initializeWithApiKey:appKey types:nativeAdTypesForType(adType)];
    });
  }

  RCT_EXPORT_METHOD(isPrecache:(int)adType calls:(RCTResponseSenderBlock)callback)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      if([Appodeal isAutocacheEnabled:nativeAdTypesForType(adType)])
      callback(@[@YES]);
      else
      callback(@[@NO]);
    });
  }

  RCT_EXPORT_METHOD(isInitialized:(RCTResponseSenderBlock)callback)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      if([Appodeal isInitalized])
      callback(@[@YES]);
      else
      callback(@[@NO]);
    });
  }

#pragma mark enables
  RCT_EXPORT_METHOD(enableInterstitialEvents:(BOOL)val)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      [Appodeal setInterstitialDelegate:self];
    });
  }

  RCT_EXPORT_METHOD(enableBannerEvents:(BOOL)val)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      [Appodeal setBannerDelegate:self];
    });
  }


  RCT_EXPORT_METHOD(enableRewardedVideoEvents:(BOOL)val)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      [Appodeal setRewardedVideoDelegate:self];
    });
  }

  RCT_EXPORT_METHOD(enableNonSkippableVideoEvents:(BOOL)val)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      [Appodeal setNonSkippableVideoDelegate:self];
    });
  }

#pragma mark show methods

  RCT_EXPORT_METHOD(showAd:(int)showType result:(RCTResponseSenderBlock)callback)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      RCTLogInfo(@"[Appdeal Module] showAd of type %i", showType);
      if([Appodeal showAd:nativeShowStyleForType(showType) rootViewController:[[UIApplication sharedApplication] keyWindow].rootViewController])
      callback(@[@YES]);
      else
      callback(@[@NO]);
    });
  }

  RCT_EXPORT_METHOD(showWithPlacement:(int)showType placement:(NSString*)placement result:(RCTResponseSenderBlock)callback)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      RCTLogInfo(@"[Appdeal Module] showAd of type %i on place %@", showType, placement);
      if([Appodeal showAd:nativeShowStyleForType(showType) forPlacement:placement rootViewController:[[UIApplication sharedApplication] keyWindow].rootViewController])
      callback(@[@YES]);
      else
      callback(@[@NO]);
    });
  }

#pragma mark public methods

  RCT_EXPORT_METHOD(setLogLevel:(int)logLevel)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      [Appodeal setLogLevel:logLevel];
    });
  }

  RCT_EXPORT_METHOD(cache:(int)adType)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      [Appodeal cacheAd:nativeAdTypesForType(adType)];
    });
  }

  RCT_EXPORT_METHOD(hide:(int)adType)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      [Appodeal hideBanner];
    });
  }

  RCT_EXPORT_METHOD(setDebugEnabled:(BOOL)debug)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      [Appodeal setDebugEnabled:debug];
    });
  }

  RCT_EXPORT_METHOD(setTesting:(BOOL)testingEnabled)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      RCTLogInfo(@"[RCTAppodealModule] Testing must be enabled/disabled before initializing!");
      [Appodeal setTestingEnabled:testingEnabled];
    });
  }

  RCT_EXPORT_METHOD(setLocationTracking:(BOOL)locationTrackingEnabled)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      [Appodeal setLocationTracking:locationTrackingEnabled];
    });
  }


  RCT_EXPORT_METHOD(setMinimumFreeMemoryPercentage:(int)percentage observeSystemWarnings:(BOOL)observeSystemWarnings forAdType:(int)forAdType)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      [Appodeal setMinimumFreeMemoryPercentage:(NSUInteger)percentage
        observeSystemWarnings:(BOOL)observeSystemWarnings
        forAdType:nativeAdTypesForType(forAdType)
      ];
    });
  }

  RCT_EXPORT_METHOD(getVersion:(RCTResponseSenderBlock)callback)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      callback(@[[Appodeal getVersion]]);
    });
  }

  RCT_EXPORT_METHOD(isReadyForShow:(int)showType result:(RCTResponseSenderBlock)callback)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      if([Appodeal isReadyForShowWithStyle:nativeShowStyleForType(showType)])
      callback(@[@YES]);
      else
      callback(@[@NO]);
    });
  }

  RCT_EXPORT_METHOD(setCustomRule:(NSString *)rule)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      [Appodeal setCustomRule:[NSJSONSerialization JSONObjectWithData:[rule dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
    });
  }

  RCT_EXPORT_METHOD(setCustomDoubleRule:(NSString *)rule)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      [Appodeal setCustomRule:[NSJSONSerialization JSONObjectWithData:[rule dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
    });
  }

  RCT_EXPORT_METHOD(setCustomIntegerRule:(NSString *)rule)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      [Appodeal setCustomRule:[NSJSONSerialization JSONObjectWithData:[rule dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
    });
  }

  RCT_EXPORT_METHOD(setCustomStringRule:(NSString *)rule)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      [Appodeal setCustomRule:[NSJSONSerialization JSONObjectWithData:[rule dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
    });
  }

  RCT_EXPORT_METHOD(setCustomBooleanRule:(NSString *)rule)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      [Appodeal setCustomRule:[NSJSONSerialization JSONObjectWithData:[rule dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]];
    });
  }

  RCT_EXPORT_METHOD(confirm:(int)adType)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      [Appodeal confirmUsage:nativeAdTypesForType(adType)];
    });
  }

  RCT_EXPORT_METHOD(setSmartBannersEnabled:(BOOL)val)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      [Appodeal setSmartBannersEnabled:val];
    });
  }

  RCT_EXPORT_METHOD(setBannerBackgroundVisible:(BOOL)val)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      [Appodeal setBannerBackgroundVisible:val];
    });
  }

  RCT_EXPORT_METHOD(setBannerAnimationEnabled:(BOOL)val)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      [Appodeal setBannerAnimationEnabled:val];
    });
  }

  RCT_EXPORT_METHOD(setUserId:(NSString *)userId)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      [Appodeal setUserId:userId];
    });
  }

  RCT_EXPORT_METHOD(setEmail:(NSString *)email)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      [Appodeal setUserEmail:email];
    });
  }

  RCT_EXPORT_METHOD(setBirthday:(NSString *)birthday)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
      [dateFormatter setDateFormat:@"dd-MM-yyyy"];
      NSDate *dateFromString = [[NSDate alloc] init];
      dateFromString = [dateFormatter dateFromString:birthday];

      [Appodeal setUserBirthday:dateFromString];
    });
  }

  RCT_EXPORT_METHOD(setAge:(int)age)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      [Appodeal setUserAge:age];
    });
  }

  RCT_EXPORT_METHOD(setGender:(NSString *)AppodealUserGender)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      if([AppodealUserGender isEqualToString:@"other"])
      [Appodeal setUserGender:AppodealUserGenderOther];
      if([AppodealUserGender isEqualToString:@"male"])
      [Appodeal setUserGender:AppodealUserGenderMale];
      if([AppodealUserGender isEqualToString:@"female"])
      [Appodeal setUserGender:AppodealUserGenderFemale];
    });
  }

  RCT_EXPORT_METHOD(setOccupation:(NSString *)AppodealUserOccupation)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      if([AppodealUserOccupation isEqualToString:@"other"])
      [Appodeal setUserOccupation:AppodealUserOccupationOther];
      if([AppodealUserOccupation isEqualToString:@"work"])
      [Appodeal setUserOccupation:AppodealUserOccupationWork];
      if([AppodealUserOccupation isEqualToString:@"school"])
      [Appodeal setUserOccupation:AppodealUserOccupationSchool];
      if([AppodealUserOccupation isEqualToString:@"university"])
      [Appodeal setUserOccupation:AppodealUserOccupationUniversity];
    });
  }

  RCT_EXPORT_METHOD(setRelation:(NSString *)AppodealUserRelationship)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      if([AppodealUserRelationship isEqualToString:@"other"])
      [Appodeal setUserRelationship:AppodealUserRelationshipOther];
      if([AppodealUserRelationship isEqualToString:@"single"])
      [Appodeal setUserRelationship:AppodealUserRelationshipSingle];
      if([AppodealUserRelationship isEqualToString:@"dating"])
      [Appodeal setUserRelationship:AppodealUserRelationshipDating];
      if([AppodealUserRelationship isEqualToString:@"engaged"])
      [Appodeal setUserRelationship:AppodealUserRelationshipEngaged];
      if([AppodealUserRelationship isEqualToString:@"married"])
      [Appodeal setUserRelationship:AppodealUserRelationshipMarried];
      if([AppodealUserRelationship isEqualToString:@"searching"])
      [Appodeal setUserRelationship:AppodealUserRelationshipSearching];
    });
  }

  RCT_EXPORT_METHOD(setSmoking:(NSString *)AppodealUserSmokingAttitude)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      if([AppodealUserSmokingAttitude isEqualToString:@"negative"])
      [Appodeal setUserSmokingAttitude:AppodealUserSmokingAttitudeNegative];
      if([AppodealUserSmokingAttitude isEqualToString:@"neutral"])
      [Appodeal setUserSmokingAttitude:AppodealUserSmokingAttitudeNeutral];
      if([AppodealUserSmokingAttitude isEqualToString:@"positive"])
      [Appodeal setUserSmokingAttitude:AppodealUserSmokingAttitudePositive];
    });
  }

  RCT_EXPORT_METHOD(setAlcohol:(NSString *)AppodealUserAlcoholAttitude)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      if([AppodealUserAlcoholAttitude isEqualToString:@"negative"])
      [Appodeal setUserAlcoholAttitude:AppodealUserAlcoholAttitudeNegative];
      if([AppodealUserAlcoholAttitude isEqualToString:@"neutral"])
      [Appodeal setUserAlcoholAttitude:AppodealUserAlcoholAttitudeNeutral];
      if([AppodealUserAlcoholAttitude isEqualToString:@"positive"])
      [Appodeal setUserAlcoholAttitude:AppodealUserAlcoholAttitudePositive];
    });
  }

  RCT_EXPORT_METHOD(setInterests:(NSString *)interests)
  {
    dispatch_async(dispatch_get_main_queue(), ^{
      [Appodeal setUserInterests:interests];
    });
  }

#pragma mark bannerDelegate

  - (void)bannerDidShow
    {
      [self sendEventWithName:@"onBannerDidShow" body:@{@"":@""}];
    }

  - (void)bannerDidLoadAdIsPrecache:(BOOL)precache
    {
      [self sendEventWithName:@"onBannerLoadAd" body:@{@"precache":@(precache)}];
    }

  - (void)bannerDidClick
    {
      [self sendEventWithName:@"onBannerDidClick" body:@{@"":@""}];
    }

  - (void)bannerDidFailToLoadAd;
    {
      [self sendEventWithName:@"onBannerFailToLoadAd" body:@{@"":@""}];
    }

#pragma mark interstitialDelegate
  - (void)interstitialDidLoadAdIsPrecache:(BOOL)precache
    {
      [self sendEventWithName:@"onInterstitialDidLoadAd" body:@{@"precache":@(precache)}];
    }

  - (void)interstitialDidFailToLoadAd
    {
      [self sendEventWithName:@"onInterstitialDidFailToLoadAd" body:@{@"":@""}];
    }

  - (void)interstitialDidFailToPresent
    {
      [self sendEventWithName:@"onInterstitialDidFailToPresent" body:@{@"":@""}];
    }

  - (void)interstitialWillPresent
    {
      [self sendEventWithName:@"onInterstitialWillPresent" body:@{@"":@""}];
    }

  - (void)interstitialDidDismiss
    {
      [self sendEventWithName:@"onInterstitialDidDismiss" body:@{@"":@""}];
    }

  - (void)interstitialDidClick;
    {
      [self sendEventWithName:@"onInterstitialDidClick" body:@{@"":@""}];
    }

#pragma mark rewardedVideoDelegate

  - (void)rewardedVideoDidLoadAd
    {
      [self sendEventWithName:@"onRewardedVideoDidLoadAd" body:@{@"":@""}];
    }

  - (void)rewardedVideoDidFailToLoadAd
    {
      [self sendEventWithName:@"onRewardedVideoDidFailToLoadAd" body:@{@"":@""}];
    }

  - (void)rewardedVideoDidFailToPresent
    {
      [self sendEventWithName:@"onRewardedVideoDidFailToPresent" body:@{@"":@""}];
    }

  - (void)rewardedVideoDidPresent
    {
      [self sendEventWithName:@"onRewardedVideoDidPresent" body:@{@"":@""}];
    }

  - (void)rewardedVideoWillDismiss
    {
      [self sendEventWithName:@"onRewardedVideoWillDismiss" body:@{@"":@""}];
    }

  - (void)rewardedVideoDidFinish:(NSUInteger)rewardAmount name:(NSString *)rewardName
    {
      if (rewardName == nil) {
        [self sendEventWithName:@"onRewardedVideoDidFinish" body:@{@"rewardAmount":[NSNumber numberWithInteger:0],@"rewardName":@"nil"}];
      }
      else {
        [self sendEventWithName:@"onRewardedVideoDidFinish" body:@{@"rewardAmount":[NSNumber numberWithInteger:rewardAmount],@"rewardName":rewardName}];
      }
    }

#pragma mark nonSkippableVideoDelegate

  - (void)nonSkippableVideoDidLoadAd
    {
      [self sendEventWithName:@"onNonSkippableVideoDidLoadAd" body:@{@"":@""}];
    }

  - (void)nonSkippableVideoDidFailToLoadAd
    {
      [self sendEventWithName:@"onNonSkippableVideoDidFailToLoadAd" body:@{@"":@""}];
    }

  - (void)nonSkippableVideoDidPresent
    {
      [self sendEventWithName:@"onNonSkippableVideoDidPresent" body:@{@"":@""}];
    }

  - (void)nonSkippableVideoDidFailToPresent
    {
      [self sendEventWithName:@"onNonSkippableVideoDidFailToPresent" body:@{@"":@""}];
    }

  - (void)nonSkippableVideoWillDismiss
    {
      [self sendEventWithName:@"onNonSkippableVideoWillDismiss" body:@{@"":@""}];
    }

  - (void)nonSkippableVideoDidFinish
    {
      [self sendEventWithName:@"onNonSkippableVideoDidFinish" body:@{@"":@""}];
    }

  @end
