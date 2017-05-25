//
//  ViewControllerTests.swift
//  SwiftGraph
//
//  Created by Albert Bartocci on 5/25/17.
//  Copyright © 2017 AJ Bartocci. All rights reserved.
//

import XCTest
@testable import SwiftGraph

class ViewControllerTests: XCTestCase {
    
    var sut: ViewController!
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        sut = story.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        _ = sut.view
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        super.tearDown()
    }

    func test_Init() {
        XCTAssertNotNil(sut.graphView)
        XCTAssertNotNil(sut.graphDataSource)
        XCTAssertTrue(sut.graphView.dataSource is GraphManager)
    }
}
