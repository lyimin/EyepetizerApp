#APESuperHUD
A simple way to display a HUD with a message or progress information in your application.

<p align="center">
  <img src="https://cloud.githubusercontent.com/assets/16682908/12681053/f4974f7e-c6ac-11e5-972e-f234200872aa.gif" alt="APESuperHUD">
  <img src="https://cloud.githubusercontent.com/assets/16682908/12681280/1c018a6a-c6ae-11e5-884e-d12a1a112f58.gif" alt="APESuperHUD">
</p>

##Features
- Simplicity.
- Customizable. See [Change appearance](#change-appearance).
- Fully written in Swift.
- Unit tests.

##Requirements
- iOS 8 or later.
- Xcode 7 or later.

##Installation
####CocoaPods
You can use [Cocoapods](http://cocoapods.org/) to install `APESuperHUD` by adding it to your `Podfile`:
```ruby
platform :ios, '8.0'
use_frameworks!

target 'MyApp' do
    pod 'APESuperHUD', :git => 'https://github.com/apegroup/APESuperHUD.git'
end
```
Note that this requires CocoaPods version 36, and your iOS deployment target to be at least 8.0:

####Carthage
You can use [Carthage](https://github.com/Carthage/Carthage) to install `APESuperHUD` by adding it to your `Cartfile`:
```
github "apegroup/APESuperHUD"
```

##Usage
Don't forget to import.
```swift
import APESuperHUD
```
####Show message HUD
######With default icon
```swift
APESuperHUD.showOrUpdateHUD(.Email, message: "1 new message", duration: 3.0, presentingView: self.view, completion: { _ in
    // Completed
})
```
######With custom image
```swift
APESuperHUD.showOrUpdateHUD(UIImage(named: "apegroup")!, message: "Demo message", duration: 3.0, presentingView: self.view, completion: { _ in
    / Completed
})
```

####Show HUD with loading indicator
######With loading text
```swift
APESuperHUD.showOrUpdateHUD(.Standard, message: "Demo loading...", presentingView: self.view, completion: nil)
```
######Without loading text
```swift
APESuperHUD.showOrUpdateHUD(.Standard, message: "", presentingView: self.view, completion: nil)
```
######With funny loading texts
```swift
APESuperHUD.showOrUpdateHUD(.Standard, funnyMessagesLanguage: .English, presentingView: self.view, completion: nil)
```
####Remove HUD
```swift
APESuperHUD.removeHUD(animated: true, presentingView: self.view, completion: { _ in
    // Completed
})
```
####Change appearance
```swift
APESuperHUD.appearance.cornerRadius = 12
APESuperHUD.appearance.animateInTime = 1.0
APESuperHUD.appearance.animateOutTime = 1.0
APESuperHUD.appearance.backgroundBlurEffect = .None
APESuperHUD.appearance.iconColor = UIColor.greenColor()
APESuperHUD.appearance.textColor = UIColor.greenColor()
APESuperHUD.appearance.loadingActivityIndicatorColor = UIColor.greenColor()
APESuperHUD.appearance.defaultDurationTime = 4.0
APESuperHUD.appearance.cancelableOnTouch = true
APESuperHUD.appearance.iconWidth = 48
APESuperHUD.appearance.iconHeight = 48
APESuperHUD.appearance.fontName = "Caviar Dreams"
APESuperHUD.appearance.fontSize = 14
```

##Contributing
All people are welcome to contribute. See CONTRIBUTING for details.

##License
APESuperHUD is released under the MIT license. See LICENSE for details.
