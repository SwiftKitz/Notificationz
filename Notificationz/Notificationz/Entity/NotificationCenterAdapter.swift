//
//  NotificationCenterAdapter.swift
//  Notificationz
//
//  Created by Mazyad Alabduljaleel on 11/17/15.
//  Copyright © 2015 kitz. All rights reserved.
//

import Foundation


open class NotificationCenterAdapter {
    
    open let notificationCenter: NotificationCenter
    
    // MARK: - Init & Dealloc
    
    public init(notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
    }
    
    // MARK: - Public methods
    
    open func add(_ observer: Any, selector: Selector, names: [Notification.Name], object: Any? = nil) {
        names.forEach { self.add(observer, selector: selector, name: $0, object: object) }
    }
    
    open func add(_ observer: Any, selector: Selector, name: Notification.Name? = nil, object: Any? = nil) {
        
        notificationCenter.addObserver(
            observer,
            selector: selector,
            name: name,
            object: object
        )
    }
    
    open func post(_ name: Notification.Name, object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        notificationCenter.post(name: name, object: object, userInfo: userInfo)
    }
    
    open func post(_ notification: Notification) {
        notificationCenter.post(notification)
    }
    
    open func remove(_ observer: Any, name: NSNotification.Name? = nil, object: Any? = nil) {
        notificationCenter.removeObserver(observer, name: name, object: object)
    }
}


/**
    Observer support
*/

extension NotificationCenterAdapter {
    
    fileprivate func _observe(_ names: [Notification.Name?], object: Any? = nil, queue: OperationQueue? = nil, block: @escaping Observer.Block) -> Observer {
        
        let tokens = names.map {
            
            self.notificationCenter.addObserver(
                forName: $0,
                object: object,
                queue: queue,
                using: block
            )
        }
        
        return Observer(notificationCenter: self, tokens: tokens, block: block)
    }
    
    fileprivate func _observeUI(_ names: [Notification.Name?], object: Any? = nil, block: @escaping Observer.Block) -> Observer {
        return _observe(names, object: object, queue: OperationQueue.main, block: block)
    }
    
    
    /** observe a single notification guaranteed to be delivered on the main queue */
    
    public func observeUI(_ name: Notification.Name? = nil, object: Any? = nil, block: @escaping Observer.Block) -> Observer {
        return _observeUI([name], object: object, block: block)
    }
    
    /** observe a multiple notifications guaranteed to be delivered on the main queue */
    
    public func observeUI(_ names: [Notification.Name], object: Any? = nil, block: @escaping Observer.Block) -> Observer {
        return _observeUI(names.map { .some($0) }, object: object, block: block)
    }
    

    /** observe a single notification: NC.add(notificationName) { notif in  } */
    
    public func observe(_ name: Notification.Name? = nil, object: Any? = nil, queue: OperationQueue? = nil, block: @escaping Observer.Block) -> Observer {
        return _observe([name], object: object, queue: queue, block: block)
    }
    
    /** observe multiple notifications with a single block: NC.add([name0, name1]) { notif in  } */
    
    public func observe(_ names: [Notification.Name], object: Any? = nil, queue: OperationQueue? = nil, block: @escaping Observer.Block) -> Observer {
        return _observe(names.map { .some($0) }, object: object, queue: queue, block: block)
    }
}
