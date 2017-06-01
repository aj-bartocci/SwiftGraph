//
//  StartEndGraphViewTests.swift
//  SwiftGraph
//
//  Created by Albert Bartocci on 5/31/17.
//  Copyright © 2017 AJ Bartocci. All rights reserved.
//

import XCTest

@testable import SwiftGraph
class StartEndGraphViewTests: XCTestCase {
    
    var sut: StartEndGraphView!
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        sut = StartEndGraphView(frame: frame)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil 
        super.tearDown()
    }
    
    func test_Init() {
        let frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        let sut = StartEndGraphView(frame: frame)
        XCTAssertEqual(sut.minimumValue, 0)
        XCTAssertEqual(sut.maximumValue, 1)
//        XCTAssertEqual(sut.currentValue, 0.5)
//        
//        XCTAssertEqual(sut.startSlider.value, CGFloat(sut.currentValue))
//        XCTAssertEqual(sut.endSlider.value, CGFloat(sut.currentValue))
        XCTAssertEqual(sut.startSlider.maxValue, CGFloat(sut.maximumValue))
        XCTAssertEqual(sut.endSlider.maxValue, CGFloat(sut.maximumValue))
        XCTAssertEqual(sut.endSlider.minValue, CGFloat(sut.minimumValue))
        XCTAssertEqual(sut.startSlider.minValue, CGFloat(sut.minimumValue))
    }
    
    func test_Init_SetsStartSlider() {
        let frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        let sut = StartEndGraphView(frame: frame)
        XCTAssertNotNil(sut.startSlider)
        XCTAssertNotNil(sut.startHandleSize)
        XCTAssertNotNil(sut.startHandleTint)
        XCTAssertNotNil(sut.startLineTint)
        XCTAssertEqual(sut.startSlider.frame.width, sut.frame.width)
        XCTAssertEqual(sut.startSlider.frame.height, sut.startHandleSize)
        XCTAssertEqual(sut.startHandleTint, sut.startSlider.handleTint)
        XCTAssertEqual(sut.startLineTint, sut.startSlider.lineTint)
        XCTAssertTrue(sut.subviews.contains(sut.startSlider))
    }
    
    func test_Init_SetsEndSlider() {
        let frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        let sut = StartEndGraphView(frame: frame)
        XCTAssertNotNil(sut.endSlider)
        XCTAssertNotNil(sut.endHandleSize)
        XCTAssertEqual(sut.endSlider.frame.width, sut.frame.width)
        XCTAssertEqual(sut.endSlider.frame.height, sut.endHandleSize)
        XCTAssertNotNil(sut.endHandleTint)
        XCTAssertNotNil(sut.endLineTint)
        XCTAssertEqual(sut.endHandleTint, sut.endSlider.handleTint)
        XCTAssertEqual(sut.endLineTint, sut.endSlider.lineTint)
        XCTAssertTrue(sut.subviews.contains(sut.endSlider))
    }
    
    func test_Init_SetsGraphView() {
        let frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        let sut = StartEndGraphView(frame: frame)
        XCTAssertNotNil(sut.graph)
        
    }
    
    func test_LayoutSubviews_ResizesStartSlider() {
        let frame = CGRect(x: 10, y: 20, width: 200, height: 300)
        sut.frame = frame
        sut.layoutSubviews()
        
        XCTAssertEqual(sut.startSlider.frame.width, frame.width)
    }
    
    func test_LayoutSubviews_ResizesEndSlider() {
        let frame = CGRect(x: 10, y: 20, width: 200, height: 300)
        sut.frame = frame
        sut.layoutSubviews()
        
        XCTAssertEqual(sut.endSlider.frame.width, frame.width)
    }
    
    func test_StartSlider_Target_EqualsSelf() {
        guard let actions = sut.startSlider.actions(forTarget: sut, forControlEvent: .valueChanged) else {
            return XCTFail()
        }
        XCTAssertEqual(actions.first, "handleStartSliderEventWithSender:")
    }
    
    func test_EndSlider_Target_EqualsSelf() {
        guard let actions = sut.endSlider.actions(forTarget: sut, forControlEvent: .valueChanged) else {
            return XCTFail()
        }
        XCTAssertEqual(actions.first, "handleEndSliderEventWithSender:")
    }
    
    func test_EndSlider_SticksToStart_WhenPassedRight() {
        
        passEndSliderWithStart()
        XCTAssertEqual(sut.startSlider.handleCenterX, sut.endSlider.handleCenterX)
        
    }
    
    func passEndSliderWithStart() {
        sut.startSlider.maxValue = 10
        sut.endSlider.maxValue = 10
        sut.startSlider.value = 1
        sut.endSlider.value = 3
        
        sut.setNeedsDisplay()
        
        let location = CGPoint(x: sut.frame.width/2, y: 0)
        let touchMock = MockTouch(location: location)
        _ = sut.startSlider.continueTracking(touchMock, with: nil)
        
        sut.setNeedsDisplay()
    }
    
    func test_EndSlider_NotStickToStart_WhenStartIsLeft() {
        
        sut.endSlider.maxValue = 10
        sut.startSlider.maxValue = 10
        sut.startSlider.value = 2
        sut.endSlider.value = 3
        
        sut.setNeedsDisplay()
        
        let location = CGPoint.zero
        let touchMock = MockTouch(location: location)
        _ = sut.startSlider.continueTracking(touchMock, with: nil)
        
        sut.setNeedsDisplay()
        
        XCTAssertNotEqual(sut.startSlider.handleCenterX, sut.endSlider.handleCenterX)
    }
    
    func test_EndSlider_ContinuesStick_AfterPassedRight() {
        
        passEndSliderWithStart()
        
        let location = CGPoint.zero
        let touchMock = MockTouch(location: location)
        _ = sut.startSlider.continueTracking(touchMock, with: nil)
        
        sut.setNeedsDisplay()
        
        XCTAssertEqual(sut.startSlider.handleCenterX, sut.endSlider.handleCenterX)
    }
    
    func test_EndSlider_UnsticksFromStart_WhenMovingRight() {
        
        passEndSliderWithStart()
        
        let endLoc = CGPoint(x: sut.bounds.width, y: 0)
        let touch = MockTouch(location: endLoc)
        _ = sut.endSlider.continueTracking(touch, with: nil)
        
        let location = CGPoint.zero
        let touchMock = MockTouch(location: location)
        _ = sut.startSlider.continueTracking(touchMock, with: nil)
        
        XCTAssertNotEqual(sut.startSlider.handleCenterX, sut.endSlider.handleCenterX)
    }
    
    func test_EndSlider_SticksToStart_WhenPassingLeft() {
        
        let endLoc = CGPoint(x: sut.bounds.width, y: 0)
        let touchEnd = MockTouch(location: endLoc)
        _ = sut.endSlider.continueTracking(touchEnd, with: nil)
        
        let startLoc = CGPoint(x: sut.bounds.width/2, y: 0)
        let touchStart = MockTouch(location: startLoc)
        _ = sut.startSlider.continueTracking(touchStart, with: nil)
        
        let finalLoc = CGPoint.zero
        let touchFinal = MockTouch(location: finalLoc)
        _ = sut.endSlider.continueTracking(touchFinal, with: nil)
        
        XCTAssertEqual(sut.endSlider.handleCenterX, sut.startSlider.handleCenterX)
    }
    
}


extension StartEndGraphViewTests {
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








