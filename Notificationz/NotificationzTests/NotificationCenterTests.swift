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
    
    class Test: NSObject {
        @objc func trigger() {}
    }
    
    
    let mock = NotificationCenter.Mock()
    lazy var NC: NotificationCenterAdapter = NotificationCenterAdapter(notificationCenter: self.mock)
    
    
    override func tearDown() {
        
        mock.clear()
        super.tearDown()
    }
    
    func testAddSingle() {
        
        let object = Test()
        let selector = #selector(Test.trigger)
        let notification = Notification.Name(rawValue: "testing")
        let anotherObject = NSObject()
        
        NC.add(object, selector: selector, name: notification, object: anotherObject)

        XCTAssertEqual(mock.observers.popLast() as! Test, object)
        XCTAssertEqual(mock.selectors.popLast()!, selector)
        XCTAssertEqual(mock.names.popLast()!, notification)
        XCTAssertEqual(mock.objects.popLast() as! NSObject, anotherObject)
        
        XCTAssertTrue(mock.isEmpty)
    }
    
    func testAddMultiple() {
        
        let object = Test()
        let selector = #selector(Test.trigger)
        let notifications = ["testing", "multiple", "keys"].map { Notification.Name(rawValue: $0) }
        let anotherObject = NSObject()
        
        NC.add(object, selector: selector, names: notifications, object: anotherObject)
        
        notifications.reversed().forEach { name in
            
            XCTAssertEqual(mock.observers.popLast() as! Test, object)
            XCTAssertEqual(mock.selectors.popLast()!, selector)
            XCTAssertEqual(mock.names.popLast()!, name)
            XCTAssertEqual(mock.objects.popLast() as! NSObject, anotherObject)
        }
        
        XCTAssertTrue(mock.isEmpty)
    }
    
    func testPostNotification() {
        
        let notification = Notification(name: Notification.Name(rawValue: "blah"), object: nil)
        NC.post(notification)
        
        XCTAssertEqual(mock.notifications.popLast()!, notification)
        XCTAssertTrue(mock.isEmpty)
    }
    
    func testPostName() {
        
        let name = Notification.Name(rawValue: "testing-this")
        let object = "any!"
        let userInfo: [String:String] = ["key": "value"]
        
        NC.post(name, object: object, userInfo: userInfo)
        
        XCTAssertEqual(mock.names.popLast()!, name)
        XCTAssertEqual(mock.objects.popLast() as! String, object)
        XCTAssertEqual(mock.userInfos.popLast()! as! [String:String], userInfo)
    }
    
    func testObserve() {
        
        let name = Notification.Name(rawValue: "testing-this")
        let object = NSObject()
        let queue = OperationQueue()
        
        var triggerCount = 0
        let block: Observer.Block = { _ in
            triggerCount += 1
        }
        
        let observer = NC.observe(name, object: object, queue: queue, block: block)
        XCTAssert(observer.notificationCenter === NC)
        
        XCTAssertEqual(mock.names.popLast()!, name)
        XCTAssertEqual(mock.objects.popLast()! as! NSObject, object)
        XCTAssertEqual(mock.queues.popLast()!, queue)
        
        // call the block to test
        let newBlock = mock.blocks.popLast()!
        newBlock(Notification(name: Notification.Name(rawValue: ""), object: nil))
        XCTAssertEqual(triggerCount, 1)
        
        XCTAssertTrue(mock.isEmpty)
    }
    
    func testObserveUI() {
        
        let name = Notification.Name(rawValue: "testing-ui")
        let block: Observer.Block = { _ in }
        
        let observer = NC.observeUI(name, block: block)
        XCTAssert(observer.notificationCenter === NC)
        
        XCTAssertEqual(mock.names.popLast()!, name)
        XCTAssertNil(mock.objects.popLast()!)
        XCTAssert(mock.queues.popLast()! === OperationQueue.main)
        XCTAssertNotNil(mock.blocks.popLast())
        
        XCTAssertTrue(mock.isEmpty)
    }
    
    func testRemove() {
        
        let object = NSObject()
        let anotherObject = NSObject()
        let name = Notification.Name(rawValue: "testing")
        
        NC.remove(object, name: name, object: anotherObject)
        
        XCTAssertEqual(mock.observers.popLast() as! NSObject, object)
        XCTAssertEqual(mock.names.popLast()!, name)
        XCTAssertEqual(mock.objects.popLast() as! NSObject, anotherObject)
        
        XCTAssertTrue(mock.isEmpty)
    }
}
