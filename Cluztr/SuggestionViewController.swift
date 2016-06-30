//
//  SuggestionViewController.swift
//  Cluztr
//
//  Created by Franck LAPEYRE on 07/10/2015.
//  Copyright © 2015 Cluztr. All rights reserved.
//

import UIKit

class SuggestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var receivedCluzts: JSON?
    var sentCluzts: JSON?
    
    @IBOutlet weak var receivedCluztsTableView: UITableView!
    @IBOutlet weak var sentCluztsTableView: UITableView!
    
    @IBOutlet weak var cluztSegmentedControlOutlet: UISegmentedControl!
    
    @IBAction func cluztSegmentedControl(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.setReceivedCluzt()
        case 1:
            self.setSentCluzt()
        default:
            break
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.receivedCluztsTableView.delegate = self
        self.receivedCluztsTableView.dataSource = self
        self.sentCluztsTableView.delegate = self
        self.sentCluztsTableView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        self.setReceivedCluzt()
        self.cluztSegmentedControlOutlet.selectedSegmentIndex = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView Datasource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.receivedCluztsTableView {
            if let count = self.receivedCluzts?.count {
                return count
            }
        }
        
        if tableView == self.sentCluztsTableView {
            if let count = self.sentCluzts?.count {
                return count
            }
        }
        
        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == self.receivedCluztsTableView {
            let cell = tableView.dequeueReusableCellWithIdentifier("receivedCluztCell") as! ReceivedCluztTableViewCell
            
            cell.initUI(self.receivedCluzts![indexPath.row])
            
            return cell
        }
        
        if tableView == self.sentCluztsTableView {
            let cell = tableView.dequeueReusableCellWithIdentifier("sentCluztCell") as! SentCluztTableViewCell
            
            cell.initUI(self.sentCluzts![indexPath.row])
            
            return cell
        }
        
        return UITableViewCell.init()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationVC = segue.destinationViewController as! OtherGroupViewController
        if segue.identifier == "receivedCluztGroupSegue" {
            let group = self.receivedCluzts![sender!.tag]["sender"]
            destinationVC.group = group
        } else if segue.identifier == "sentCluztGroupSegue" {
            let group = self.sentCluzts![sender!.tag]["receiver"]
            destinationVC.group = group
        }
        
        
    }
    
    func setReceivedCluzt() {
        self.receivedCluztsTableView.hidden = false;
        self.sentCluztsTableView.hidden = true;
        
        HttpHelper().request(GroupRouter.GetReceivedCluzts(),
            success: {json in
                self.receivedCluzts = json["data"]
                self.receivedCluztsTableView.reloadData()
            },
            errors: {error in
                let alertController = UIAlertController(title: "Error Network", message: "\(error["message"])", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OKAY", style: UIAlertActionStyle.Default, handler: nil ))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        )
    }
    
    func setSentCluzt() {
        self.receivedCluztsTableView.hidden = true;
        self.sentCluztsTableView.hidden = false;
        
        HttpHelper().request(GroupRouter.GetSentCluzt(),
            success: {json in
                self.sentCluzts = json["data"]
                self.sentCluztsTableView.reloadData()
            },
            errors: {error in
                let alertController = UIAlertController(title: "Error Network", message: "\(error["message"])", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OKAY", style: UIAlertActionStyle.Default, handler: nil ))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        )
    }
    
    
}
