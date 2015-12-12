//
//  NotificationzTests.swift
//  NotificationzTests
//
//  Created by Mazyad Alabduljaleel on 11/17/15.
//  Copyright © 2015 kitz. All rights reserved.
//

import XCTest
@testable import Notificationz


class NotificationCenterTests: XCTestCase {
    
    let mock = NSNotificationCenter.Mock()
    lazy var NC: NotificationCenterAdapter = NotificationCenterAdapter(notificationCenter: self.mock)
    
    
    override func tearDown() {
        
        mock.clear()
        super.tearDown()
    }
    
    func testAddSingle() {
        
        let object = NSObject()
        let selector = Selector("trigger:")
        let notification = "testing"
        let anotherObject = NSObject()
        
        NC.add(object, selector: selector, name: notification, object: anotherObject)

        XCTAssert(mock.observers.popLast()! === object)
        XCTAssertEqual(mock.selectors.popLast()!, selector)
        XCTAssertEqual(mock.names.popLast()!, notification)
        XCTAssert(mock.objects.popLast()! === anotherObject)
        
        XCTAssertTrue(mock.isEmpty)
    }
    
    func testAddMultiple() {
        
        let object = NSObject()
        let selector = Selector("trigger:")
        let notifications = ["testing", "multiple", "keys"]
        let anotherObject = NSObject()
        
        NC.add(object, selector: selector, names: notifications, object: anotherObject)
        
        notifications.reverse().forEach { name in
            
            XCTAssert(mock.observers.popLast()! === object)
            XCTAssertEqual(mock.selectors.popLast()!, selector)
            XCTAssertEqual(mock.names.popLast()!, name)
            XCTAssert(mock.objects.popLast()! === anotherObject)
        }
        
        XCTAssertTrue(mock.isEmpty)
    }
    
    func testPostNotification() {
        
        let notification = NSNotification(name: "blah", object: nil)
        NC.post(notification)
        
        XCTAssert(mock.notifications.popLast()! === notification)
        
        XCTAssertTrue(mock.isEmpty)
    }
    
    func testPostName() {
        
        let name = "testing-this"
        let object = NSObject()
        let userInfo: [String:String] = ["key": "value"]
        
        NC.post(name, object: object, userInfo: userInfo)
        
        XCTAssertEqual(mock.names.popLast()!, name)
        XCTAssert(mock.objects.popLast()! === object)
        XCTAssertEqual(mock.userInfos.popLast()! as! [String:String], userInfo)
    }
    
    func testObserve() {
        
        let name = "testing-this"
        let object = NSObject()
        let queue = NSOperationQueue()
        
        var triggerCount = 0
        let block: Observer.Block = { _ in
            triggerCount++
        }
        
        let observer = NC.observe(name, object: object, queue: queue, block: block)
        XCTAssert(observer.notificationCenter === NC)
        
        XCTAssertEqual(mock.names.popLast()!, name)
        XCTAssert(mock.objects.popLast()! === object)
        XCTAssert(mock.queues.popLast()! === queue)
        
        // call the block to test
        let newBlock = mock.blocks.popLast()!
        newBlock(NSNotification(name: "", object: nil))
        XCTAssertEqual(triggerCount, 1)
        
        XCTAssertTrue(mock.isEmpty)
    }
    
    func testObserveUI() {
        
        let name = "testing-ui"
        let block: Observer.Block = { _ in }
        
        let observer = NC.observeUI(name, block: block)
        XCTAssert(observer.notificationCenter === NC)
        
        XCTAssertEqual(mock.names.popLast()!, name)
        XCTAssertNil(mock.objects.popLast()!)
        XCTAssert(mock.queues.popLast()! === NSOperationQueue.mainQueue())
        XCTAssertNotNil(mock.blocks.popLast())
        
        XCTAssertTrue(mock.isEmpty)
    }
    
    func testRemove() {
        
        let object = NSObject()
        let anotherObject = NSObject()
        let notification = "testing"
        
        NC.remove(object, name: notification, object: anotherObject)
        
        XCTAssert(mock.observers.popLast()! === object)
        XCTAssertEqual(mock.names.popLast()!, notification)
        XCTAssert(mock.objects.popLast()! === anotherObject)
        
        XCTAssertTrue(mock.isEmpty)
    }
}
