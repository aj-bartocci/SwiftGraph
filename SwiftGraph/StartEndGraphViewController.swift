//
//  StartEndGraphViewController.swift
//  SwiftGraph
//
//  Created by Albert Bartocci on 5/31/17.
//  Copyright © 2017 AJ Bartocci. All rights reserved.
//

import UIKit

class StartEndGraphViewController: UIViewController {
    
    @IBOutlet weak var graphView: StartEndGraphView!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var startDetailLabel: UILabel!
    @IBOutlet weak var endDetailLabel: UILabel!
    
    let graphDataSource = GraphManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let item1 = GraphItem(value: 100, descriptor: "June 1, 2017")
        let item2 = GraphItem(value: 50, descriptor: "June 2, 2017")
        let item3 = GraphItem(value: 33, descriptor: "June 3, 2017")
        let item4 = GraphItem(value: 65.5, descriptor: "June 4, 2017")
        let item5 = GraphItem(value: 125.25, descriptor: "June 5, 2017")
        let item6 = GraphItem(value: 25.51, descriptor: "June 6, 2017")
        let item7 = GraphItem(value: 78, descriptor: "June 7, 2017")
        let item8 = GraphItem(value: 94.7, descriptor: "June 8, 2017")
        
        graphDataSource.setItems([item1, item2, item3, item4, item5, item6, item7, item8])
        graphView.minimumValue = 0
        graphView.maximumValue = Float(graphDataSource.items.count - 1)
        graphView.delegate = self
        graphView.setDataSource(graphDataSource)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func updateStartDisplay(with value: Float) {
        
        let index = Int(round(value))
        let item = graphDataSource.items[index]
        startDetailLabel.text = item.graphDescriptor
        startLabel.text = "\(item.graphValue)"
    }
    
    func updateEndDisplay(with value: Float) {
        
        let index = Int(round(value))
        let item = graphDataSource.items[index]
        endDetailLabel.text = item.graphDescriptor
        endLabel.text = "\(item.graphValue)"
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension StartEndGraphViewController: StartEndGraphViewDelegate {
    
    func startEndGraph(view: StartEndGraphView, changedStart value: Float) {
        updateStartDisplay(with: value)
    }
    
    func startEndGraph(view: StartEndGraphView, changedEnd value: Float) {
        updateEndDisplay(with: value)
    }
}
