//
//  Observer.swift
//  Notificationz
//
//  Created by Mazyad Alabduljaleel on 11/17/15.
//  Copyright © 2015 kitz. All rights reserved.
//

import Foundation


public class Observer {
    
    public typealias Block = (NSNotification?) -> ()
    
    let notificationCenter: NotificationCenterAdapter
    let tokens: [NSObjectProtocol]
    let block: Block
    
    // MARK: - Init & Dealloc
    
    init(notificationCenter: NotificationCenterAdapter, tokens: [NSObjectProtocol], block: Block) {
        
        self.notificationCenter = notificationCenter
        self.tokens = tokens
        self.block = block
    }
    
    deinit {
        tokens.forEach { notificationCenter.remove($0) }
    }
    
    /** You can execute the notification block anytime you like */
    public func execute() -> Self {
        
        block(nil)
        return self
    }
}
