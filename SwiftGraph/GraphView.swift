//
//  GraphView.swift
//  SwiftGraph
//
//  Created by AJ Bartocci on 5/24/17.
//  Copyright © 2017 AJ Bartocci. All rights reserved.
//

import UIKit

@IBDesignable
class GraphView: UIView {
    
    @IBInspectable var lineColor: UIColor = .black
    @IBInspectable var lineWidth: CGFloat = 1.0
    
    weak var dataSource: GraphManagerDisplayInterface?
    var graphLine: CAShapeLayer = CAShapeLayer()
    var points: [CGPoint] {
        return pointArray
    }

    private var pointArray: [CGPoint] = []
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func layoutSubviews() {
        self.reloadData()
    }
    
    override func awakeFromNib() {
        graphLine.fillColor = nil
        graphLine.strokeColor = lineColor.cgColor
        graphLine.opacity = 1.0
    }
    
    func reloadData() {
        pointArray = []
        guard let dataItems = dataSource?.items else {
            return
        }
        for item in dataItems.enumerated() {
            let yVal = getRelativeYValue(for: item.element)
            let xVal = getRelativeXValue(for: item.offset)
            let point = CGPoint(x: xVal, y: yVal)
            pointArray.append(point)
        }
        graphLine.removeFromSuperlayer()
        graphLine.path = createLine(using: points).cgPath
        graphLine.lineWidth = self.lineWidth
        self.layer.addSublayer(graphLine)
    }
    
    func getRelativeYValue(for item: GraphItemInterface) -> CGFloat {
        
        // need to flip the y Value because height is the bottom of view not the top
        
        guard let maxVal = dataSource?.maxItemValue else {
            return 0
        }
        
        guard let minVal = dataSource?.minItemValue else {
            return 0
        }
        
        if maxVal == minVal {
            return self.bounds.height/2
        }
        
        let newMax = maxVal-minVal
        
        if newMax == 0 {
            return 0
        }
        
        let relativePercent = (item.graphValue-minVal)/newMax
        
        let relativeVal = (CGFloat(relativePercent)*self.bounds.height)
        let flippedVal = fabs(relativeVal-self.bounds.height)
        
        return flippedVal
    }
    
    func getRelativeXValue(for index: Int) -> CGFloat {
        
        guard let items = dataSource?.items else {
            return 0
        }
        
        if items.count == 0 {
            return 0
        } else if items.count == 1 {
            return self.bounds.width/2
        }
        
        let relativePercent = CGFloat(index)/CGFloat(items.count-1)
        let relativeValue = relativePercent*self.bounds.width
        print("width = \(self.bounds.width)")
        
        return relativeValue
    }
    
    func addPoint(_ point: CGPoint) {
        pointArray.append(point)
    }

}

extension GraphView {
    
    func createLine(using points: [CGPoint]) -> UIBezierPath {
        let linePath = UIBezierPath()
        for p in points.enumerated() {
            if p.offset == 0 {
                linePath.move(to: p.element)
            } else {
                linePath.addLine(to: p.element)
            }
        }
        return linePath
    }
}










