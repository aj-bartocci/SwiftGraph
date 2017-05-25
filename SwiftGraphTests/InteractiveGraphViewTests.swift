//
//  InteractiveGraphViewTests.swift
//  SwiftGraph
//
//  Created by Albert Bartocci on 5/25/17.
//  Copyright © 2017 AJ Bartocci. All rights reserved.
//

import XCTest
@testable import SwiftGraph

class InteractiveGraphViewTests: XCTestCase {
    
    var sut: InteractiveGraphView!
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "GraphViewController") as! GraphViewController
        _ = vc.view
        sut = vc.graphView
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        super.tearDown()
    }
    
    func test_Init() {
        let sut = InteractiveGraphView()
        XCTAssertNil(sut.graph)
        XCTAssertNil(sut.slider)
        XCTAssertNil(sut.delegate)
    }
    
    func test_SetDataSource_SetsGraphDataSource() {
        
        let graphManager = GraphManager()
        sut.setDataSource(graphManager)
        
        XCTAssertTrue(sut.graph.dataSource is GraphManager)
    }
    
    func test_ReloadData_ReloadsGraph() {
        
        let item = GraphItem(value: 100, descriptor: "blah")
        let graphManager = GraphManager(items: [item])
        sut.setDataSource(graphManager)
        sut.reloadData()
        
        XCTAssertEqual(sut.graph.points.count, 1)
    }
    
    func test_ReloadData_SetsUpSlider() {
        
        let item = GraphItem(value: 100, descriptor: "blah")
        let graphManager = GraphManager(items: [item, item, item])
        sut.setDataSource(graphManager)
        sut.reloadData()
        
        XCTAssertEqual(sut.slider.maximumValue, Float(sut.graph.points.count-1))
        XCTAssertEqual(sut.slider.minimumValue, 0)
    }
    
    func test_SliderValueChanged_SetsSliderToClosestValue_Down() {
        
        let mockDelegate = ObjectConformingToDelegate()
        sut.delegate = mockDelegate
        
        sut.sliderValueChanged(to: 2.4)
        
        XCTAssertEqual(mockDelegate.valReceived, 2)
    }
    
    func test_SliderValueChanged_SetsSliderToClosestValue_Higher() {
        
        let mockDel = ObjectConformingToDelegate()
        sut.delegate = mockDel
        
        sut.sliderValueChanged(to: 2.6)
        
        XCTAssertEqual(mockDel.valReceived, 3)
    }
    
    func test_SliderValueChanged_OnlyFiresForNewValue() {
        
        let mockDel = ObjectConformingToDelegate()
        sut.delegate = mockDel
        
        sut.sliderValueChanged(to: 2.3)
        XCTAssertEqual(mockDel.sliderChangeCount, 1)
        
        sut.sliderValueChanged(to: 2.4)
        XCTAssertEqual(mockDel.sliderChangeCount, 1)
        
        sut.sliderValueChanged(to: 2.5)
        XCTAssertEqual(mockDel.sliderChangeCount, 2)
    }
    
}


extension InteractiveGraphViewTests {
    
    class ObjectConformingToDelegate: InteractiveGraphViewDelegate {
        
        var valReceived: Int = 0
        var sliderChangeCount = 0
        func sliderValueChanged(to value: Int) {
            valReceived = value
            sliderChangeCount += 1
        }
    }
}
