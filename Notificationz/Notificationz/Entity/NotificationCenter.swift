//
//  NC.swift
//  Notificationz
//
//  Created by Mazyad Alabduljaleel on 11/17/15.
//  Copyright © 2015 kitz. All rights reserved.
//

import Foundation


public class NotificationCenter {
    
    public let nsCenter: NSNotificationCenter
    
    // MARK: - Init & Dealloc
    
    public init(nsCenter: NSNotificationCenter) {
        self.nsCenter = nsCenter
    }
    
    // MARK: - Public methods
    
    public func add(observer: AnyObject, selector: Selector, names: [String], object: AnyObject? = nil) {
        names.forEach { self.add(observer, selector: selector, name: $0, object: object) }
    }
    
    public func add(observer: AnyObject, selector: Selector, name: String? = nil, object: AnyObject? = nil) {
        
        nsCenter.addObserver(
            observer,
            selector: selector,
            name: name,
            object: object
        )
    }
    
    public func post(name: String, object: AnyObject? = nil, userInfo: [NSObject:AnyObject]? = nil) {
        nsCenter.postNotificationName(name, object: object, userInfo: userInfo)
    }
    
    public func post(notification: NSNotification) {
        nsCenter.postNotification(notification)
    }
    
    public func remove(observer: AnyObject, name: String? = nil, object: AnyObject? = nil) {
        nsCenter.removeObserver(observer, name: name, object: object)
    }
}


/**
    Observer support
*/

extension NotificationCenter {
    
    private func _observe(names: [String?], object: AnyObject? = nil, queue: NSOperationQueue? = nil, block: Observer.Block) -> Observer {
        
        let tokens = names.map {
            
            self.nsCenter.addObserverForName(
                $0,
                object: object,
                queue: queue,
                usingBlock: block
            )
        }
        
        return Observer(notificationCenter: self, tokens: tokens, block: block)
    }
    
    private func _observeUI(names: [String?], object: AnyObject? = nil, block: Observer.Block) -> Observer {
        return _observe(names, object: object, queue: NSOperationQueue.mainQueue(), block: block)
    }
    
    
    /** observe a single notification guaranteed to be delivered on the main queue */
    public func observeUI(name: String? = nil, object: AnyObject? = nil, block: Observer.Block) -> Observer {
        return _observeUI([name], object: object, block: block)
    }
    
    /** observe a multiple notifications guaranteed to be delivered on the main queue */
    public func observeUI(names: [String], object: AnyObject? = nil, block: Observer.Block) -> Observer {
        return _observeUI(names.map { .Some($0) }, object: object, block: block)
    }
    

    /** observe a single notification: NC.add(notificationName) { notif in  } */
    public func observe(name: String? = nil, object: AnyObject? = nil, queue: NSOperationQueue? = nil, block: Observer.Block) -> Observer {
        return _observe([name], object: object, queue: queue, block: block)
    }
    
    /** observe multiple notifications with a single block: NC.add([name0, name1]) { notif in  } */
    public func observe(names: [String], object: AnyObject? = nil, queue: NSOperationQueue? = nil, block: Observer.Block) -> Observer {
        return _observe(names.map { .Some($0) }, object: object, queue: queue, block: block)
    }
}
