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

    var sut: GraphView!
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = GraphView()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        super.tearDown()
    }
    
    func test_Init() {
        let sut = GraphView()
        XCTAssertNil(sut.dataSource)
    }
    
    func test_SetDataSource_SetsDataSourceToGraphManager() {
        let sut = GraphView()
        
        let graphManager = GraphManager()
        sut.dataSource = graphManager
        
        XCTAssertTrue(sut.dataSource is GraphManager)
    }
    
    func test_SetMaxValue_ToY
    
}
