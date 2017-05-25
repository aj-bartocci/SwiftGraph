//
//  GraphItemTests.swift
//  SwiftGraph
//
//  Created by AJ Bartocci on 5/2/17.
//  Copyright © 2017 AJ Bartocci. All rights reserved.
//

import XCTest
@testable import SwiftGraph

class GraphItemTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_Init() {
        let sut = GraphItem(value: 100, descriptor: "April 20, 2017")
        XCTAssertEqual(sut.value, 100)
        XCTAssertEqual(sut.descriptor, "April 20, 2017")
    }
    
}
