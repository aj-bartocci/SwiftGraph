//
//  GraphManager.swift
//  SwiftGraph
//
//  Created by AJ Bartocci on 5/2/17.
//  Copyright © 2017 AJ Bartocci. All rights reserved.
//

import Foundation
import CoreGraphics

typealias GraphItems = [GraphItemInterface]

protocol GraphManagerInterface {
    var items: GraphItems { get }
    func setItems(_ items: GraphItems)
}

protocol GraphManagerDisplayInterface: class {
    var items: GraphItems { get }
    var maxItemValue: Float { get }
    var minItemValue: Float { get }
    var startingValue: Float { get }
}

class GraphManager: GraphManagerInterface, GraphManagerDisplayInterface {
    
    var startingValue: Float = 0
    var items: GraphItems {
        return itemArray
    }
    
    var maxItemValue: Float {
        let max = items.max(by: { (a, b) -> Bool in
            return a.graphValue < b.graphValue
        })
        return max?.graphValue ?? 0
    }
    
    var minItemValue: Float {
        let min = items.min { (a, b) -> Bool in
            return a.graphValue < b.graphValue
        }
        return min?.graphValue ?? 0
    }
    
    private var itemArray: GraphItems = []
    init(startingValue: Float = 0, items: GraphItems = []) {
        self.startingValue = startingValue
        self.itemArray = items
    }
    
    func setItems(_ items: GraphItems) {
        itemArray = items
    }
    
    func add(_ point: CGPoint) {
        
    }
}
