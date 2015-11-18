
import Foundation
import Notificationz

//: # Notificationz
//: ### Helping you _own_ `NSNotificationCenter`!

//: ## Features
//: Use your own naming convention to wrap NSNotificationCenter

let nsCenter = NSNotificationCenter.defaultCenter()
let NC = NotificationCenter(nsCenter: nsCenter)
let 📡 = NotificationCenter(nsCenter: nsCenter)
📡.post("💃")
// Now, you can use NC throughout your app

//: Four simple keywords to remember

class Object {
    @objc(call) func call() {}
}

let obj = Object()
NC.add(obj, selector: "call")   // normal add observer
NC.observe { notification in }  // observe using blocks
NC.post("Ten-hut!")             // post a notification
NC.remove(obj)                  // remove from nsCenter

//: Transparent and convenient API

let keys = ["observe", "many", "keys"]
NC.observe(keys) { _ in }       // observe on the same thread
NC.observeUI(keys) { _ in }     // delivered to the main thread

NC.post("string")
NC.post("more-stuff", userInfo: ["info":5])
NC.post(NSNotification(name: "notification", object: nil))

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
NC.post("call doSomething")
dummy = nil
NC.post("Doesn't crash!")


