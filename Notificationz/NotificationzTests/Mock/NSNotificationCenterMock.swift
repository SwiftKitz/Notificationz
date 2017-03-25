//
//  NSNotificationCenterMock.swift
//  Notificationz
//
//  Created by Mazyad Alabduljaleel on 11/17/15.
//  Copyright © 2015 kitz. All rights reserved.
//

import Foundation
@testable import Notificationz


extension NotificationCenter {

    class Mock: NotificationCenter {
        
        var notifications: [Notification] = []
        var observers: [Any] = []
        var selectors: [Selector] = []
        var names: [Notification.Name?] = []
        var objects: [Any?] = []
        var queues: [OperationQueue?] = []
        var blocks: [(Notification) -> ()] = []
        var userInfos: [[AnyHashable: Any]?] = []
        
        
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
        
        override func addObserver(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name?, object anObject: Any?) {
            
            observers.append(observer)
            selectors.append(aSelector)
            names.append(aName)
            objects.append(anObject)
        }
        
        override func addObserver(forName name: NSNotification.Name?, object obj: Any?, queue: OperationQueue?, using block: @escaping (Notification) -> Void) -> NSObjectProtocol {
            
            names.append(name)
            objects.append(obj)
            queues.append(queue)
            blocks.append(block)
            
            return NSObject()
        }
        
        override func post(_ notification: Notification) {
            notifications.append(notification)
        }
        
        override func post(name aName: NSNotification.Name, object anObject: Any?, userInfo aUserInfo: [AnyHashable: Any]?) {
            
            names.append(aName)
            objects.append(anObject)
            userInfos.append(aUserInfo)
        }
        
        override func removeObserver(_ observer: Any, name aName: NSNotification.Name?, object anObject: Any?) {
            
            observers.append(observer)
            names.append(aName)
            objects.append(anObject)
        }
    }
}
