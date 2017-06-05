//
//  StartEndGraphView.swift
//  SwiftGraph
//
//  Created by Albert Bartocci on 5/31/17.
//  Copyright © 2017 AJ Bartocci. All rights reserved.
//

import UIKit

protocol StartEndGraphViewDelegate: class {
    func startEndGraph(view: StartEndGraphView, changedStart value: Float)
    func startEndGraph(view: StartEndGraphView, changedEnd value: Float)
}

@IBDesignable
class StartEndGraphView: UIView {
    
    let startSlider = SimpleSlider()
    let endSlider = SimpleSlider()
    let graph = GraphView()
    let slideShader = CAShapeLayer()
    let startSliderArm = CAShapeLayer()
    let endSliderArm = CAShapeLayer()
    weak var delegate: StartEndGraphViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // TODO: set default values here if init programmatically
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
        let graphDataSource = GraphManager()
        let item1 = GraphItem(value: 100, descriptor: "June 1, 2017")
        let item2 = GraphItem(value: 50, descriptor: "June 2, 2017")
        let item3 = GraphItem(value: 33, descriptor: "June 3, 2017")
        let item4 = GraphItem(value: 65.5, descriptor: "June 4, 2017")
        
        graphDataSource.setItems([item1, item2, item3, item4])
        setDataSource(graphDataSource)
        graph.reloadData()
        
        maximumValue = Float(graphDataSource.items.count-1)
        minimumValue = 0
        startSlider.setValue(1, animated: false)
        endSlider.setValue(2, animated: false)
//        self.layer.addSublayer(slideShader)
        self.layer.insertSublayer(slideShader, below: startSliderArm)
        updateSlideShader()
//        slideShaderTint = .lightGray
//        slideShaderOpacity = 0.25
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        resizeStartSlider()
        resizeEndSlider()
        resizeGraph()
        
