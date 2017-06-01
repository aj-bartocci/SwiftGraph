//
//  StartEndDetailGraphView.swift
//  SwiftGraph
//
//  Created by Albert Bartocci on 6/1/17.
//  Copyright © 2017 AJ Bartocci. All rights reserved.
//

import UIKit

class StartEndDetailGraphView: StartEndGraphView {
    
    let startLabel = UILabel()
    private let startSize = CGSize(width: 50, height: 20)
    
    @IBInspectable var startLabelSize: CGSize? {
        get {
            return CGSize.zero
        }
        set {
            startLabel.frame.size = newValue ?? startSize
        }
    }
    
    override func setup() {
        super.setup()
        
        
    }

    override func resizeStartSlider() {
        let height = self.bounds.height
        let width = self.bounds.width
        let startFrame = CGRect(x: 0, y: height-startHandleSize, width: width, height: startHandleSize)
        startSlider.frame = startFrame
    }
    
    override func resizeEndSlider() {
        let width = self.bounds.width
        let endFrame = CGRect(x: 0, y: 0, width: width, height: endHandleSize)
        endSlider.frame = endFrame
    }
    
    override func resizeGraph() {
        let startOffset = startSlider.handleSize * 0.5
        //        let endOffset = endSlider.handleSize * 0.5
        let height = self.bounds.height - (startSlider.frame.height + endSlider.frame.height)
        let width = self.bounds.width - startSlider.handleSize
        graph.frame = CGRect(x: startOffset, y: endSlider.frame.height, width: width, height: height)
        //        graph.layoutSubviews()
        graph.reloadData()
    }

}

extension StartEndDetailGraphView {
    

}
