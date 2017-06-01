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
    
    func test_Init() {
        let sut = StartEndDetailGraphView()
        XCTAssertNotNil(sut.startLabel)
        
        XCTAssertEqual(sut.startLabelSize, sut.startLabel.frame.size)
    }
}
