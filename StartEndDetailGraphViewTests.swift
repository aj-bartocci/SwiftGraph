//
//  StartEndDetailGraphViewTests.swift
//  SwiftGraph
//
//  Created by Albert Bartocci on 6/1/17.
//  Copyright © 2017 AJ Bartocci. All rights reserved.
//

import XCTest

@testable import SwiftGraph
class StartEndDetailGraphViewTests: XCTestCase {
    
    var sut: StartEndDetailGraphView!
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let frame = CGRect(x: 0, y: 0, width: 400, height: 300)
        sut = StartEndDetailGraphView(frame: frame)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        super.tearDown()
    }
    
    func test_Init_SetsUpStartLabel() {
        XCTAssertNotNil(sut.startLabel)
        
        XCTAssertEqual(sut.startLabelSize, sut.startLabel.frame.size)
        XCTAssertTrue(sut.subviews.contains(sut.startLabel))
        XCTAssertEqual(sut.startLabel.textAlignment, .center)
        XCTAssertEqual(sut.startLabelTitle, sut.startLabel.text)
        XCTAssertEqual(sut.startLabel.minimumScaleFactor, 0.5)
        XCTAssertTrue(sut.startLabel.adjustsFontSizeToFitWidth)
        XCTAssertEqual(sut.startLabelFontSize, sut.startLabel.font.pointSize)
        XCTAssertEqual(sut.startLabel.textColor, sut.startLabelColor)

        XCTAssertEqual(sut.startLabel.center.x, sut.startSlider.handleCenterX)
        XCTAssertTrue(sut.startLabel.frame.origin.y >= sut.startSlider.frame.origin.y + sut.startSlider.frame.height)
        XCTAssertEqual(sut.startLabel.text, sut.startLabelTitle)
    }
    
    func test_Init_SetsUpEndLabel() {
        XCTAssertNotNil(sut.endLabel)
        
        XCTAssertTrue(sut.subviews.contains(sut.endLabel))
        XCTAssertEqual(sut.endLabel.textAlignment, .center)
        XCTAssertEqual(sut.endLabel.minimumScaleFactor, 0.5)
        XCTAssertTrue(sut.endLabel.adjustsFontSizeToFitWidth)
        XCTAssertEqual(sut.endLabelSize, sut.endLabel.frame.size)
        XCTAssertEqual(sut.endLabelTitle, sut.endLabel.text)
        XCTAssertEqual(sut.endLabelFontSize, sut.endLabel.font.pointSize)
        XCTAssertEqual(sut.endLabelColor, sut.endLabel.textColor)
        
        XCTAssertEqual(sut.endLabel.center.x, sut.endSlider.handleCenterX)
        XCTAssertEqual(sut.endLabel.frame.origin.y, 0)
    }
    
    func test_Init_SetsStartSlider() {
        XCTAssertTrue(sut.startSlider.frame.origin.y+sut.startSlider.frame.height <= sut.startLabel.frame.origin.y)
    }
    
    func test_StartLabelSize_SetsStartSliderAbove() {
        sut.startLabelSize = CGSize(width: 50, height: 20)
        sut.layoutSubviews()
        XCTAssertNotEqual(sut.startLabel.frame.origin.y, sut.startSlider.frame.origin.y)
    }
    
    func test_Init_SetsEndSlider() {
        XCTAssertTrue(sut.endLabel.frame.origin.y + sut.endLabel.frame.height <= sut.endLabel.frame.origin.y)
    }
    
    func test_EndLabelSize_SetsEndSliderBelow_EndLabel() {
        sut.endLabelSize = CGSize(width: 50, height: 20)
        sut.layoutSubviews()
        XCTAssertNotEqual(sut.endSlider.frame.origin.y, sut.endLabel.frame.origin.y)
    }
    
    func test_HandleStartSliderEvent_UpdatesStartLabelPosition() {
        
        sut.startLabel.frame.origin.x = 30
        sut.startSlider.setValue(2, animated: false)
        
        sut.handleStartSliderEvent(sender: sut.startSlider)
        XCTAssertEqual(sut.startLabel.center.x, sut.startSlider.handleCenterX)
    }
    
    func test_HandleStartSliderEvent_AtMinimum_KeepsStartLabelInBounds() {
        
        sut.startLabel.frame.size = CGSize(width: 100, height: 20)
        sut.startLabel.frame.origin.x = 30
        slideMinimum(slider: sut.startSlider)
        
        sut.handleStartSliderEvent(sender: sut.startSlider)
        XCTAssertEqual(sut.startLabel.frame.origin.x, 0)
    }
    
    func test_HandleStartSliderEvent_AtMax_KeepsStartLabelInBounds() {
        
        sut.startLabel.frame.size = CGSize(width: 100, height: 20)
        sut.startLabel.frame.origin.x = 30
        slideMaximum(slider: sut.startSlider)
        
        sut.handleStartSliderEvent(sender: sut.startSlider)
        XCTAssertTrue(sut.startLabel.frame.origin.x+sut.startLabel.frame.width <= sut.bounds.width)
    }
    
    func test_HandleEndSliderEvent_UpdatesEndLabelPosition() {
        sut.endLabel.frame.origin.x = 30
        sut.endSlider.setValue(2, animated: false)
        
        sut.handleEndSliderEvent(sender: sut.endSlider)
        XCTAssertEqual(sut.endLabel.center.x, sut.endSlider.handleCenterX)
    }
    
    func test_HandleEndSliderEvent_AtMax_KeepsStartLabelInBounds() {
        sut.endLabel.frame.size = CGSize(width: 100, height: 20)
        sut.endLabel.frame.origin.x = 30
        slideMaximum(slider: sut.endSlider)
        
        sut.handleEndSliderEvent(sender: sut.endSlider)
        XCTAssertTrue(sut.endLabel.frame.origin.x + sut.endLabel.frame.width <= sut.bounds.width)
    }
    
    func test_HandleEndSliderEvent_AtMin_KeepsEndLabelInBounds() {
        sut.endLabel.frame.size = CGSize(width: 100, height: 20)
        sut.endLabel.frame.origin.x = 30
        slideMinimum(slider: sut.startSlider)
        slideMinimum(slider: sut.endSlider)
        
        sut.handleEndSliderEvent(sender: sut.endSlider)
        XCTAssertEqual(sut.endLabel.frame.origin.x, 0)
    }
    
    func test_HandleStartSlider_SlideToMax_SlidesEndSliderLabel() {
        
        sut.endLabel.frame.origin.x = 20
        sut.startLabel.frame.origin.x = 10
        slideMaximum(slider: sut.startSlider)
        sut.handleStartSliderEvent(sender: sut.startSlider)
        
        XCTAssertEqual(sut.endLabel.frame.origin.x, sut.startLabel.frame.origin.x)
    }
    
    func slideMinimum(slider: SimpleSlider) {
        sut.layoutSubviews()
        slider.setValue(0, animated: false)
    }
    
    func slideMaximum(slider: SimpleSlider) {
        sut.layoutSubviews()
        slider.setValue(20, animated: false)
    }
    
    func test_LayoutSubviews_SetsStartLabelPosition() {
        
        sut.startLabel.frame.origin = CGPoint.zero
        sut.layoutSubviews()
        
        XCTAssertNotEqual(sut.startLabel.frame.origin, CGPoint.zero)
    }
    
    func test_LayoutSubviews_SetsEndLabelPosition() {
        
        sut.endLabel.frame.origin = CGPoint.zero
        sut.layoutSubviews()
        
        XCTAssertNotEqual(sut.endLabel.frame.origin, CGPoint.zero)
    }
}
