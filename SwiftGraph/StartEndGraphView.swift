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
    @IBInspectable var startHandleTint: UIColor = .white
    @IBInspectable var startLineTint: UIColor = .darkGray
    @IBInspectable var startHandleSize: CGFloat = 20
    
    let endSlider = SliderWithArm()
    @IBInspectable var endHandleSize: CGFloat = 20
    @IBInspectable var endHandleTint: UIColor = .white
    @IBInspectable var endLineTint: UIColor = .darkGray
    
    var minimumValue: Float = 0
    var maximumValue: Float = 1
    var currentValue: Float = 0.5
    
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
        startSlider.handleSize = startHandleSize
        startSlider.handleTint = startHandleTint
        startSlider.lineTint = startLineTint
        startSlider.value = CGFloat(currentValue)
        startSlider.maxValue = CGFloat(maximumValue)
        startSlider.minValue = CGFloat(minimumValue)
        startSlider.backgroundColor = .clear
        self.addSubview(startSlider)
        
        startSlider.addTarget(self, action: #selector(handleStartSliderEvent(sender:)), for: .valueChanged)
    }
    
    // MARK: Setup End Slider
    func setupEndSlider() {
        resizeEndSlider()
        endSlider.handleTint = endHandleTint
        endSlider.lineTint = endLineTint
        endSlider.value = CGFloat(currentValue)
        endSlider.maxValue = CGFloat(maximumValue)
        endSlider.minValue = CGFloat(minimumValue)
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
