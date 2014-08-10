# ALCoreDataManager

[![CI Status](http://img.shields.io/travis/Aziz U. Latypov/ALCoreDataManager.svg?style=flat)](https://travis-ci.org/aziz u. latypov/ALCoreDataManager)
[![Version](https://img.shields.io/cocoapods/v/ALCoreDataManager.svg?style=flat)](http://cocoadocs.org/docsets/ALCoreDataManager)
[![License](https://img.shields.io/cocoapods/l/ALCoreDataManager.svg?style=flat)](http://cocoadocs.org/docsets/ALCoreDataManager)
[![Platform](https://img.shields.io/cocoapods/p/ALCoreDataManager.svg?style=flat)](http://cocoadocs.org/docsets/ALCoreDataManager)

## Usage

To use the Manager add the 

#import <ALCoreDataManager/Singleton.h>

to your pch file and than add

[ALCoreDataManage setDefaultCoreDataModelName:@"<#Model#>"];

in your AppDeligate before any other calls to ALCoreDataManager.

To get the NSManagedObjectContext use

[ALCoreDataManager defaultManager].managedObjectContext

## Requirements

CoreData

## Installation

ALCoreDataManager is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "ALCoreDataManager"

## Author

Aziz U. Latypov, vm06lau@mail.ru

## License

ALCoreDataManager is available under the MIT license. See the LICENSE file for more info.

