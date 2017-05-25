//
//  GraphViewTests.swift
//  SwiftGraph
//
//  Created by AJ Bartocci on 5/24/17.
//  Copyright © 2017 AJ Bartocci. All rights reserved.
//

import XCTest
@testable import SwiftGraph

class GraphViewTests: XCTestCase {

    let item300 = GraphItem(value: 300, descriptor: "max")
    let item10 = GraphItem(value: 10, descriptor: "min")
    var sut: GraphView!
    var graphMgr: GraphManager!
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = GraphView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        graphMgr = GraphManager()
        sut.dataSource = graphMgr
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        graphMgr = nil
        super.tearDown()
    }
    
    func test_Init() {
        let sut = GraphView()
        XCTAssertNil(sut.dataSource)
        XCTAssertEqual(sut.points.count, 0)
        XCTAssertNotNil(sut.graphLine)
    }
    
    func test_SetDataSource_SetsDataSourceToGraphManager() {
        let sut = GraphView()
        
        let graphManager = GraphManager()
        sut.dataSource = graphManager
        
        XCTAssertTrue(sut.dataSource is GraphManager)
    }
    
    func test_GetRelativeYValue_ReturnsValueRelativeToViewSize_Max() {
        
        graphMgr.setItems([item300, item10])
        
        let value = sut.getRelativeYValue(for: item300)
        
        XCTAssertEqual(value, 0)
    }
    
    func test_GetRelativeYValue_ReturnsValueRelativeToViewSize_Min() {
        
        graphMgr.setItems([item300, item10])
        
        let value = sut.getRelativeYValue(for: item10)
        
        XCTAssertEqual(value, sut.bounds.height)
    }
    
    func test_GetRelativeYValue_ReturnsValueReleativeToView_Mid() {
        
        let itemMax = GraphItem(value: 100, descriptor: "max")
        let itemMin = GraphItem(value: 0, descriptor: "min")
        let itemMid = GraphItem(value: 50, descriptor: "mid")
        graphMgr.setItems([itemMax, itemMid, itemMin])
        
        let value = sut.getRelativeYValue(for: itemMid)
        XCTAssertEqual(value, 50)
    }
    
    func test_GetRelativeYValue_ReturnsValueRelativeToView_OneValue_ReturnsMidView() {
        
        graphMgr.setItems([item10, item10])
        
        let value = sut.getRelativeYValue(for: item10)
        XCTAssertEqual(value, 50)
    }
    
    func test_GetRelativeXValue_ReturnsValueRelativeToView_First() {
        
        graphMgr.setItems([item10, item300])
        let value = sut.getRelativeXValue(for: 0)
        
        XCTAssertEqual(value, 0)
    }
    
    func test_GetRelativeXValue_ReturnsValueRelativeToView_Last() {
        
        graphMgr.setItems([item10, item300])
        let value = sut.getRelativeXValue(for: 1)
        
        XCTAssertEqual(value, sut.bounds.width)
    }
    
    func test_GetRelativeXValue_ReturnsValueRelativeToView_Mid() {
        
        graphMgr.setItems([item10, item10, item300])
        let value = sut.getRelativeXValue(for: 1)
        
        XCTAssertEqual(value, sut.bounds.width/2)
    }
    
    func test_GetRelativeXValue_ReturnsMidViewXValue_OneValue() {
        
        graphMgr.setItems([item300])
        let value = sut.getRelativeXValue(for: 0)
        
        XCTAssertEqual(value, sut.bounds.width/2)
    }
    
    func test_AddPoint_AddsPointToPoints() {
        let p = CGPoint.zero
        sut.addPoint(p)
        XCTAssertEqual(sut.points.first, p)
    }
    
    func test_ReloadData_ResetsPoints_UsingDataSource() {
        
        let graphManager = GraphManager(items: [item10, item300])
        sut.dataSource = graphManager
        sut.reloadData()
        
        XCTAssertEqual(sut.points.count, 2)
        
        let newItem = GraphItem(value: 50, descriptor: "")
        graphManager.setItems([item300,item10, newItem])
        sut.reloadData()
        
        XCTAssertEqual(sut.points.count, 3)
    }

    func test_ReloadData_AddsRelativePoints_ToPoints() {
        
        let itemMax = GraphItem(value: 100, descriptor: "max")
        let itemMin = GraphItem(value: 0, descriptor: "min")
        let itemMid = GraphItem(value: 50, descriptor: "mid")
        graphMgr.setItems([itemMid, itemMax, itemMin])
        
        sut.reloadData()
        
        let p1 = CGPoint(x: 0, y: sut.bounds.height/2)
        XCTAssertEqual(sut.points.first, p1)
        
        let p2 = CGPoint(x: sut.bounds.width/2, y: sut.bounds.height)
        XCTAssertEqual(sut.points[1].x, p2.x)
        XCTAssertEqual(sut.points[1].y, 0)
        
        let p3 = CGPoint(x: sut.bounds.width, y: 0)
        XCTAssertEqual(sut.points.last?.y, p3.x)
        XCTAssertEqual(sut.points.last?.y, sut.bounds.height)
    }
    
    func test_ReloadData_SetsGraphLine() {
        
        let itemMax = GraphItem(value: 100, descriptor: "max")
        let itemMin = GraphItem(value: 0, descriptor: "min")
        let itemMid = GraphItem(value: 50, descriptor: "mid")
        
        graphMgr.setItems([itemMid, itemMax, itemMin])
        
        sut.reloadData()
        
        let line = sut.createLine(using: sut.points)
        XCTAssertEqual(sut.graphLine.path, line.cgPath)
    }
    
    func test_CreateLine_ReturnsCAShapeLayer() {
        
        let p1 = CGPoint.zero
        let p2 = CGPoint(x: 100, y: 50)
        let p3 = CGPoint(x: 150, y: 25)
        
        let line = sut.createLine(using: [p1, p2, p3])
        
        XCTAssertTrue(line.contains(p1))
        XCTAssertTrue(line.contains(p2))
        XCTAssertTrue(line.contains(p3))
    }
    
//    func test_SetMaxValue_ToViewHeight() {
//        let sut = GraphView(frame: CGRect(x: 0, y: 0, width: 105, height: 105))
//        
//    }
    
}
