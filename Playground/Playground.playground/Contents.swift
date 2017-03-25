
import Foundation
import Notificationz

//: # Notificationz
//: ### Helping you _own_ `NSNotificationCenter`!

extension Notification.Name {
    static let 💃 = Notification.Name("💃")
    static let tenhut = Notification.Name("Ten-hut!")
    static let test = Notification.Name("test")
}


//: ## Features
//: Use your own naming convention to wrap NSNotificationCenter


let nsCenter = NotificationCenter.default
let NC = NotificationCenterAdapter(notificationCenter: nsCenter)
let 📡 = NotificationCenterAdapter(notificationCenter: nsCenter)
📡.post(.💃)
// Now, you can use NC throughout your app


//: Four simple keywords to remember

class Object {
    @objc(call) func call() {}
}

let obj = Object()
NC.add(obj, selector: #selector(Object.call))   // normal add observer
NC.observe { notification in }                  // observe using blocks
NC.post(.tenhut)                                // post a notification
NC.remove(obj)                                  // remove from nsCenter


//: Transparent and convenient API

let keys = ["observe", "many", "keys"].map { Notification.Name($0) }
NC.observe(keys) { _ in }       // observe on the same thread
NC.observeUI(keys) { _ in }     // delivered to the main thread

NC.post(.test)
NC.post(.test, userInfo: ["info":5])
NC.post(Notification(name: .test, object: nil))


//: RAII-based observers

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


