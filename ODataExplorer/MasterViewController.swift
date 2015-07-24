//
//  MasterViewController.swift
//  ODataExplorer
//
//  Created by Allen Conquest on 16/07/2015.
//  Copyright (c) 2015 Allen Conquest. All rights reserved.
//

import UIKit
import SWXMLHash

class MasterViewController: UITableViewController {
    
    var detailViewController: DetailViewController? = nil
    var nodes = [XMLIndexer]()
    var isLoading = false

    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            clearsSelectionOnViewWillAppear = false
            preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }

        if self.nodes.count == 0 {
            loadMetaData()
        } else {
            tableView.reloadData()
        }
    }
    
    func loadMetaData() {
        isLoading = true
        let asset = ""
        getData(asset, { (metaData, error) in
            if error != nil
            {
                // TODO: improved error handling
                self.isLoading = false
                var alert = UIAlertController(title: "Error", message: "Could not load MetaData :( \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            let doc = XMLIndexer(metaData!)["edmx:Edmx"]["edmx:DataServices"]["Schema"][0]
            self.nodes = doc.children
            self.isLoading = false
            self.tableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let segueID = segue.identifier {
            
            switch segueID {
            case "showDetail":
                if let indexPath = tableView.indexPathForSelectedRow() {
                    let object = nodes[indexPath.row]
                    let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                    controller.detailItem = object
                    controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                    controller.navigationItem.leftItemsSupplementBackButton = true
                }
            case "showNextPage":
                let destVC = segue.destinationViewController as! MasterViewController
                let selectedRow = tableView.indexPathForSelectedRow()!.row
                let content = nodes[selectedRow].children
                destVC.nodes = content
                destVC.navigationItem.title = nodes[selectedRow].element?.attributes["Name"]
                destVC.tableView.reloadData()
                if splitViewController!.viewControllers.count > 1 {
                    let navigationController = splitViewController!.viewControllers[splitViewController!.viewControllers.count-1] as! UINavigationController
                    let detailViewController = navigationController.topViewController as! DetailViewController
                    detailViewController.detailItem = nodes[selectedRow]
                }
            default:
                // Don't do anything
                print("Segue not recognised: \(segueID)")
            }
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if let ident = identifier {
            let selectedRow = self.tableView.indexPathForSelectedRow()!.row
            if ident == "showDetail" || (ident == "showNextPage" && self.nodes[selectedRow].children.count > 0) {
                return true
            }
        }
        return false
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nodes.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        let data = self.nodes[indexPath.row]
        if data.element != nil {
            if let name = data.element?.attributes["Name"] {
                cell.textLabel?.text = name
            } else {
                if let name = data.element?.name {
                    cell.textLabel?.text = "[ \(name) ]"
                }
            }
            cell.detailTextLabel?.text = " " // if it's empty or nil it won't update correctly in iOS 8, see http://stackoverflow.com/questions/25793074/subtitles-of-uitableviewcell-wont-update
            cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
            if data.children.count > 0 {
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
}

