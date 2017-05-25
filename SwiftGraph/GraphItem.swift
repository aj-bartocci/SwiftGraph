//
//  GraphItem.swift
//  SwiftGraph
//
//  Created by AJ Bartocci on 5/2/17.
//  Copyright © 2017 AJ Bartocci. All rights reserved.
//

import Foundation
import CoreGraphics

struct GraphItem {
    
    let value: Float
    let descriptor: String
    init(value: Float, descriptor: String) {
        self.value = value
        self.descriptor = descriptor
    }
}


extension GraphItem: GraphItemInterface {
    
    var graphValue: Float {
        return value
    }
    var graphDescriptor: String {
        return descriptor
    }
}
