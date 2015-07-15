//
//  ViewController.swift
//  ODataExplorer
//
//  Created by Allen Conquest on 23/03/2015.
//  Copyright (c) 2015 Allen Conquest. All rights reserved.
//

import UIKit
import Alamofire
import SWXMLHash

class MasterViewController: UITableViewController, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load OData document
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return Metadata.getEntities()
//    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: (NSIndexPath)) -> CGFloat {
        return 44.0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
//        cell.textLabel?.text = country
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
}