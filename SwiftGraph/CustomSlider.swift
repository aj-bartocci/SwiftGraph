//
//  CustomSlider.swift
//  SwiftGraph
//
//  Created by Albert Bartocci on 5/25/17.
//  Copyright © 2017 AJ Bartocci. All rights reserved.
//

import UIKit

@IBDesignable
class CustomSlider: UIControl {

    @IBInspectable var lineTint: UIColor = .black
    @IBInspectable var lineSize: CGFloat = 2
    @IBInspectable var handleSize: CGFloat = 20
    @IBInspectable var handleTint: UIColor = .blue
    @IBInspectable var handleShadowSize: CGSize = CGSize.zero
    @IBInspectable var handleShadowTint: UIColor?

//    @IBInspectable var armSize: CGFloat = 0.0
//    @IBInspectable var armTint: UIColor = .black
//    @IBInspectable var armWidth: CGFloat = 2
    
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
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        if minValue > maxValue {
            fatalError("The minimum value cannot be greater than the maximum")
        }
        
        let context = UIGraphicsGetCurrentContext()
        let handleRadius = handleSize * 0.5
        
        let midY = rect.height * 0.5
        
//        let lineStart = CGPoint(x: handleRadius, y: midY)
//        let lineStart: CGPoint
//        let lineEnd: CGPoint
//        if extendsEdges {
//            lineStart = CGPoint(x: -handleRadius, y: midY)
//            lineEnd = CGPoint(x: rect.width + handleRadius, y: midY)
//        } else {
//            lineStart = CGPoint(x: 0, y: midY)
//            lineEnd = CGPoint(x: rect.width, y: midY)
//        }
        
        let lineStart = CGPoint(x: handleRadius, y: midY)
        let lineEnd = CGPoint(x: rect.width - handleRadius, y: midY)
        context?.move(to: lineStart)
        context?.addLine(to: lineEnd)
        
        context?.setLineWidth(lineSize)
        context?.setStrokeColor(lineTint.cgColor)
        context?.setFillColor(UIColor.clear.cgColor)
        
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        context?.setShadow(offset: handleShadowSize, blur: 3, color: handleShadowTint?.cgColor)
        
        let xVal = self.offsetWidth * self.relativeValue
        let yVal = midY-handleRadius
        let handleCenter = CGPoint(x: xVal, y: yVal)
        
//        if armSize > 0 {
//            let armStart = CGPoint(x: handleCenter.x+handleRadius, y: handleCenter.y)
//            let armEnd = CGPoint(x: handleCenter.x+handleRadius, y: -armSize)
//            context?.move(to: armStart)
//            context?.addLine(to: armEnd)
//            context?.setLineWidth(armWidth)
//            context?.setStrokeColor(armTint.cgColor)
//            context?.setFillColor(UIColor.clear.cgColor)
//            context?.drawPath(using: .stroke)
//            context?.saveGState()   
//        }
        
        handleTint.set()
        context?.fillEllipse(in:CGRect(origin: handleCenter, size: CGSize(width: handleSize, height: handleSize)))
        context?.restoreGState()
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        
        let handleRadius = handleSize * 0.5
        let loc = touch.location(in: self)
        
        let xPrevious = self.offsetWidth * self.relativeValue
        let minX = xPrevious
        let maxX = xPrevious + handleSize
//        let minX = xPrevious - handleRadius
//        let maxX = xPrevious + handleRadius
        
        let midY = self.frame.height * 0.5
        let minY = midY - handleRadius
        let maxY = midY + handleRadius
        
        let validX = minX <= loc.x && loc.x <= maxX
        let validY = minY <= loc.y && loc.y <= maxY
        let shouldMove = validX && validY
        
        return shouldMove
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)
        
        if isContinous {
            setValue(using: touch)
            self.sendActions(for: .valueChanged)
        }
        
        return isContinous
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        
        guard let touch = touch else {
            return
        }
        setValue(using: touch)
    }
    
//    func setValue(to val: CGFloat) {
//        self.value = val
//        
//    }
    
    func setValue(using touch: UITouch) {
        
        let loc = touch.location(in: self)
        let handleRadius = handleSize * 0.5
        let relativeVal = (loc.x - handleRadius) / offsetWidth
        
        let offset = minValue + maxValue
        var newVal = offset * relativeVal
        if newVal > maxValue {
            newVal = maxValue
        } else if newVal < minValue {
            newVal = minValue
        }
        self.value = newVal
        self.setNeedsDisplay()
    }

}
