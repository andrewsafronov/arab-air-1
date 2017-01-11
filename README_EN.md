Aviasales/Jetradar iOS SDK
=================
[![CocoaPods](https://img.shields.io/cocoapods/v/AviasalesSDK.svg)](https://cocoapods.org/pods/AviasalesSDK)
[![CocoaPods](https://img.shields.io/cocoapods/p/AviasalesSDK.svg)](https://cocoapods.org/pods/AviasalesSDK)
[![Travis](https://img.shields.io/travis/KosyanMedia/Aviasales-iOS-SDK/master.svg)](https://travis-ci.org/KosyanMedia/Aviasales-iOS-SDK)

##Description


[Aviasales](https://www.aviasales.ru)/[Jetradar](https://www.jetradar.com) iOS SDK is a framework integrating a flight search engine into your app. When your user books a flight, you get paid. The framework is based on leading flight search engines Aviasales.ru and Jetradar.com. Aviasales and Jetradar official apps are based on this framework.

The framework includes:

* a static library to integrate with flight search engine server;
* UI template project.
 
You may create your own flight search apps based on our template. To track statistics and payments please visit our partner network — [Travelpayouts.com](https://www.travelpayouts.com/).
To learn more about the Travelpayouts referral system please visit [Travelpayouts FAQ](https://support.travelpayouts.com/hc/en-us/articles/203955613-Commission-and-payments).


##<a name="usage"></a>How to build an app using the template project
### 📲 Installation
1. Download the latest template project release (not beta) here: [https://github.com/KosyanMedia/Aviasales-iOS-SDK/releases](https://github.com/KosyanMedia/Aviasales-iOS-SDK/releases).
2. Download dependencies via ```pod install``` command in Terminal. Don't forget to ```cd``` to the template project folder.
3. Find ```JRAppDelegate.m``` and assign your API token and partner marker to ```kJRAPIToken``` & ```kJRPartnerMarker```.
4. If you don't have partner marker and API token, please visit [Travelpayouts](https://travelpayouts.com/) and register.

###🔧🍁 Color customization
For your convenience we've created ```JRColorScheme.h``` and ```JRColorScheme.m``` to make template project color customization a breeze.

#### Background
|static function|description|
|--------|--------|
mainBackgroundColor| main background color
lightBackgroundColor| light background color — iPad waiting screen
darkBackgroundColor | dark background color — search screen and filters
itemsBackgroundColor | item background color — search results
itemsSelectedBackgroundColor | selected item background color — search results
iPadSceneShadowColor | iPad shadow color

#### Tab Bar
|static function|description|
|--------|--------|
tabBarBackgroundColor | TabBar background color — search and multicity search switcher 
tabBarSelectedBackgroundColor | TabBar selected element background color — search and multicity search switcher 
tabBarHighlightedBackgroundColor | TabBar highlighted element background color — search and multicity search switcher 

#### Text
|static function|description|
|--------|--------|
darkTextColor | dark text color
lightTextColor | light text color
inactiveLightTextColor | light text color for inactive elements
labelWithRoundedCornersBackgroundColor | label with rounded corners background color — stopovers amount
separatorLineColor | separator color

#### Buttons
|static function|description|
|--------|--------|
buttonBackgroundColor | button background color
buttonSelectedBackgroundColor | button selected state
buttonHighlightedBackgroundColor | button highlighted state
buttonShadowColor | button shadow color

#### Popover
|static function|description|
|--------|--------|
popoverTintColor | popover background color — travel class selection

#### ⭐️⭐️⭐️⭐️⭐️
|static function|description|
|--------|--------|
ratingStarDefaultColor | rating star color
ratingStarSelectedColor | selected state for rating star


### 🤑 Appodeal ads setup
To make the ad network integration process easier we've added a mediator — [Appodeal](https://www.appodeal.com/).
Setup:

* assign your Appodeal API key to ```kAppodealApiKey``` parameter
* to disable ads use ```showsAdDuringSearch``` & ```showsAdOnSearchResults``` parameters of ```JRAdvertisementManager``` object in JRAdvertisementManager

Defaults:

* video or interstitial on waiting screen;
* native ads on search results screen.

For testing purposes you can enable test mode here: ```[adManager initializeAppodealWithAPIKey:appodealAPIKey testingEnabled:NO];```. Appodeal will fill all the placements with their own ads in test mode. Don't forget to turn off test mode before you submit the App Store submission.

#### How to add ad networks
To add an ad network to your project you need to install Appodeal adapter: [https://github.com/appodeal/appodeal-ios-sdk-mobile-adapters](https://github.com/appodeal/appodeal-ios-sdk-mobile-adapters). Our template project's adapter location is ```Source > Libs > Appodeal > Adapters```. You may add required adapters in this folder (and don't forget to add them in Xcode).
We have already included a few adapters (less than 20 MB each) in the template project:

* APDGoogleAdMobAdapter
* APDAmazonAdsAdapter
* APDPubnativeAdapter
* APDUnityAdapter
* APDVungleAdapter

Warning: you may experience incorrect behavior with video ads using APDStartAppAdapter.

### 🖇 Deeplinks
You may use deeplinks for search and tickets with ```JRSDKSearchInfoUrlCoder``` object help.
Additional information about deeplinks we support can be found in JRAppDelegate.m and ```- (void)performUrlOpening:(NSURL *)url``` method.


## SDK setup
The easiest way to install AviasalesSDK is [CocoaPods](https://cocoapods.org/pods/AviasalesSDK). CocoaPods will automatically download and install all necessary dependencies and 3rd party libs:

```ruby
pod 'AviasalesSDK', '~> 2.0.0'
```

If you already have an app and would love to integrate Aviasales template project please visit [the doc](TemplateIntegration.md).
