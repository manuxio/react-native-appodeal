/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  requireNativeComponent,
  NativeEventEmitter
} from 'react-native';

import { NativeModules } from 'react-native';
const INTERSTITIAL = 1 << 0;
const SKIPPABLE_VIDEO = 1 << 1;
const BANNER = 1 << 2;
const BANNER_BOTTOM = 1 << 3;
const BANNER_TOP = 1 << 4;
const NATIVE_AD = 1 << 5;
const REWARDED_VIDEO = 1 << 7;
const NON_SKIPPABLE_VIDEO = 1 << 8;
const MREC = 1 << 9;

const APPODEAL_LOG_ERROR = 1 << 0;
const APPODEAL_LOG_WARNING = 1 << 1;
const APPODEAL_LOG_INFO = 1 << 2;
const APPODEAL_LOG_DEBUG = 1 << 3;
const APPODEAL_LOG_VERBOSE = 1 << 4;


const AppodealModule = NativeModules.AppodealModule;
AppodealModule.setTesting(true);
AppodealModule.setLogLevel(APPODEAL_LOG_ERROR);
AppodealModule.initializeWithApiKey('0fc6a3b4842e9ddd8f36139482b4f7b9e418318dd47b3054', MREC + NATIVE_AD);
const AppodealModuleEmitter = new NativeEventEmitter(AppodealModule);
console.log('AppodealModule', AppodealModule);
AppodealModuleEmitter.addListener('onRewardedVideoDidLoadAd', () => {
  console.log('Appodeal rewarded video loaded from react');
});
AppodealModuleEmitter.addListener('onRewardedVideoDidFailToLoadAd', (e) => {
  console.log('Appodeal rewarded video failed to load from react', e);
});
AppodealModuleEmitter.addListener('onRewardedVideoDidPresent', () => {
  console.log('Appodeal rewarded video shown from react');
});

AppodealModuleEmitter.addListener('onNonSkippableVideoDidLoadAd', () => {
  console.log('Appodeal onNonSkippableVideoLoaded loaded from react');
});
AppodealModuleEmitter.addListener('onNonSkippableVideoDidFailToLoadAd', (e) => {
  console.log('Appodeal onNonSkippableVideoFailedToLoad failed to load from react', e);
});

AppodealModule.hide(BANNER_TOP);
AppodealModule.setSmartBannersEnabled(true);
AppodealModule.setBannerAnimationEnabled(true);
AppodealModule.setBannerBackgroundVisible(true);
AppodealModule.enableRewardedVideoEvents(true);
AppodealModule.enableNonSkippableVideoEvents(true);

/*
setTimeout(() => {
  AppodealModule.show(SKIPPABLE_VIDEO,
    (result) => {
        console.log('Appodeal Show interstitial from react', result);
    }
  );
}, 5000);
*/

const BannerViewModule = NativeModules.AppodealBannerViewManager;
console.log('Appodeal Banner View Module', BannerViewModule);
// BannerViewModule.loadAd();

class AppoBanner extends React.Component {
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

const AppodealBannerView = requireNativeComponent('RNCAppodealBANNERView', AppoBanner);

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

const AppodealNativeView = requireNativeComponent('RNCAppodealNativeView', AppodealNative);

export default class ULTIMO extends Component {
  constructor(props) {
    super(props);
    this.state = {
      topLoaded: false
    };
  }
  componentDidMount() {
    AppodealModule.isReadyForShow(REWARDED_VIDEO, (result) => {
      console.log('Appodeal REWARDED_VIDEO loaded from react ?', result);
      if (result) {
        /*
        AppodealModule.show(REWARDED_VIDEO, (shown) => {
          console.log('Appodeal rewarded video shown from react ?', shown);
        });
        */
      }
    });
    AppodealModule.isReadyForShow(NON_SKIPPABLE_VIDEO, (result) => {
      console.log('Appodeal NON_SKIPPABLE_VIDEO loaded from react ?', result);
      if (result) {
        /*
        AppodealModule.show(REWARDED_VIDEO, (shown) => {
          console.log('Appodeal rewarded video shown from react ?', shown);
        });
        */
      }
    });
    AppodealModule.isReadyForShow(INTERSTITIAL, (result) => {
      console.log('Appodeal INTERSTITIAL loaded from react ?', result);
      if (result) {
        /*
        AppodealModule.show(REWARDED_VIDEO, (shown) => {
          console.log('Appodeal rewarded video shown from react ?', shown);
        });
        */
      }
    });
  }
  render() {


    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Welcome to React Native!
        </Text>
        {
          false
          ? [
            (<AppoBanner
              style={{width: '100%', height: this.state.topLoaded ? 50 : 0, backgroundColor: 'navy'}}
              onDidLoad={() => {
                console.log('Appodeal banner from react (top), did load!');
                this.setState({
                  topLoaded: true
                });
              }}
              onDidFailLoad={() => {
                console.log('Appodeal banner from react (top), did fail to load!');
              }}
              onDidShow={() => {
                console.log('Appodeal banner from react (top), did show!');
              }}
              onDidRefresh={() => {
                console.log('Appodeal banner from react (top), did refresh!');
              }}
              onDidInteract={() => {
                console.log('Appodeal banner from react (top), did interact!');
              }}
            />),
            (<AppoBanner
              style={{width: '100%', height: 50, backgroundColor: 'red'}}
              onDidLoad={() => {
                console.log('Appodeal banner from react (bottom), did load!');
              }}
              onDidFailLoad={() => {
                console.log('Appodeal banner from react, did fail to load!');
              }}
            />)
          ]
          : <AppodealMrec
            style={{width: '100%', height: this.state.topLoaded ? 100 : 0, backgroundColor: 'navy'}}
            onDidLoad={() => {
              console.log('Appodeal mrec from react, did load!');
              this.setState({
                topLoaded: true
              });
            }}
            onDidFailToLoad={(e) => {
              console.log('Appodeal mrec from react, did fail to load', e.nativeEvent.error);
            }}
            onDidShow={() => {
              console.log('Appodeal mrec from react, did show!');
            }}
            onDidRefresh={() => {
              console.log('Appodeal mrec from react, did refresh!');
            }}
          >
            <Text style={styles.instructions}>
              Sono dentro al frame mrec?
            </Text>
          </AppodealMrec>
        }
        <AppodealNative
          onDidLoadNativeAd={(e) => {
            console.log('Appodeal native from react did load', e.nativeEvent);
          }}
          style={{
            height: 80,
            width: '100%',
            backgroundColor: 'red'
          }}
        />
        <Text style={styles.instructions}>
          To get started, edit index.ios.js
        </Text>
        <Text style={styles.instructions}>
          Press Cmd+R to reload,{'\n'}
          Cmd+D or shake for dev menu
        </Text>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: 'red',
    marginBottom: 5,
  },
});

AppRegistry.registerComponent('ULTIMO', () => ULTIMO);
