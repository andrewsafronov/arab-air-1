# Интеграция шаблонного приложения

Чтобы добавить в уже существующее приложение раздел с поиском авиабилетов на основе нашего шаблонного проекта, выполните следующие шаги:

1. Добавьте шаблонный проект в ваше приложение в качестве git submodule. Для этого в корневой директории вашего проекта выполните:

	```bash
	git submodule add https://github.com/KosyanMedia/Aviasales-iOS-SDK.git
	```

	Затем перейдите в папку с шаблонным проектом и переключитесь на текущий стабильный релиз:

	```bash
	cd Aviasales-iOS-SDK/
	git checkout master
	```

2. В Xcode добавьте в ваш проект папку 

	```bash
	Aviasales-iOS-SDK/AviasalesSDKTemplate
	```

3. Для установки дополнительных библиотек в шаблонном проекте используется менеджер зависимостей CocoaPods.

	* 	Если в вашем проекте не используется CocoaPods, вы сначала должны добавить его следуя инструкции на сайте проекта ([https://cocoapods.org]()). В качестве Podfile вы должны использовать Podfile из шаблонного проекта. Скопируйте его в корень вашего проекта
	
		```bash
		cp Aviasales-iOS-SDK/Podfile .
		```
	
		и пропишите название таргета из вашего приложения в строке 
	
		```ruby
		target 'AviasalesSDKTemplate' do
		```
	
		Также возможно придется прописать путь до xproj файла вашего проекта
	
		```ruby
		project 'path_to_project_file/Project.xcodeproj'
		```

	* 	Если в вашем проекте уже используется CocoaPods, вы должны добавить список библиотек из нашего Podfile в ваш существующий и указать, если требуется 
	
		```ruby
		deployment_target => '8.0'
		```
	
	Затем выполните в корневом каталоге вашего проекта
	
	```bash
	pod install
	```

	В ваш проект установятся зависимости, требуемые для поиска билетов. 
	
	*При установленном CocoaPods для открытия проекта в Xcode необходимо использовать workspace файл*.

4. Добавьте в ваш precompiled header файл строку

	```objc
	#import "JRHeader.h"
	```

	Если у вас нет precompiled header файла, создайте его
	
	![](http://ios.aviasales.ru/sdk/screenshots/create-pch-file.gif)
	
	И в настройках таргета вашего приложения на вкладке Build Settings укажите путь к нему в строке Prefix Header
	
	![](http://ios.aviasales.ru/sdk/screenshots/set-pch-file.gif)

5. Если вы используете swift, то добавьте в ваш bridging header файл также 

	```objc
	#import "JRHeader.h"
	```

6. Добавьте в ваш Application Delegate в метод `- application:didFinishLaunchingWithOptions:` вызов с необходимыми параметрами

	```objc
	[JRAppLauncher startServices:]
	```

7. Для получения стартового view controller раздела поиска билетов вызовите

	```objc
	[JRAppLauncher rootViewController]
	```
	
	или, если хотите использовать на iPad режим отображения двух view controller на экране
	
	```objc
	[JRAppLauncher rootViewControllerWithIpadWideLayout]
	```
	
	
	
	