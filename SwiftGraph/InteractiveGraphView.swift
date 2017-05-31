//
//  InteractiveGraphView.swift
//  SwiftGraph
//
//  Created by Albert Bartocci on 5/25/17.
//  Copyright © 2017 AJ Bartocci. All rights reserved.
//

import UIKit

protocol InteractiveGraphViewDelegate: class {
    
    func sliderValueChanged(to value: Int)
}

@IBDesignable
class InteractiveGraphView: UIView {
    
    @IBOutlet weak var graph: GraphView!
    @IBOutlet weak var graphSlider: UISlider?
    @IBOutlet weak var custSlider: CustomSlider?
    @IBOutlet weak var armSlider: SliderWithArm?
    var slider: UISlider!
    weak var delegate: InteractiveGraphViewDelegate?
    
    override func awakeFromNib() {
        if let graphSlider = graphSlider {
            slider = graphSlider
        } else {
            slider = UISlider()
//            self.addSubview(slider)
        }
        
//        let x = custSlider!.relativeValue * custSlider!.offsetWidth
//        let start = CGPoint(x: x, y: custSlider!.frame.origin.y)
//        let end = CGPoint(x: x, y: graph.frame.origin.y)
//        let path = createLine(using: [start, end])
//        slideArm.path = path.cgPath
//        slideArm.strokeColor = UIColor.blue.cgColor
//        self.layer.insertSublayer(slideArm, above: graph.layer)
    }
    
    func setDataSource(_ source: GraphManagerDisplayInterface) {
        graph.dataSource = source
    }
    
    func reloadData() {
        graph.reloadData()
        slider.maximumValue = Float(graph.points.count-1)
        custSlider?.maxValue = CGFloat(graph.points.count-1)
        armSlider?.maxValue = CGFloat(graph.points.count-1)
    }
    
    @IBAction func handleSlideEvent(sender: UISlider) {
        if slider.isTracking {
            sliderValueChanged(to: slider.value)
        } else {
            guard let prevSliderVal = prevSliderVal else {
                return
            }
            slider.setValue(Float(prevSliderVal), animated: true)
        }
    }
    
    @IBAction func handleCustSlideEvent(sender: CustomSlider) {
        sliderValueChanged(to: Float(sender.value))
    }
    
    @IBAction func handleArmSlide(sender: SliderWithArm) {
        sliderValueChanged(to: Float(sender.value))
    }
    
    private var prevSliderVal: Int?
    func sliderValueChanged(to val: Float) {
        let roundVal = Int(val.rounded())
        if prevSliderVal != roundVal {
            prevSliderVal = roundVal
            delegate?.sliderValueChanged(to: roundVal)
        }
    }
    
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
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

//extension UIView {
//    
//    @discardableResult   // 1
//    func fromNib<T : UIView>() -> T? {   // 2
//        guard let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0] as? T else {    // 3
//            // xib not loaded, or it's top view is of the wrong type
//            return nil
//        }
//        self.addSubview(view)     // 4
//        view.translatesAutoresizingMaskIntoConstraints = false   // 5
//        view.layoutAttachAll(to: self)   // 6
//        return view   // 7
//    }
//}
