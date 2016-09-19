# Integration of Template Application

Please follow these steps to add flights search section (based on our Template Project) to your existing app.

1. Add the Template Project to your app as git submodule.
To do this, in the root directory of your project run:

	```bash
	git submodule add https://github.com/KosyanMedia/Aviasales-iOS-SDK.git
	```
	Then go to the Template Project folder and switch to the stable release:

	```bash
	cd Aviasales-iOS-SDK/
	git checkout master
	```

2. Add this folder to your project in Xcode:

	```bash
	Aviasales-iOS-SDK/AviasalesSDKTemplate
	```

3. To install additional libraries Template Project uses CocoaPods dependency manager

	*	If you don't use CocoaPods in you project, you have to add it first. Follow the steps from the CocoaPods website ([https://cocoapods.org]()). As a Podfile, you should use Template's Project Podfile. Copy it to the root folder of your project.
	
		```bash
		cp Aviasales-iOS-SDK/Podfile .
		```
		
		and set the target title from your app
	
		```ruby
		target 'AviasalesSDKTemplate' do
		```

		Also you may have to specify the path to the xproj file of your project
	
		```ruby
		project 'path_to_project_file/Project.xcodeproj'
		```

	* 	If you use CocoaPods in you project, you have to add a library list from our Podfile to yours and specify the following, if necessary:
	
		```ruby
		deployment_target => '8.0'
		```
	
	Then run this in the root folder of your project
	
	```bash
	pod install
	```

	All necessary dependencies for the flights search will be installed to your project.
	
	*If you have CocoaPods installed, use workspace file to open the project in Xcode*.

4. Add this string to your precompiled header file

	```objc
	#import "JRHeader.h"
	```
	
	If you don't have precompiled header file, create it
	
	![](http://ios.aviasales.ru/sdk/screenshots/create-pch-file.gif)
	
	And in the target settings of your app, specify the path to it in the Prefix Header string (Build Settings tab)

	![](http://ios.aviasales.ru/sdk/screenshots/set-pch-file.gif)

5. If you use swift, also add this to your bridging header file

	```objc
	#import "JRHeader.h"
	```
	
6. Add this call with necessary parameters to your Application Delegate in method `- application:didFinishLaunchingWithOptions:`

	```objc
	[JRAppLauncher startServices:]
	```
	
7. To get initial view controller of the flights search section, use

	```objc
	[JRAppLauncher rootViewController]
	```
	
	or, if you want to use two view controllers on iPad screen, use 
	
	```objc
	[JRAppLauncher rootViewControllerWithIpadWideLayout]
	```
	
	
	
	