//
//  SliderWithArm.swift
//  SwiftGraph
//
//  Created by Albert Bartocci on 5/31/17.
//  Copyright © 2017 AJ Bartocci. All rights reserved.
//

import UIKit

@IBDesignable
class SliderWithArm: UIControl {
    
    enum Movement {
        case stationary
        case right
        case left
    }
    var movement: Movement = .stationary
    
    @IBInspectable var armSize: CGFloat?
    @IBInspectable var armTint: UIColor = .black
    @IBInspectable var armWidth: CGFloat = 1.0
    
    @IBInspectable var lineTint: UIColor = .black
    @IBInspectable var lineSize: CGFloat = 2
    @IBInspectable var handleSize: CGFloat = 20
    @IBInspectable var handleTint: UIColor = .blue
    @IBInspectable var handleShadowSize: CGSize = CGSize.zero
    @IBInspectable var handleShadowTint: UIColor?
    
//    @IBInspectable var labelSize: CGSize?
//    @IBInspectable var labelColor: UIColor = .black
    @IBOutlet weak var label: UILabel?
    
    @IBInspectable var minValue: CGFloat = 0.0
    @IBInspectable var maxValue: CGFloat = 1.0
    @IBInspectable var value: CGFloat = 0.5
    
    @IBInspectable var isContinous: Bool = true
    
    var relativeValue: CGFloat {
        let offset = maxValue - minValue
        let relVal = self.value - minValue
        return relVal / offset
    }
    
    var offsetWidth: CGFloat {
        return self.bounds.width - handleSize
    }
    
    private var lineYOrigin: CGFloat {
        return self.bounds.height - (handleSize * 0.5)
    }
    
    private var handleOrigin: CGPoint {
        let xVal = self.offsetWidth * self.relativeValue
        let yVal = self.bounds.height - handleSize
        return CGPoint(x: xVal, y: yVal)
    }
    
    var handleCenterX: CGFloat {
        return handleOrigin.x + (handleSize * 0.5)
    }
    
    var labelCenterX: CGFloat {
        if let label = label {
            let labelHalf = label.frame.width * 0.5
            if label.frame.origin.x <= 0 {
                if handleCenterX - labelHalf > 0 {
                    return handleCenterX
                }
                return labelHalf
            } else if label.frame.origin.x >= self.bounds.width - label.frame.width {
                if handleCenterX + labelHalf < self.bounds.width {
                    return handleCenterX
                }
                return self.bounds.width - (label.frame.width * 0.5)
            }
        }
        return handleCenterX
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        if minValue > maxValue {
            fatalError("The minimum value cannot be greater than the maximum")
        }
        
        let context = UIGraphicsGetCurrentContext()
        let handleRadius = handleSize * 0.5
        
        let lineStart = CGPoint(x: handleRadius, y: lineYOrigin)
        let lineEnd = CGPoint(x: rect.width - handleRadius, y: lineYOrigin)
        context?.move(to: lineStart)
        context?.addLine(to: lineEnd)
        context?.setLineWidth(lineSize)
        context?.setStrokeColor(lineTint.cgColor)
        context?.setFillColor(UIColor.clear.cgColor)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        context?.setShadow(offset: handleShadowSize, blur: 3, color: handleShadowTint?.cgColor)
        
        let armY: CGFloat
        if let label = label {
            label.center.x = labelCenterX
            armY = label.frame.origin.y+label.frame.size.height
        } else {
            armY = 0
        }
//        let arm: CGFloat
//        if let armSize = armSize {
//            arm = armSize
//        } else {
//            arm = 0
//        }
        let armX = handleOrigin.x+handleRadius
        let armStart = CGPoint(x: armX, y: handleOrigin.y)
        let armEnd = CGPoint(x: armX, y: armY)
        context?.move(to: armStart)
        context?.addLine(to: armEnd)
        context?.setLineWidth(armWidth)
        context?.setStrokeColor(armTint.cgColor)
        context?.setFillColor(UIColor.clear.cgColor)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        handleTint.set()
        context?.fillEllipse(in:CGRect(origin: handleOrigin, size: CGSize(width: handleSize, height: handleSize)))
        context?.restoreGState()
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        
        let loc = touch.location(in: self)
        
        let minX = handleOrigin.x
        let maxX = handleOrigin.x + handleSize
        
        let minY = handleOrigin.y
        let maxY = handleOrigin.y + handleSize
        
        let validX = minX <= loc.x && loc.x <= maxX
        let validY = minY <= loc.y && loc.y <= maxY
        let shouldMove = validX && validY
        
        return shouldMove
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)
        
        if isContinous {
            setValue(using: touch)
        }
        
        return isContinous
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        
        self.movement = .stationary
        guard let touch = touch else {
            return
        }
        setValue(using: touch)
        // set for quick swipes out of bounds
        label?.center.x = labelCenterX
    }
    
    func setValue(using touch: UITouch) {
        
        let loc = touch.location(in: self)
        let handleRadius = handleSize * 0.5
        let relativeVal = (loc.x - handleRadius) / offsetWidth
        
        let offset = minValue + maxValue
        let newVal = offset * relativeVal
        updateValue(newVal)
        self.sendActions(for: .valueChanged)
    }
    
    func setValue(_ newVal: CGFloat, animated: Bool) {
        updateValue(newVal)
    }
    
    private func updateValue(_ newValue: CGFloat) {
        var newVal = newValue
        if newVal > maxValue {
            newVal = maxValue
        } else if newVal < minValue {
            newVal = minValue
        }
        if newVal > self.value {
            movement = .right
        } else if newVal < self.value {
            movement = .left
        } else {
            movement = .stationary
        }
        self.value = newVal
        self.setNeedsDisplay()
    }
    
    private func setLabelPosition(_ point: CGPoint) {
        
    }
    
}
