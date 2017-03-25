
<h1 align="center">
  Notificationz :satellite:
<h6 align="center">
  Helping you own NotificationCenter
</h6>
</h1>

<p align="center">
  <img alt="Version" src="https://img.shields.io/badge/version-2.1.0-blue.svg" />
  <a alt="Travis CI" href="https://travis-ci.org/SwiftKitz/Notificationz">
    <img alt="Version" src="https://travis-ci.org/SwiftKitz/Notificationz.svg?branch=master" />
  </a>
  <img alt="Swift" src="https://img.shields.io/badge/swift-3.0-orange.svg" />
  <img alt="Platforms" src="https://img.shields.io/badge/platform-ios%20%7C%20osx%20%7C%20watchos%20%7C%20tvos-lightgrey.svg" />
  <a alt="Carthage Compatible" href="https://github.com/SwiftKitz/Notificationz#carthage">
    <img alt="Carthage" src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" />
  </a>
</p>

## Highlights

+ __Keep Your Naming Conventions:__<br />
This library gives you convenient access to `NotificationCenter`, but it's up to you to set it up the way you like!

+ __Nothing to Hide:__<br />
Not trying to hide `NotificationCenter` functionality. Just an attempt to provide a more convenient API
  
+ __Full and Simple Testing:__<br />
Testing this library was simple, since it only forwards calls to `NotificationCenter` for the most part. Mocking that object allowed tests to reach 100% coverage.

## Features

You can try them in the playground shipped with the framework!

__Use your own naming convention to wrap NotificationCenter__

```swift
let nsCenter = NotificationCenter.default
let 📡 = NotificationCenterAdapter(notificationCenter: nsCenter)
📡.post(.💃)

// my personal preference, define this in Globals.swift
let NC = NotificationCenterAdapter(notificationCenter: nsCenter)
// Now, you can use `NC` throughout the app
```

__Four simple keywords to remember__

```swift
let obj = Object()
NC.add(obj, selector: #selector(Object.call))   // normal add observer
NC.observe { notification in }                  // observe using blocks
NC.post(.tenhut)                                // post a notification
NC.remove(obj)                                  // remove from nsCenter
```

__Transparent and convenient API__

```swift
let keys = ["observe", "many", "keys"].map { Notification.Name($0) }
NC.observe(keys) { _ in }       // observe on the same thread
NC.observeUI(keys) { _ in }     // delivered to the main thread

NC.post(.test)
NC.post(.test, userInfo: ["info":5])
NC.post(Notification(name: .test, object: nil))
```

__RAII-based observers__

```swift
class Dummy {
    
    // declare the observer as optional
    var broadcastObserver: Observer?
    
    init() {
        // assign it anywhere you like
        broadcastObserver = NC.observe { [unowned self] _ in
            self.doSomething()
        }.execute() // this is a neat bonus feature
    }
    
    func doSomething() {
        // exectued twice, since we call "execute" manually
        print("it works!")
    }
}

var dummy: Dummy? = Dummy()
NC.post(.test)  // calls doSomething
dummy = nil     // clean up is automatic
NC.post(.test)  // doesn't crash!
```

## Getting Started

**IMPORTANT**: Kitz repos fully embrace Swift 3.0 and all the changes it brought. You should use `v1.0.0` if you are still using Swift 2.x.

### Carthage

[Carthage][carthage-link] is fully supported. Simply add the following line to your [Cartfile][cartfile-docs]:

```ruby
github "SwiftKitz/Notificationz"
```

### Cocoapods

[Cocoapods][cocoapods-link] is fully supported. Simply add the following line to your [Podfile][podfile-docs]:

```ruby
pod 'Notificationz'
```

### Submodule

For manual installation, you can grab the source directly or through git submodules, then simply:

+ Drop the `Notificationz.xcodeproj` file as a subproject (make sure `Copy resources` is __not__ enabled)
+ Navigate to your root project settings. Under "Embedded Binaries", click the "+" button and select the `Notificationz.framework`

## Motivation

After migrating to Swift, the `NotificationCenter` APIs really stood out in the code. Writing so much boiler plate all over the place just to register, handle, and cleanup notifications. Coming from C++, RAII seemed a pretty invaluable pattern to be applied here.

With this framework, one can easily declare all their observers as properties:

```swift
class Sample {
    private var keyboardObserver: Observer?
    private var reachabilityObserver: Observer?
}
```

Other programmers should be pleased with this consistency! Moreover, there is no need to worry handling notifications in some other function somewhere nor do cleanup in `deinit`. It just works:

```swift
keyboardObserver = NC.observeUI(UIKeyboardWillShowNotification) { [unowned self] _ in
    // you can write your handler code here, maybe call another function
}

// you can force cleanup by setting the property to nil, but don't have to
keyboardObserver = nil
```

## Author

Mazyod ([@Mazyod](http://twitter.com/mazyod))

## License

Notificationz is released under the MIT license. See LICENSE for details.


[carthage-link]: https://github.com/Carthage/Carthage
[cartfile-docs]: https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile
[cocoapods-link]: https://cocoapods.org/
[podfile-docs]: https://guides.cocoapods.org/syntax/podfile.html