        layoutStartSliderArm()
    }
    
    func setup() {
        setupStartSlider()
        setupEndSlider()
        setupGraph()
    
        self.layer.addSublayer(startSliderArm)
        layoutStartSliderArm()
        
        self.layer.addSublayer(endSliderArm)
        layoutEndSliderArm()
    }
    
    func layoutStartSliderArm() {
        let startPoint = CGPoint(x: startSlider.handleCenterX, y: graph.frame.origin.y)
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: CGPoint(x: startPoint.x, y: startPoint.y + graph.frame.height))
        
        startSliderArm.path = path.cgPath
    }
    
    func layoutEndSliderArm() {
        
        let startPoint = CGPoint(x: endSlider.handleCenterX, y: graph.frame.origin.y)
        let endPoint = CGPoint(x: startPoint.x, y: startPoint.y + graph.frame.height)
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        endSliderArm.path = path.cgPath
    }
    
    func setupGraph() {
        resizeGraph()
//        self.addSubview(graph)
        self.insertSubview(graph, at: 0)
    }
    
    // MARK: Setup Start Slider
    func setupStartSlider() {
        resizeStartSlider()
        startSlider.backgroundColor = .clear
        startSlider.addTarget(self, action: #selector(handleStartSliderEvent(sender:)), for: .valueChanged)
        self.addSubview(startSlider)
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
    
    func resizeGraph() {
        let startOffset = startSlider.handleSize * 0.5
//        let endOffset = endSlider.handleSize * 0.5
        let height = self.bounds.height - (startSlider.frame.height + endSlider.frame.height)
        let width = self.bounds.width - startSlider.handleSize
        graph.frame = CGRect(x: startOffset, y: endSlider.frame.height, width: width, height: height)
//        graph.layoutSubviews()
        graph.reloadData()
    }
    
    private var endSticking = false
    func handleStartSliderEvent(sender: SimpleSlider) {
        
        delegate?.startEndGraph(view: self, changedStart: Float(sender.value))
        updateSlideShader()
        layoutStartSliderArm()
        if sender.movement == .right {
            if endSticking {
                endSlider.setValue(sender.value, animated: false)
                delegate?.startEndGraph(view: self, changedEnd: Float(sender.value))
            } else if sender.value > endSlider.value {
                endSlider.setValue(sender.value, animated: false)
                delegate?.startEndGraph(view: self, changedEnd: Float(sender.value))
                endSticking = true
                slideShader.removeFromSuperlayer()
            }
        } else if sender.movement == .left {
            if endSticking {
                endSlider.setValue(sender.value, animated: false)
                delegate?.startEndGraph(view: self, changedEnd: Float(sender.value))
            } else {
                addSlideShaderIfNeeded()
            }
        }
    }
    
    func handleEndSliderEvent(sender: SimpleSlider) {
        
        delegate?.startEndGraph(view: self, changedEnd: Float(sender.value))
        if sender.movement == .right {
            endSticking = false
            addSlideShaderIfNeeded()
            updateSlideShader()
        } else {
            if sender.value <= startSlider.value {
                sender.setValue(startSlider.value, animated: false)
                sender.endEditing(true)
                slideShader.removeFromSuperlayer()
//                startSlider.setValue(sender.value, animated: false)
//                endSticking = true
            } else {
                updateSlideShader()
            }
        }
    }
    
    func addSlideShaderIfNeeded() {
        guard let layers = self.layer.sublayers else {
            return
        }
        if !layers.contains(slideShader) {
//            self.layer.addSublayer(slideShader)
            self.layer.insertSublayer(slideShader, below: startSliderArm)
        }
    }
    
    func updateSlideShader() {
        let width = endSlider.handleCenterX - startSlider.handleCenterX
        let rect = CGRect(x: startSlider.handleCenterX, y: graph.frame.origin.y, width: width, height: graph.bounds.height)
        let path = UIBezierPath(rect: rect)
        slideShader.path = path.cgPath
    }
    
    func setDataSource(_ dataSource: GraphManagerDisplayInterface) {
        graph.dataSource = dataSource
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

//GraphView Properties
extension StartEndGraphView {
    @IBInspectable var graphBackgroundColor: UIColor? {
        get {
            return graph.backgroundColor
        }
        set {
            graph.backgroundColor = newValue
        }
    }
    @IBInspectable var graphLineTint: UIColor {
        get {
            return graph.lineColor
        }
        set {
            graph.lineColor = newValue
        }
    }
    @IBInspectable var graphLineWidth: CGFloat {
        get {
            return graph.lineWidth
        }
        set {
            graph.lineWidth = newValue
        }
    }
}

// SlideShader Properties
extension StartEndGraphView {
    @IBInspectable var slideShaderTint: UIColor {
        get{
            if let cgCol = slideShader.fillColor {
                return UIColor(cgColor: cgCol)
            }
            return UIColor.lightGray
        }
        set {
            slideShader.fillColor = newValue.cgColor
        }
    }
    @IBInspectable var slideShaderOpacity: Float {
        get {
            return slideShader.opacity
        }
        set {
            slideShader.opacity = newValue
        }
    }
}

extension StartEndGraphView {
    @IBInspectable var startSliderArmColor: UIColor? {
        get {
            if let cgCol = startSliderArm.strokeColor {
                return UIColor(cgColor: cgCol)
            }
            return nil
        }
        set {
            startSliderArm.strokeColor = newValue?.cgColor
        }
    }
    @IBInspectable var startSliderArmWidth: CGFloat {
        get {
            return startSliderArm.lineWidth
        }
        set {
            startSliderArm.lineWidth = newValue
        }
    }
}

extension StartEndGraphView {
    @IBInspectable var endSliderArmColor: UIColor? {
        get {
            if let cgCol = endSliderArm.strokeColor {
                return UIColor(cgColor: cgCol)
            }
            return nil
        }
        set {
            endSliderArm.strokeColor = newValue?.cgColor
        }
    }
    @IBInspectable var endSliderArmWidth: CGFloat {
        get {
            return endSliderArm.lineWidth   
        }
        set {
            endSliderArm.lineWidth = newValue
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
                endSlider.maxValue = startSlider.maxValue
            }
            return Float(startSlider.maxValue)
        }
        set {
            let new = CGFloat(newValue)
            startSlider.maxValue = new
            endSlider.maxValue = new
        }
    }
//    @IBInspectable var sliderArmTint: UIColor {
//        get {
//            if startSlider.armTint != endSlider.armTint {
//                endSlider.armTint = startSlider.armTint
//            }
//            return startSlider.armTint
//        }
//        set {
//            startSlider.armTint = newValue
//            endSlider.armTint = newValue
//        }
//    }
//    @IBInspectable var sliderArmWidth: CGFloat {
//        get {
//            if startSlider.armWidth != endSlider.armWidth {
//                endSlider.armWidth = startSlider.armWidth
//            }
//            return startSlider.armWidth
//        }
//        set {
//            startSlider.armWidth = newValue
//            endSlider.armWidth = newValue
//        }
//    }
}
