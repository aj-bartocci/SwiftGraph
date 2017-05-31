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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_Init() {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let sut = story.instantiateViewController(withIdentifier: "StartEndGraphViewController") as! StartEndGraphViewController
        _ = sut.view
        XCTAssertNotNil(sut.graphView)
    }
    
}
