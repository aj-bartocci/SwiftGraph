//
//  StartEndGraphViewControllerTests.swift
//  SwiftGraph
//
//  Created by Albert Bartocci on 5/31/17.
//  Copyright © 2017 AJ Bartocci. All rights reserved.
//

import XCTest

@testable import SwiftGraph
class StartEndGraphViewControllerTests: XCTestCase {
    
    var sut: StartEndGraphViewController!
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let story = UIStoryboard(name: "Main", bundle: nil)
        sut = story.instantiateViewController(withIdentifier: "StartEndGraphViewController") as! StartEndGraphViewController
        _ = sut.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        super.tearDown()
    }
    
    func test_Init() {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let sut = story.instantiateViewController(withIdentifier: "StartEndGraphViewController") as! StartEndGraphViewController
        _ = sut.view
        XCTAssertNotNil(sut.graphView)
        XCTAssertNotNil(sut.startLabel)
        XCTAssertNotNil(sut.endLabel)
        XCTAssertNotNil(sut.startDetailLabel)
        XCTAssertNotNil(sut.endDetailLabel)
        XCTAssertNotNil(sut.graphView.graph.dataSource)
        XCTAssertNotNil(sut.graphView.delegate)
    }
    
    func test_UpdateStartDisplayWithValue_SetsStartLabels() {
        
        let item1 = GraphItem(value: 100, descriptor: "June 1, 2017")
        let item2 = GraphItem(value: 50, descriptor: "June 2, 2017")
        sut.graphDataSource.setItems([item1, item2])
        
        sut.updateStartDisplay(with: 0.3)
        
        XCTAssertEqual(sut.startLabel.text, "\(item1.graphValue)")
        XCTAssertEqual(sut.startDetailLabel.text, item1.graphDescriptor)
    }
    
    func test_UpdateEndDisplayWithValue_SetsEndLabels() {
        
        let item1 = GraphItem(value: 100, descriptor: "June 1, 2017")
        let item2 = GraphItem(value: 50, descriptor: "June 2, 2017")
        sut.graphDataSource.setItems([item1, item2])
        
        sut.updateEndDisplay(with: 0.6)
        
        XCTAssertEqual(sut.endLabel.text, "\(item2.graphValue)")
        XCTAssertEqual(sut.endDetailLabel.text, item2.graphDescriptor)
    }
}
