//
//  CustomSliderTests.swift
//  SwiftGraph
//
//  Created by Albert Bartocci on 5/25/17.
//  Copyright © 2017 AJ Bartocci. All rights reserved.
//

import XCTest
@testable import SwiftGraph

class CustomSliderTests: XCTestCase {
    
    var sut: CustomSlider!
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = CustomSlider(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        super.tearDown()
    }
    
    func test_Init() {
        let sut = CustomSlider()
        XCTAssertNotNil(sut.minValue)
        XCTAssertNotNil(sut.maxValue)
        XCTAssertNotNil(sut.value)
        XCTAssertTrue(sut.isContinous)
    }
    
    func test_ContinueTracking_ReturnsTrue_IfContinuous() {
        sut.isContinous = true
        
        let touch = UITouch()
        let event = UIEvent()
        let isCont = sut.continueTracking(touch, with: event)
        XCTAssertTrue(isCont)
    }
    
    func test_ContinueTracking_ReturnsFalse_IfNotContinuous() {
        sut.isContinous = false
        
        let touch = UITouch()
        let event = UIEvent()
        let isCont = sut.continueTracking(touch, with: event)
        XCTAssertFalse(isCont)
    }
    
    func test_BeginTracking_TouchOutsideHandle_ReturnsFalse() {
        
        sut.value = 0.5
        sut.handleSize = 30
        let touch = MockTouch(location: CGPoint(x: 12.5, y: 15))
        let shouldStart = sut.beginTracking(touch, with: nil)

        XCTAssertFalse(shouldStart)
    }
    
    func test_BeginTracking_TouchInsideHandle_ReturnsTrue() {
        
//        let frame = CGRect(x: 0, y: 0, width: 100, height: 30)
//        let sut = CustomSlider(frame: frame)
        sut.value = 0.5
        sut.handleSize = 30
        let midXValue = sut.frame.width/2 + 15
        let midYValue = sut.frame.height/2
        
        let touch = MockTouch(location: CGPoint(x: midXValue, y: midYValue))
        let shouldStart = sut.beginTracking(touch, with: nil)
        XCTAssertTrue(shouldStart)
    }
    
    func test_ContinueTracking_SetsValueTo_Half() {
        
        sut.value = 0.0
        
        let midPoint = CGPoint(x: sut.frame.width/2, y: sut.frame.height/2)
        let mockTouch = MockTouch(location: midPoint)
        _ = sut.continueTracking(mockTouch, with: nil)
        
        XCTAssertEqual(sut.value, 0.5)
    }
    
    func test_ContinueTracking_SetValueTo_Zero() {
        
        sut.value = 0.0
        
        let point = CGPoint(x: 0, y: 15)
        
        let mockTouch = MockTouch(location: point)
        _ = sut.continueTracking(mockTouch, with: nil)
        
        XCTAssertEqual(sut.value, 0.0)
    }
    
    func test_ContinueTracking_SetsValueTo_Two_WithOneThreeOffset() {
        
        sut.value = 0.0
        sut.minValue = 1.0
        sut.maxValue = 3.0
        let midPoint = CGPoint(x: 50, y: 30)
        let mockTouch = MockTouch(location: midPoint)
        _ = sut.continueTracking(mockTouch, with: nil)
        
        XCTAssertEqual(sut.value, 2.0)
    }
    
    func test_ContinueTracking_SetsValueTo_Six_WithTwoTenOffset() {
        
        sut.value = 0.0
        sut.minValue = 2.0
        sut.maxValue = 10.0
        let midPoint = CGPoint(x: 50, y: 30)
        let mockTouch = MockTouch(location: midPoint)
        _ = sut.continueTracking(mockTouch, with: nil)
        
        XCTAssertEqual(sut.value, 6.0)
    }
    
    func test_ContinueTracking_Continous_UpdatesValue() {
        
        sut.isContinous = true
        sut.value = 0.0
        
        let mid = CGPoint(x: 50, y: 30)
        let mockTouch = MockTouch(location: mid)
        _ = sut.continueTracking(mockTouch, with: nil)
        
        XCTAssertTrue(sut.value != 0.0)
    }
    
    func test_ContinueTracking_NotContinuous_DoesNotUpdateValue() {
        
        sut.isContinous = false
        sut.value = 0.0
        
        let point = CGPoint(x: 50, y: 30)
        let mockTouch = MockTouch(location: point)
        _ = sut.continueTracking(mockTouch, with: nil)
        
        XCTAssertEqual(sut.value, 0.0)
    }
    
    func test_EndTracking_SetsValue_ToOne() {
        
        sut.value = 0.0
        sut.minValue = 0.0
        sut.maxValue = 2.0
        let point = CGPoint(x: 50, y: 10)
        let mockT = MockTouch(location: point)
        
        sut.endTracking(mockT, with: nil)
        XCTAssertEqual(sut.value, 1.0)
    }
    
    func test_EndTracking_SetsValue_ToHalf() {
        
        sut.value = 0.0
        let point = CGPoint(x: 50, y: 30)
        let touchMock = MockTouch(location: point)
        
        sut.endTracking(touchMock, with: nil)
        XCTAssertEqual(sut.value, 0.5)
    }
    
    func test_RelativeValue_Returns_Half() {
        
        sut.value = 1
        sut.maxValue = 2
        sut.minValue = 0
        
        XCTAssertEqual(sut.relativeValue, 0.5)
    }
    
    func test_RelativeValue_Returns_ThreeFourths() {
        sut.value = 4
        sut.minValue = 1
        sut.maxValue = 5
        
        XCTAssertEqual(sut.relativeValue, 0.75)
    }
    
    func test_SetValue_PointBeyondWidth_SetsValueToMax() {
        
        sut.minValue = 0
        sut.maxValue = 5
        
        let point = CGPoint(x: 110, y: 30)
        let touchMock = MockTouch(location: point)
        
        sut.setValue(using: touchMock)
        
        XCTAssertEqual(sut.value, sut.maxValue)
    }
    
    func test_SetValue_PointBelowWidth_SetsValueToMin() {
        
        sut.minValue = 0
        sut.maxValue = 5
        
        let point = CGPoint(x: -10, y: 30)
        let touchMock = MockTouch(location: point)
        
        sut.setValue(using: touchMock)
        
        XCTAssertEqual(sut.value, sut.minValue)
    }
    
    func test_ContinueTracking_SendsValueChanged() {
        
        valueChangedCalled = false
        sut.addTarget(self, action: #selector(handleValueChanged(sender:)), for: .valueChanged)
        _ = sut.continueTracking(UITouch(), with: nil)
        
        XCTAssertTrue(valueChangedCalled)
    }
    
    var valueChangedCalled = false
    func handleValueChanged(sender: CustomSlider) {
        valueChangedCalled = true
    }
    
}

extension CustomSliderTests {
    
    class MockTouch: UITouch {
        
        var locInView: CGPoint
        init(location: CGPoint) {
            locInView = location
            
        }
        
        override func location(in view: UIView?) -> CGPoint {
            return locInView
        }
    }
    
//    class MockCustomSlider: CustomSlider {
//        
//        var calledDrawRect = false
//        override func setNeedsDisplay() {
//            super.setNeedsDisplay()
//            calledDrawRect = true
//        }
//        
//        override func setValue(using touch: UITouch) {
//            calledDrawRect = true
//        }
//    }
}
