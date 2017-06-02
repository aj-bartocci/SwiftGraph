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
    let endLabel = UILabel()
    
    @IBInspectable var someLabel: UILabel = UILabel()
    
    override func setup() {
        super.setup()
        
        setupStartLabel()
        setupEndLabel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        resizeStartLabel()
        resizeEndLabel()
    }
    
    func setupStartLabel() {
        resizeStartLabel()
        startLabel.textAlignment = .center
        startLabel.minimumScaleFactor = 0.5
        startLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(startLabel)
    }
    
    func setupEndLabel() {
        resizeEndLabel()
        endLabel.textAlignment = .center
        endLabel.minimumScaleFactor = 0.5
        endLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(endLabel)
    }
    
    func resizeStartLabel() {
        let yPos = startSlider.frame.origin.y + startSlider.frame.height
        startLabel.frame.origin.y = yPos
        positionInBounds(label: startLabel, using: startSlider.handleCenterX)
    }
    
    func resizeEndLabel() {
        endLabel.frame.origin.y = 0
        positionInBounds(label: endLabel, using: endSlider.handleCenterX)
    }

    override func resizeStartSlider() {
        let height = self.bounds.height
        let width = self.bounds.width
        let startFrame = CGRect(x: 0, y: height-(startHandleSize+startLabel.frame.height), width: width, height: startHandleSize)
        startSlider.frame = startFrame
    }
    
    override func resizeEndSlider() {
        let width = self.bounds.width
        let endFrame = CGRect(x: 0, y: endLabel.frame.height, width: width, height: endHandleSize)
        endSlider.frame = endFrame
    }
    
    override func resizeGraph() {
        let startOffset = startSlider.handleSize * 0.5
        let width = self.bounds.width - startSlider.handleSize
        let endSliderBottom = endSlider.frame.origin.y + endSlider.frame.height
        let startSliderTop = startSlider.frame.origin.y
        let graphHeight = startSliderTop - endSliderBottom
        let yPos = endSlider.frame.origin.y + endSlider.frame.height
        
        graph.frame = CGRect(x: startOffset, y: yPos, width: width, height: graphHeight)
        graph.reloadData()
    }
    
    override func handleStartSliderEvent(sender: SimpleSlider) {
        super.handleStartSliderEvent(sender: sender)
        let isSticking = startSlider.handleCenterX == endSlider.handleCenterX
        positionInBounds(label: startLabel, using: sender.handleCenterX)
        if isSticking {
            endLabel.frame.origin.x = startLabel.frame.origin.x
        }
    }
    
    override func handleEndSliderEvent(sender: SimpleSlider) {
        super.handleEndSliderEvent(sender: sender)
        positionInBounds(label: endLabel, using: sender.handleCenterX)
    }
    
    private func positionInBounds(label: UILabel, using xValue: CGFloat) {
        let min = xValue - label.frame.width * 0.5
        if min > 0 {
            let max = self.bounds.width - label.bounds.width
            if min >= max {
                label.frame.origin.x = max
            } else {
                label.center.x = xValue
            }
        } else {
            label.frame.origin.x = 0
        }
    }
    
}

// StartLabel Properties
extension StartEndDetailGraphView {
    
    @IBInspectable var startLabelSize: CGSize {
        get {
            return startLabel.frame.size
        }
        set {
            startLabel.frame.size = newValue
        }
    }
    @IBInspectable var startLabelTitle: String? {
        get {
            return startLabel.text
        }
        set {
            startLabel.text = newValue
        }
    }
    @IBInspectable var startLabelFontSize: CGFloat {
        get {
            return startLabel.font.pointSize
        }
        set {
            let fontName = startLabel.font.fontName
            let font = UIFont(name: fontName, size: newValue)!
            startLabel.font = font
        }
    }
    @IBInspectable var startLabelColor: UIColor {
        get {
            return startLabel.textColor
        }
        set {
            startLabel.textColor = newValue
        }
    }
    
}

extension StartEndDetailGraphView {
    
    @IBInspectable var endLabelSize: CGSize {
        get {
            return endLabel.frame.size
        }
        set {
            endLabel.frame.size = newValue
        }
    }
    @IBInspectable var endLabelTitle: String? {
        get {
            return endLabel.text
        }
        set {
            endLabel.text = newValue
        }
    }
    @IBInspectable var endLabelFontSize: CGFloat {
        get {
            return endLabel.font.pointSize
        }
        set {
            let fontName = endLabel.font.fontName
            let font = UIFont(name: fontName, size: newValue)!
            endLabel.font = font
        }
    }
    @IBInspectable var endLabelColor: UIColor {
        get {
            return endLabel.textColor
        }
        set {
            endLabel.textColor = newValue
        }
    }
}







