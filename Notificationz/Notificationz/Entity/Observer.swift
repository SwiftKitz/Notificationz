//
//  Observer.swift
//  Notificationz
//
//  Created by Mazyad Alabduljaleel on 11/17/15.
//  Copyright © 2015 kitz. All rights reserved.
//

import Foundation


open class Observer {
    
    public typealias Block = (Notification?) -> ()
    
    let notificationCenter: NotificationCenterAdapter
    let tokens: [NSObjectProtocol]
    let block: Block
    
    // MARK: - Init & Dealloc
    
    init(notificationCenter: NotificationCenterAdapter, tokens: [NSObjectProtocol], block: @escaping Block) {
        
        self.notificationCenter = notificationCenter
        self.tokens = tokens
        self.block = block
    }
    
    deinit {
        tokens.forEach { notificationCenter.remove($0) }
    }
    
    /** You can execute the notification block anytime you like */
    @discardableResult open func execute() -> Self {
        
        block(nil)
        return self
    }
}
