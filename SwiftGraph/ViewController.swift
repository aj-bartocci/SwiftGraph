//
//  ViewController.swift
//  SwiftGraph
//
//  Created by AJ Bartocci on 5/2/17.
//  Copyright © 2017 AJ Bartocci. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var graphView: GraphView!
    var graphDataSource = GraphManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        graphView.dataSource = graphDataSource
        
        let item1 = GraphItem(value: 100, descriptor: "item 1")
        let item2 = GraphItem(value: 50, descriptor: "item 2")
        let item3 = GraphItem(value: 33, descriptor: "item 3")
        
        graphDataSource.setItems([item1, item2, item3, item1, item1, item1, item1, item3])
        graphView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

