//
//  GraphManager.swift
//  SwiftGraph
//
//  Created by AJ Bartocci on 5/2/17.
//  Copyright © 2017 AJ Bartocci. All rights reserved.
//

import XCTest
@testable import SwiftGraph

class GraphManagerTests: XCTestCase {
    
    var sut: GraphManager!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        sut = GraphManager()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_Init() {
        let sut = GraphManager()
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.startingValue, 0)
        XCTAssertEqual(sut.items.count, 0)
    }
    
    func test_Init_WithStartingValueTen_SetsTen() {
        let sut = GraphManager(startingValue: 10)
        XCTAssertEqual(sut.startingValue, 10)
    }
    
    func test_Init_WithItems_SetsItems() {
        
        let item = GraphItem(value: 100, descriptor: "May 10th")
        
        let sut = GraphManager(items: [item])
        XCTAssertEqual(sut.items.first?.graphValue, item.graphValue)
        XCTAssertEqual(sut.items.first?.graphDescriptor, item.graphDescriptor)
    }
    
    func test_MaxItemValue_ReturnsMaxItemValue() {
        
        let item = GraphItem(value: 100, descriptor: "blah")
        let item2 = GraphItem(value: 10, descriptor: "blahhh")
        let item3 = GraphItem(value: 45, descriptor: "bla")
        
        let sut = GraphManager(items: [item,item2,item3])
        let max = sut.maxItemValue
        
        XCTAssertEqual(max, 100)
    }
    
    func test_MinItemValue_ReturnsMinItemValue() {
        
        let item = GraphItem(value: 100, descriptor: "blah")
        let item2 = GraphItem(value: 10, descriptor: "blahhh")
        let item3 = GraphItem(value: 45, descriptor: "bla")
        
        let sut = GraphManager(items: [item,item2,item3])
        let min = sut.minItemValue
        
        XCTAssertEqual(min, 10)
    }
}
