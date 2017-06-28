//
//  Created by Manuele on 25/06/17.


#import <React/RCTBridgeModule.h>
#import <React/RCTViewManager.h>
#import <React/RCTEventEmitter.h>
#import <Appodeal/Appodeal.h>

@interface RCTAppodealModule : RCTEventEmitter <RCTBridgeModule, AppodealBannerDelegate, AppodealInterstitialDelegate, AppodealRewardedVideoDelegate, AppodealNonSkippableVideoDelegate>
@end
