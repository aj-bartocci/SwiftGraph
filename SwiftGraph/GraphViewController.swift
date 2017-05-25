//
//  GraphViewController.swift
//  SwiftGraph
//
//  Created by Albert Bartocci on 5/25/17.
//  Copyright © 2017 AJ Bartocci. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    
    @IBOutlet weak var graphView: InteractiveGraphView!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var descriptorLabel: UILabel!
    var graphDataSource = GraphManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        graphView.setDataSource(graphDataSource)
        
        let item1 = GraphItem(value: 100, descriptor: "June 1, 2017")
        let item2 = GraphItem(value: 50, descriptor: "June 2, 2017")
        let item3 = GraphItem(value: 33, descriptor: "June 3, 2017")
        let item4 = GraphItem(value: 65.5, descriptor: "June 4, 2017")
        let item5 = GraphItem(value: 125.25, descriptor: "June 5, 2017")
        let item6 = GraphItem(value: 25.51, descriptor: "June 6, 2017")
        let item7 = GraphItem(value: 78, descriptor: "June 7, 2017")
        let item8 = GraphItem(value: 94.7, descriptor: "June 8, 2017")
        
        graphDataSource.setItems([item1, item2, item3, item4, item5, item6, item7, item8, item1, item2, item3, item4, item5, item6, item7, item8, item1, item2, item3, item4, item5, item6, item7, item8, item1, item2, item3, item4, item5, item6, item7, item8, item1, item2, item3, item4, item5, item6, item7, item8, item1, item2, item3, item4, item5, item6, item7, item8, item1, item2, item3, item4, item5, item6, item7, item8, item1, item2, item3, item4, item5, item6, item7, item8])
        graphView.delegate = self
        graphView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("vc bounds = \(self.view.bounds.width)")
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

extension GraphViewController: InteractiveGraphViewDelegate {
    
    func sliderValueChanged(to value: Int) {
        
        let item = graphDataSource.items[value]
        valueLabel.text = "\(item.graphValue)"
        descriptorLabel.text = item.graphDescriptor
    }
}
