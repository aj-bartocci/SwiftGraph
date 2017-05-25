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
    @IBInspectable var handleShadowSize: CGSize?
    @IBInspectable var handleShadowTint: UIColor?
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let context = UIGraphicsGetCurrentContext()
        let handleOffset = handleSize/2
        
        let midY = rect.height/2
        let midX = rect.width/2
        
        let lineStart = CGPoint(x: handleOffset, y: midY)
        context?.move(to: lineStart)
        
        let lineEnd = CGPoint(x: rect.width-handleOffset, y: midY)
        context?.addLine(to: lineEnd)
        
        context?.setLineWidth(lineSize)
        context?.setStrokeColor(lineTint.cgColor)
        context?.setFillColor(UIColor.clear.cgColor)
        
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        if let shadowSize = handleShadowSize {
            let color = handleShadowTint ?? .black
            context?.setShadow(offset: shadowSize, blur: 3, color: color.cgColor)
        }
        let handleCenter = CGPoint(x: midX-handleSize/2, y: midY-handleSize/2)
        handleTint.set()
        context?.fillEllipse(in:CGRect(origin: handleCenter, size: CGSize(width: handleSize, height: handleSize)))
        context?.restoreGState()
        
    }

}
