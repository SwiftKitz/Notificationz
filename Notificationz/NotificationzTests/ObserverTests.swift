//
//  Observer.swift
//  Notificationz
//
//  Created by Mazyad Alabduljaleel on 11/17/15.
//  Copyright © 2015 kitz. All rights reserved.
//

import XCTest
@testable import Notificationz


class ObserverTests: XCTestCase {

    let mock = NotificationCenter.Mock()
    lazy var NC: NotificationCenterAdapter = NotificationCenterAdapter(notificationCenter: self.mock)
    
    override func tearDown() {
        
        mock.clear()
        super.tearDown()
    }
    
    
    func testInitialization() {

        var triggerCount = 0
        
        let tokens = [NSObject()]
        let block: Observer.Block = { _ in
            triggerCount += 1
        }
        
        let observer = Observer(notificationCenter: NC, tokens: tokens, block: block)

        XCTAssert(observer.notificationCenter === NC)
        XCTAssertEqual(observer.tokens as! [NSObject], tokens)
        
        observer.execute()
        XCTAssertEqual(triggerCount, 1)
    }
    
    func testExecute() {
        
        var triggerCount = 0
        
        Observer(notificationCenter: NC, tokens: []) { _ in
            triggerCount += 1
        }.execute()
        
        XCTAssertEqual(triggerCount, 1)
    }
    
    func testObserverCleanup() {
        
        do {
            let observer = Observer(notificationCenter: NC, tokens: [NSObject()]) { _ in }
            XCTAssertEqual(observer.tokens.count, 1) // silence warning
        }
        
        XCTAssertNotNil(mock.observers.popLast())
        XCTAssertEqual(mock.names.popLast(), .some(.none))
        XCTAssertNil(mock.objects.popLast()!)
        
        XCTAssertTrue(mock.isEmpty)
    }
}
