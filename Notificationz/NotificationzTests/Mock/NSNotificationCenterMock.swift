//
//  NSNotificationCenterMock.swift
//  Notificationz
//
//  Created by Mazyad Alabduljaleel on 11/17/15.
//  Copyright © 2015 kitz. All rights reserved.
//

import Foundation
@testable import Notificationz


extension NSNotificationCenter {

    class Mock: NSNotificationCenter {
        
        var notifications = [NSNotification]()
        var observers = [AnyObject]()
        var selectors = [Selector]()
        var names = [String?]()
        var objects = [AnyObject?]()
        var queues = [NSOperationQueue?]()
        var blocks: [(NSNotification) -> ()] = []
        var userInfos = [[NSObject:AnyObject]?]()
        
        
        var isEmpty: Bool {
            
            return (
                notifications.isEmpty
                    && observers.isEmpty
                    && selectors.isEmpty
                    && names.isEmpty
                    && queues.isEmpty
                    && blocks.isEmpty
                    && objects.isEmpty
                    && userInfos.isEmpty
            )
        }
        
        func clear() {
            
            notifications.removeAll()
            observers.removeAll()
            selectors.removeAll()
            names.removeAll()
            queues.removeAll()
            blocks.removeAll()
            objects.removeAll()
            userInfos.removeAll()
        }
        
        override func addObserver(observer: AnyObject, selector aSelector: Selector, name aName: String?, object anObject: AnyObject?) {
            
            observers.append(observer)
            selectors.append(aSelector)
            names.append(aName)
            objects.append(anObject)
        }
        
        override func addObserverForName(name: String?, object obj: AnyObject?, queue: NSOperationQueue?, usingBlock block: (NSNotification) -> Void) -> NSObjectProtocol {
            
            names.append(name)
            objects.append(obj)
            queues.append(queue)
            blocks.append(block)
            
            return NSObject()
        }
        
        override func postNotification(notification: NSNotification) {
            notifications.append(notification)
        }
        
        override func postNotificationName(aName: String, object anObject: AnyObject?, userInfo aUserInfo: [NSObject : AnyObject]?) {
            
            names.append(aName)
            objects.append(anObject)
            userInfos.append(aUserInfo)
        }
        
        override func removeObserver(observer: AnyObject, name aName: String?, object anObject: AnyObject?) {
            
            observers.append(observer)
            names.append(aName)
            objects.append(anObject)
        }
    }
}
