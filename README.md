# react-native-appodeal

install appodeal sdk v. 2 with pod


this is a react-native module to work with appodeal
it's still very early and cannot be auto installed

Initial code was taken from the original appodeal react native adapter, 
which did not work in my case

Some logic changed:

RCTAppodealModule <- works more or less like the original one (most of the events names were changed to meet the objective-c ones!)
RNCAppodealBANNERViewManager <- creates a view with a banner attached (you can place it anywhere you want)
RNCAppodealMRECViewManager <- creates a view with a mrec attached (you can place it anywhere you want)
RNCAppodealNativeViewManager <- still working on it 
