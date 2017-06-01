//
//  StartEndGraphView.swift
//  SwiftGraph
//
//  Created by Albert Bartocci on 5/31/17.
//  Copyright © 2017 AJ Bartocci. All rights reserved.
//

import UIKit

@IBDesignable
class StartEndGraphView: UIView {
    
    let startSlider = SliderWithArm()
    let endSlider = SliderWithArm()
    let graph = GraphView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    override func layoutSubviews() {
        resizeStartSlider()
        resizeEndSlider()
    }
    
    func setup() {
        setupStartSlider()
        setupEndSlider()
    }
    
    // MARK: Setup Start Slider
    func setupStartSlider() {
        resizeStartSlider()
        startSlider.backgroundColor = .clear
        self.addSubview(startSlider)
        
        startSlider.addTarget(self, action: #selector(handleStartSliderEvent(sender:)), for: .valueChanged)
    }
    
    // MARK: Setup End Slider
    func setupEndSlider() {
        resizeEndSlider()
        endSlider.backgroundColor = .clear
        endSlider.addTarget(self, action: #selector(handleEndSliderEvent(sender:)), for: .valueChanged)
        self.addSubview(endSlider)
    }
    
    func resizeStartSlider() {
        let height = self.bounds.height
        let width = self.bounds.width
        let startFrame = CGRect(x: 0, y: height-startHandleSize, width: width, height: startHandleSize)
        startSlider.frame = startFrame
    }
    
    func resizeEndSlider() {
        let width = self.bounds.width
        let endFrame = CGRect(x: 0, y: 0, width: width, height: endHandleSize)
        endSlider.frame = endFrame
    }
    
    private var endSticking = false
    func handleStartSliderEvent(sender: SliderWithArm) {
        
        if sender.movement == .right {
            if endSticking {
                endSlider.setValue(sender.value, animated: false)
            } else if sender.value > endSlider.value {
                endSlider.setValue(sender.value, animated: false)
                endSticking = true
            }
        } else if sender.movement == .left {
            if endSticking {
                endSlider.setValue(sender.value, animated: false)
            }
        }
    }
    
    func handleEndSliderEvent(sender: SliderWithArm) {
        
        if sender.movement == .right {
            endSticking = false
        } else {
            if sender.value <= startSlider.value {
                sender.setValue(startSlider.value, animated: false)
                sender.endEditing(true)
//                startSlider.setValue(sender.value, animated: false)
//                endSticking = true
            }
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

// StartSlider Properties
extension StartEndGraphView {
    @IBInspectable var startHandleTint: UIColor {
        get {
            return startSlider.handleTint
        }
        set {
            startSlider.handleTint = newValue
        }
    }
    @IBInspectable var startLineTint: UIColor {
        get {
            return startSlider.lineTint
        }
        set {
            startSlider.lineTint = newValue
        }
    }
    @IBInspectable var startHandleSize: CGFloat {
        get {
            return startSlider.handleSize
        }
        set {
            startSlider.handleSize = newValue
        }
    }
}

// EndSlider Properties
extension StartEndGraphView {
    @IBInspectable var endHandleSize: CGFloat {
        get {
            return endSlider.handleSize
        }
        set {
            endSlider.handleSize = newValue
        }
    }
    @IBInspectable var endHandleTint: UIColor {
        get {
            return endSlider.handleTint
        }
        set {
            endSlider.handleTint = newValue
        }
    }
    @IBInspectable var endLineTint: UIColor {
        get {
            return endSlider.lineTint
        }
        set {
            endSlider.lineTint = newValue
        }
    }
}

// Shared Properties 
extension StartEndGraphView {
    var minimumValue: Float {
        get {
            if startSlider.minValue != endSlider.minValue {
                endSlider.minValue = startSlider.minValue
            }
            return Float(startSlider.minValue)
        }
        set {
            let new = CGFloat(newValue)
            startSlider.minValue = new
            endSlider.minValue = new
        }
    }
    var maximumValue: Float {
        get {
            if startSlider.maxValue != endSlider.maxValue {
                endSlider.maxValue = endSlider.maxValue
            }
            return Float(startSlider.maxValue)
        }
        set {
            let new = CGFloat(newValue)
            startSlider.maxValue = new
        }
    }
}
