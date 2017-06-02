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
        XCTAssertNil(sut.delegate)
        XCTAssertNotNil(sut.startSliderArm)
        XCTAssertNotNil(sut.endSliderArm)
    }
    
    func test_HandleStartSliderEvent_SetsStartSliderArm_ToStartSliderHandle() {
        
        sut.startSlider.setValue(10, animated: false)
        let endingPoint = CGPoint(x: sut.startSlider.handleCenterX, y: sut.graph.frame.origin.y)
        sut.handleStartSliderEvent(sender: sut.startSlider)
        
        let path = sut.startSliderArm.path!
        let bez = UIBezierPath(cgPath: path)
        
        XCTAssertTrue(bez.contains(endingPoint))
    }
    
    func test_Init_SetEndSliderArm() {
        let frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        let sut = StartEndGraphView(frame: frame)
        XCTAssertNotNil(sut.endSliderArm)
        XCTAssertNotNil(sut.endSliderArm.path)
    }
    
    func test_Init_SetsStartSliderArm() {
        let frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        let sut = StartEndGraphView(frame: frame)
        XCTAssertNotNil(sut.startSliderArm)
        XCTAssertNotNil(sut.startSliderArm.path)
        XCTAssertTrue(sut.layer.sublayers!.contains(sut.startSliderArm))
        let path = sut.startSliderArm.path!
        let bez = UIBezierPath(cgPath: path)
        
        let startPoint = CGPoint(x: sut.startSlider.handleCenterX, y: sut.startSliderArm.frame.origin.y)
        let endPoint = CGPoint(x: startPoint.x, y: sut.graph.frame.origin.y)
        bez.contains(startPoint)
        bez.contains(endPoint)
        XCTAssertEqual(sut.startSliderArmColor?.cgColor, sut.startSliderArm.strokeColor)
        XCTAssertEqual(sut.startSliderArmWidth, sut.startSliderArm.lineWidth)
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
//        XCTAssertEqual(sut.sliderArmTint, sut.startSlider.armTint)
//        XCTAssertEqual(sut.sliderArmWidth, sut.startSlider.armWidth)
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
//        XCTAssertEqual(sut.sliderArmTint, sut.endSlider.armTint)
//        XCTAssertEqual(sut.sliderArmWidth, sut.endSlider.armWidth)
        XCTAssertTrue(sut.subviews.contains(sut.endSlider))
    }
    
    func test_Init_SetsGraphView() {
        let frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        let sut = StartEndGraphView(frame: frame)
        sut.startSlider.handleSize = 20
        sut.endSlider.handleSize = 20
        sut.layoutSubviews()
        XCTAssertNotNil(sut.graph)
        
        XCTAssertEqual(sut.graph.frame.size, CGSize(width: sut.bounds.width - 20, height: sut.bounds.height - 40))
        XCTAssertTrue(sut.subviews.contains(sut.graph))
        
        XCTAssertEqual(sut.graphBackgroundColor, sut.graph.backgroundColor)
        XCTAssertEqual(sut.graphLineTint, sut.graph.lineColor)
        XCTAssertEqual(sut.graphLineWidth, sut.graph.lineWidth)
    }
    
    func test_Init_SetsUpSliderSpace() {
        let frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        let sut = StartEndGraphView(frame: frame)
        
        XCTAssertNotNil(sut.slideShader)
        XCTAssertEqual(sut.slideShaderTint.cgColor, sut.slideShader.fillColor)
        XCTAssertEqual(sut.slideShaderOpacity, sut.slideShader.opacity)
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
    
    func test_LayoutSubviews_ResizesGraph() {
        let frame = CGRect(x: 10, y: 20, width: 200, height: 300)
        sut.frame = frame
        sut.layoutSubviews()
        let expectedSize = CGSize(width: frame.width-sut.startSlider.handleSize, height: frame.height-(sut.startSlider.frame.height * 2))
        XCTAssertEqual(sut.graph.frame.size, expectedSize)
    }
    
    func test_LayouSubviews_LaysOutStartSliderArm() {
        let frame = CGRect(x: 10, y: 20, width: 200, height: 300)
        sut.frame = frame
        sut.layoutSubviews()
        
        let topPoint = CGPoint(x: sut.startSlider.handleCenterX, y: sut.graph.frame.origin.y)
        let botPoint = CGPoint(x: topPoint.x, y: topPoint.y + sut.graph.frame.height)
        
        let bez = UIBezierPath(cgPath: sut.startSliderArm.path!)
        XCTAssertTrue(bez.contains(topPoint))
        XCTAssertTrue(bez.contains(botPoint))
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
        
//        sut.setNeedsDisplay()
        
        let location = CGPoint(x: sut.frame.width/2, y: 0)
        let touchMock = MockTouch(location: location)
        _ = sut.startSlider.continueTracking(touchMock, with: nil)
        
//        sut.setNeedsDisplay()
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
    
    // MARK: causes exception
    func test_EndSlider_ContinuesStick_AfterPassedRight() {
        
        passEndSliderWithStart()
        
        let location = CGPoint(x: 20, y: 0)
        let touchMock = MockTouch(location: location)
        _ = sut.startSlider.continueTracking(touchMock, with: nil)
        
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
        
        passStartWithEndSlider()
        
        XCTAssertEqual(sut.endSlider.handleCenterX, sut.startSlider.handleCenterX)
    }
    
    func passStartWithEndSlider() {
        let endLoc = CGPoint(x: sut.bounds.width, y: 0)
        let touchEnd = MockTouch(location: endLoc)
        _ = sut.endSlider.continueTracking(touchEnd, with: nil)
        
        let startLoc = CGPoint(x: sut.bounds.width/2, y: 0)
        let touchStart = MockTouch(location: startLoc)
        _ = sut.startSlider.continueTracking(touchStart, with: nil)
        
        let finalLoc = CGPoint.zero
        let touchFinal = MockTouch(location: finalLoc)
        _ = sut.endSlider.continueTracking(touchFinal, with: nil)
    }
    
    func test_EndSliderStickingToStart_RemovesSlideShaderToLayer() {
        
        sut.slideShader.removeFromSuperlayer()
        sut.layer.addSublayer(sut.slideShader)
        passEndSliderWithStart()
        
        XCTAssertEqual(sut.startSlider.handleCenterX, sut.endSlider.handleCenterX)
        XCTAssertFalse(sut.layer.sublayers!.contains(sut.slideShader))
    }
    
    func test_EndSliderMovesAwayFromStart_AddsSlideShaderToLayer() {
        
        passEndSliderWithStart()
        
        let startLoc = CGPoint(x: sut.bounds.width, y: 0)
        let touchMock = MockTouch(location: startLoc)
        _ = sut.endSlider.continueTracking(touchMock, with: nil)
        
        XCTAssertTrue(sut.layer.sublayers!.contains(sut.slideShader))
    }
    
    func test_StartSliderMovesAwayFromEnd_WhenNotSticking_AddsSlideShaderToLayer() {
        
        sut.slideShader.removeFromSuperlayer()
        let loc = CGPoint.zero
        let touchMock = MockTouch(location: loc)
        _ = sut.startSlider.continueTracking(touchMock, with: nil)
        
        XCTAssertTrue(sut.layer.sublayers!.contains(sut.slideShader))
    }
    
    func test_SlideShaderSize_EqualsDistanceBetweenStartEnd() {
        
        let startLoc = CGPoint.zero
        let startTouch = MockTouch(location: startLoc)
        _ = sut.startSlider.continueTracking(startTouch, with: nil)
        
        let endLoc = CGPoint(x: sut.bounds.width, y: 0)
        let endTouch = MockTouch(location: endLoc)
        _ = sut.endSlider.continueTracking(endTouch, with: nil)
        
        let distance = sut.endSlider.handleCenterX - sut.startSlider.handleCenterX
        
        let bez = UIBezierPath(cgPath: sut.slideShader.path!)
        XCTAssertEqual(bez.bounds.width, distance)
    }
    
    func test_SetDataSource_SetsGraphDataSource() {
        
        let dataSource = GraphManager()
        sut.setDataSource(dataSource)
        
        XCTAssertNotNil(sut.graph.dataSource)
    }
    
    func test_DelegateCallsStartValChanged_WhenStartValChanges() {
        
        let mockDel = MockConformingDelegate()
        mockDel.startValueChanged = false
        
        sut.delegate = mockDel
        let startLoc = CGPoint.zero
        let startTouch = MockTouch(location: startLoc)
        _ = sut.startSlider.continueTracking(startTouch, with: nil)
        
        XCTAssertTrue(mockDel.startValueChanged)
    }
    
    func test_DelegateCallsEndValueChanged_WhenEndValChanges() {
        
        let mockDel = MockConformingDelegate()
        mockDel.endValueChanged = false
        
        sut.delegate = mockDel
        let loc = CGPoint.zero
        let touch = MockTouch(location: loc)
        _ = sut.endSlider.continueTracking(touch, with: nil)
        
        XCTAssertTrue(mockDel.endValueChanged)
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
    
    class MockConformingDelegate: StartEndGraphViewDelegate {
        
        var endValueChanged = false
        func startEndGraph(view: StartEndGraphView, changedEnd value: Float) {
            endValueChanged = true
        }
        
        var startValueChanged = false
        func startEndGraph(view: StartEndGraphView, changedStart value: Float) {
            startValueChanged = true
        }
    }
}








