
<h1 align="center">
  Notificationz :satellite:
<h6 align="center">
  Helping you own NSNotificationCenter
</h6>
</h1>

<p align="center">
  <img alt="Version" src="https://img.shields.io/badge/version-1.0.0-blue.svg" />
  <a alt="Travis CI" href="https://travis-ci.org/SwiftKitz/Notificationz">
    <img alt="Version" src="https://travis-ci.org/SwiftKitz/Notificationz.svg?branch=master" />
  </a>
  <img alt="Swift" src="https://img.shields.io/badge/swift-2.1-orange.svg" />
  <img alt="Platforms" src="https://img.shields.io/badge/platform-ios%20%7C%20osx%20%7C%20watchos%20%7C%20tvos-lightgrey.svg" />
</p>

## Highlights

+ __Keep Your Naming Conventions:__<br />
This library gives you convenient access to `NSNotificationCenter`, but it's up to you to set it up the way you like!

+ __Nothing to Hide:__<br />
Not trying to hide `NSNotificationCenter` functionality. Just an attempt to provide a more convenient API
  
+ __Full and Simple Testing:__<br />
Testing this library was simple, since it only forwards calls to `NSNotificationCenter` for the most part. Mocking that object allowed tests to reach 100% coverage.

## Features

You can try them in the playground shipped with the framework!

__Use your own naming convention to wrap NSNotificationCenter__

```swift
let nsCenter = NSNotificationCenter.defaultCenter()
let 📡 = NotificationCenterAdapter(notificationCenter: nsCenter)
📡.post("💃")

// my personal preference, define this in Globals.swift
let NC = NotificationCenterAdapter(notificationCenter: nsCenter)
// Now, you can use `NC` throughout the app
```

__Four simple keywords to remember__

```swift
NC.add(obj, selector: "call:")  // normal add observer
NC.observe { notification in }  // observe using blocks
NC.post("Ten-hut!")             // post a notification
NC.remove(obj)                  // remove from nsCenter
```

__Transparent and convenient API__

```swift
let keys = ["observe", "many", "keys"]
NC.observe(keys) { _ in }       // observe on the same thread
NC.observeUI(keys) { _ in }     // delivered to the main thread

NC.post("string")
NC.post("more-stuff", userInfo: ["info":5])
NC.post(NSNotification(name: "notification", object: nil))
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
// trigger notification
NC.post("call doSomething")
// cleanup is automatic
dummy = nil
// this won't trigger anything
NC.post("Doesn't crash!")
```

## Motivation

After migrating to Swift, the `NSNotificationCenter` APIs really stood out in the code. Writing so much boiler plate all over the place just to register, handle, and cleanup notifications. Coming from C++, RAII seemed a pretty invaluable pattern to be applied here.

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
