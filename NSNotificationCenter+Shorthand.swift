//
//  NSNotificationCenter+Shorthand.swift
//  MazKit
//
//  Created by Mazyad Alabduljaleel on 12/11/14.
//  Copyright (c) 2014 ArabianDevs. All rights reserved.
//

import Foundation

public class NC: NSObject {

    public class func add(name: String? = nil, object: AnyObject? = nil, block: Observer.Block) -> Observer {
        return add([name], object: object, block: block)
    }
    
    public class func add(names: [String?], object: AnyObject? = nil, block: Observer.Block) -> Observer {
        
        let tokens = names.map {
            
            NSNotificationCenter.defaultCenter().addObserverForName(
                $0,
                object: object,
                queue: NSOperationQueue.mainQueue(),
                usingBlock: block
            )
        }
        
        return Observer(tokens: tokens, block: block)
    }
    
    public class func add(observer: AnyObject, _ sel: Selector, _ name: String?) {
        add(observer, sel, name, nil)
    }
    
    public class func add(observer: AnyObject, _ sel: Selector, _ name: String?, _ object: AnyObject?) {
        NSNotificationCenter.defaultCenter().addObserver(
            observer,
            selector: sel,
            name: name,
            object: object
        )
    }
    
    public class func post(notification notif: NSNotification) {
        NSNotificationCenter.defaultCenter().postNotification(notif)
    }

    public class func post(name: String, _ object: AnyObject? = nil, _ userInfo: [NSObject:AnyObject]? = nil) {
        NSNotificationCenter.defaultCenter().postNotificationName(name, object: object, userInfo: userInfo)
    }
    
    public class func rm(observer: AnyObject, _ name: String? = nil, _ object: String? = nil) {
        NSNotificationCenter.defaultCenter().removeObserver(observer, name: name, object: object)
    }
}

// RAII for Block notifications

public extension NC {

    public class Observer {
        
        public typealias Block = (NSNotification?) -> ()
        
        let tokens: [NSObjectProtocol]
        let block: Block
        
        init(tokens: [NSObjectProtocol], block: Block) {
            
            self.tokens = tokens
            self.block = block
        }
        
        deinit {
            tokens.forEach { NC.rm($0) }
        }
        
        // Awesomeness
        
        public func execute() -> Self {
            
            block(nil)
            return self
        }
    }
}
