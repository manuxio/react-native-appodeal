import React from 'react';
import {
  requireNativeComponent,
  NativeEventEmitter,
  NativeModules
} from 'react-native';
const nativeModule = NativeModules.AppodealModule;
const nativeModuleEventEmitter = new NativeEventEmitter(nativeModule);

class Appodeal {
  static INTERSTITIAL = 1 << 0;
  static SKIPPABLE_VIDEO = 1 << 1;
  static BANNER = 1 << 2;
  static BANNER_BOTTOM = 1 << 3;
  static BANNER_TOP = 1 << 4;
  static NATIVE_AD = 1 << 5;
  static REWARDED_VIDEO = 1 << 7;
  static NON_SKIPPABLE_VIDEO = 1 << 8;
  static MREC = 1 << 9;

  static APPODEAL_LOG_ERROR = 1 << 0;
  static APPODEAL_LOG_WARNING = 1 << 1;
  static APPODEAL_LOG_INFO = 1 << 2;
  static APPODEAL_LOG_DEBUG = 1 << 3;
  static APPODEAL_LOG_VERBOSE = 1 << 4;


  // Proxy methods
  static addListener(e, cb) {
    nativeModuleEventEmitter.addListener(e, cb);
  }

  static enableRewardedVideoEvents(b) {
    nativeModule.enableRewardedVideoEvents(b);
  }

  static enableNonSkippableVideoEvents(b) {
    nativeModule.enableNonSkippableVideoEvents(b);
  }

  static enableBannerEvents(b) {
    nativeModule.enableBannerEvents(b);
  }

  static hide() {
    nativeModule.hide(1);
  }

  static initializeWithApiKey(k, tt) {
    nativeModule.initializeWithApiKey(k, tt);
  }

  static isReadyForShow(t, cb) {
    nativeModule.isReadyForShow(t, cb);
  }

  static setDebugEnabled(b) {
    nativeModule.setDebugEnabled(b);
  }

  static setLogLevel(ll) {
    nativeModule.setLogLevel(ll);
  }

  static setBannerAnimationEnabled(b) {
    nativeModule.setBannerAnimationEnabled(b);
  }

  static setBannerBackgroundVisible(b) {
    nativeModule.setBannerBackgroundVisible(b);
  }

  static setSmartBannersEnabled(b) {
    nativeModule.setSmartBannersEnabled(b);
  }

  static showAd(type, cb) {
    nativeModule.showAd(type, cb);
  }

}

class AppodealBanner extends React.Component {
  static propTypes = {
     onDidLoad: React.PropTypes.func,
     onDidFailToLoad: React.PropTypes.func,
     onDidShow: React.PropTypes.func,
     onDidRefresh: React.PropTypes.func,
     onDidInteract: React.PropTypes.func,
  }
  render() {
    return <AppodealBannerView {...this.props} />;
  }
}
const AppodealBannerView = requireNativeComponent('RNCAppodealBANNERView', AppodealBanner);

class AppodealMrec extends React.Component {
  static propTypes = {
     onDidLoad: React.PropTypes.func,
     onDidFailToLoad: React.PropTypes.func,
     onDidShow: React.PropTypes.func,
     onDidRefresh: React.PropTypes.func,
     onDidInteract: React.PropTypes.func,
  }
  render() {
    return <AppodealMrecView {...this.props} />;
  }
}
const AppodealMrecView = requireNativeComponent('RNCAppodealMRECView', AppodealMrec);

class AppodealNative extends React.Component {
  static propTypes = {
     onDidLoadNativeAd: React.PropTypes.func,
     onDidFailToLoadNativeAdsWithError: React.PropTypes.func,
  }
  render() {
    return <AppodealNativeView {...this.props} />;
  }
}
const AppodealNativeViewManager = NativeModules.RNCAppodealNativeViewManager;
const AppodealNativeView = requireNativeComponent('RNCAppodealNativeView', AppodealNative);

export {
  Appodeal,
  AppodealBanner,
  AppodealMrec,
  AppodealNative,
  AppodealNativeViewManager
};
