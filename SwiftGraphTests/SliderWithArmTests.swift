//
//  SliderWithArmTests.swift
//  SwiftGraph
//
//  Created by Albert Bartocci on 5/31/17.
//  Copyright © 2017 AJ Bartocci. All rights reserved.
//

import XCTest

@testable import SwiftGraph
class SliderWithArmTests: XCTestCase {
    
    var sut: SliderWithArm!
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = SliderWithArm(frame: CGRect(x: 0, y: 0, width: 100, height: 80))
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        super.tearDown()
    }
    
    func test_Init() {
        let sut = SliderWithArm()
        XCTAssertEqual(sut.movement, .stationary)
    }
    
    func test_BeginTracking_InHandle_ReturnsTrue() {
        
        sut.minValue = 0
        sut.maxValue = 1
        sut.value = 0.5
        sut.handleSize = 20
        let point = CGPoint(x: 50, y: 70)
        let touchMock = MockTouch(location: point)
        
        let mid = sut.beginTracking(touchMock, with: nil)
        XCTAssertTrue(mid)
        
        touchMock.locInView = CGPoint(x: 59, y: 70)
        let right = sut.beginTracking(touchMock, with: nil)
        XCTAssertTrue(right)
        
        touchMock.locInView = CGPoint(x: 41, y: 70)
        let left = sut.beginTracking(touchMock, with: nil)
        XCTAssertTrue(left)
    }
    
    func test_BeginTracking_OutsideHandle_ReturnsFalse() {
        
        sut.minValue = 0
        sut.maxValue = 1
        sut.value = 0.5
        let point = CGPoint(x: 50, y: 20)
        let touchMock = MockTouch(location: point)
        
        let top = sut.beginTracking(touchMock, with: nil)
        XCTAssertFalse(top)
        
        touchMock.locInView = CGPoint(x: 39, y: 70)
        let left = sut.beginTracking(touchMock, with: nil)
        XCTAssertFalse(left)
        
        touchMock.locInView = CGPoint(x: 61, y: 70)
        let right = sut.beginTracking(touchMock, with: nil)
        XCTAssertFalse(right)
        
        touchMock.locInView = CGPoint(x: 50, y: 81)
        let bot = sut.beginTracking(touchMock, with: nil)
        XCTAssertFalse(bot)
    }
    
    func test_ContinueTracking_InBounds_SetsLabelPosition() {
        
        let label = UILabel(frame: CGRect(x: 50, y: 0, width: 30, height: 20))
        sut.label = label
        let point = CGPoint(x: 75, y: 70)
        let touchMock = MockTouch(location: point)
        _ = sut.continueTracking(touchMock, with: nil)
        
        XCTAssertEqual(sut.handleCenterX, sut.labelCenterX)
    }
    
    func test_ContinueTracking_BelowBounds_SetsLabelPositionMin() {
        
        let label = UILabel(frame: CGRect(x: -1, y: 0, width: 30, height: 20))
        sut.label = label
        let point = CGPoint(x: 0, y: 70)
        let touchMock = MockTouch(location: point)
        _ = sut.continueTracking(touchMock, with: nil)
        
        let expectedLabelX = label.frame.width * 0.5
        XCTAssertEqual(expectedLabelX, sut.labelCenterX)
    }
    
    func test_ContinueTracking_BeyondBounds_SetsLabelPositionMax() {
        
        let label = UILabel(frame: CGRect(x: 101, y: 0, width: 30, height: 20))
        sut.label = label
        let point = CGPoint(x: 100, y: 70)
        let touchMock = MockTouch(location: point)
        _ = sut.continueTracking(touchMock, with: nil)
        
        let expectedLabelX = sut.frame.width-(label.frame.width * 0.5)
        XCTAssertEqual(expectedLabelX, sut.labelCenterX)
    }
    
    func test_SetValue_NotAnimated_UpdatesValue() {
        
        sut.minValue = 0
        sut.value = 0
        sut.maxValue = 10
        
        sut.setValue(5, animated: false)
        
        XCTAssertEqual(sut.value, 5)
    }
    
    func test_ValueIncrease_SetsMovement_ToRight() {
        
        sut.minValue = 0
        sut.value = 0
        sut.maxValue = 10
        
        sut.setValue(5, animated: false)
        
        XCTAssertEqual(sut.movement, .right)
    }
    
    func test_ValueDecrease_SetsMovement_ToLeft() {
        sut.minValue = 0
        sut.value = 5
        sut.maxValue = 10
        
        sut.setValue(0, animated: false)
        
        XCTAssertEqual(sut.movement, .left)
    }
    
    func test_ValueStaysSame_SetsMovement_ToStationary() {
        
        sut.minValue = 0
        sut.value = 1
        sut.maxValue = 10
        
        sut.movement = .right
        sut.setValue(6, animated: false)
        sut.setValue(6, animated: false)
        
        XCTAssertEqual(sut.movement, .stationary)
    }
    
    func test_EndTracking_SetsMovement_ToStationary() {
        
        sut.minValue = 0
        sut.maxValue = 10
        sut.value = 5
        
        sut.setValue(6, animated: false)
        sut.endTracking(nil, with: nil)
        
        XCTAssertEqual(sut.movement, .stationary)
    }
    
}

extension SliderWithArmTests {
    
    class MockTouch: UITouch {
        
        var locInView: CGPoint
        init(location: CGPoint) {
            locInView = location
        }
        
        override func location(in view: UIView?) -> CGPoint {
            return locInView
        }
    }
}
