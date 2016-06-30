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
    
    @IBOutlet weak var receivedCluztsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.receivedCluztsTableView.delegate = self
        self.receivedCluztsTableView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView Datasource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.receivedCluzts?.count {
            return count
        }
        
        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("receivedCluztCell") as! ReceivedCluztTableViewCell
        
        cell.initUI(self.receivedCluzts![indexPath.row])
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationVC = segue.destinationViewController as! OtherGroupViewController
        let group = self.receivedCluzts![sender!.tag]["sender"]
        destinationVC.group = group
    }
    
    
}
