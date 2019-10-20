# Userbase

[![CI Status](https://img.shields.io/travis/nikhil-kulkarni/Userbase.svg?style=flat)](https://travis-ci.org/nikhil-kulkarni/Userbase)
[![Version](https://img.shields.io/cocoapods/v/Userbase.svg?style=flat)](https://cocoapods.org/pods/Userbase)
[![License](https://img.shields.io/cocoapods/l/Userbase.svg?style=flat)](https://cocoapods.org/pods/Userbase)
[![Platform](https://img.shields.io/cocoapods/p/Userbase.svg?style=flat)](https://cocoapods.org/pods/Userbase)

## Requirements
* iOS 12.0+
* Xcode 10.2+
* Swift 4.0+

## Installation

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```$ gem install cocoapods```

Userbase is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Userbase'
```

Then, run the following command:

```$ pod install```

## Usage
The Userbase iOS SDK is meant to be used in conjunction with [Userbase-Backend](https://github.com/Nikhil-Kulkarni/Userbase-Backend). Follow instructions [here](https://github.com/Nikhil-Kulkarni/Userbase-Backend) to setup your Firebase account and deploy the pre-written cloud functions. Make note of the url the functions are deployed to and add it to a new file called Userbase-Info.plist. 

```swift
import Userbase
```

Initialize the Userbase SDK:
```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    Userbase.initWithLaunchOptions(launchOptions: launchOptions)
    return true
}
```

The API is as follows:
```swift
Userbase.registerUser(id: String, password: String, firstName: String, lastName: String, developerMetadata: String, completion: @escaping (User?, Error?) -> Void)

Userbase.login(id: String, password: String, completion: @escaping (User?, Error?) -> Void)

Userbase.getFriends(completion: @escaping ([Friend]?, Error?) -> Void)

Userbase.sendFriendRequest(to id: String, completion: @escaping (Error?) -> Void)

Userbase.acceptFriendRequest(from id: String, completion: @escaping (Friend?, Error?) -> Void)

Userbase.getFriendRequests(completion: @escaping ([FriendRequest]?, Error?) -> Void)

Userbase.searchUsers(searchPrefix: String, completion: @escaping ([Friend]?, Error?) -> Void)

Userbase.logout(completion: @escaping (Error?) -> Void)
```

## Author

nikhil-kulkarni, nikhil896@gmail.com

## License

Userbase is available under the MIT license. See the LICENSE file for more info.
