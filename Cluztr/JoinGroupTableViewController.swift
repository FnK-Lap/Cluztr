//
//  JoinGroupTableViewController.swift
//  Cluztr
//
//  Created by Franck LAPEYRE on 13/11/2015.
//  Copyright © 2015 Cluztr. All rights reserved.
//

import UIKit

class JoinGroupTableViewController: UITableViewController {
    
    var invitations: JSON?
    var groupId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        HttpHelper().request(UserRouter.GetInvitations(),
            success: {json in
                if json["status"] == 200 {
                    self.invitations = json["data"]
                    self.tableView.reloadData()
                }
            },
            errors: {json in
                let alertController = UIAlertController(title: "Erreur", message: "Une erreur est survenue", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OKAY", style: UIAlertActionStyle.Default, handler: nil ))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        )
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let count = self.invitations?.count{
            return count
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> JoinGroupTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("invitationCell", forIndexPath: indexPath) as! JoinGroupTableViewCell
        
        cell.joinButton.tag = indexPath.row
        cell.initUI(self.invitations![indexPath.row]["userId"], group: self.invitations![indexPath.row]["groupId"])
        
        return cell
    }

    @IBAction func joinButtonAction(sender: AnyObject) {
        let button: UIButton = sender as! UIButton
        let invitation = self.invitations![button.tag]
        self.groupId = invitation["groupId"]["_id"].string!
        
        let alertController = UIAlertController(title: "Rejoindre groupe", message: "Voulez vous vraiment accepter l'invitation de \(invitation["userId"]["firstname"]) à rejoindre son groupe ?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alertController.addAction(UIAlertAction(title: "Rejoindre", style: UIAlertActionStyle.Destructive, handler: { (action: UIAlertAction) in
            self.performSegueWithIdentifier("InterestSegue", sender: nil)
        }))
        
        alertController.addAction(UIAlertAction(title: "Non", style: UIAlertActionStyle.Cancel, handler: nil ))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "InterestSegue" {
            let destinationVC = segue.destinationViewController as! InterestViewController
            destinationVC.groupId = self.groupId
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
