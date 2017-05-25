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
    var slider: UISlider!
    weak var delegate: InteractiveGraphViewDelegate?
    
    override func awakeFromNib() {
        if let graphSlider = graphSlider {
            slider = graphSlider
        } else {
            slider = UISlider()
            self.addSubview(slider)
        }
    }
    
    func setDataSource(_ source: GraphManagerDisplayInterface) {
        graph.dataSource = source
    }
    
    func reloadData() {
        graph.reloadData()
        slider.maximumValue = Float(graph.points.count-1)
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
    
    private var prevSliderVal: Int?
    func sliderValueChanged(to val: Float) {
        let roundVal = Int(val.rounded())
        if prevSliderVal != roundVal {
            prevSliderVal = roundVal
            delegate?.sliderValueChanged(to: roundVal)
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
