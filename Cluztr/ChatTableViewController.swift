//
//  ChatTableViewController.swift
//  Cluztr
//
//  Created by Franck LAPEYRE on 04/12/2015.
//  Copyright © 2015 Cluztr. All rights reserved.
//

import UIKit

class ChatTableViewController: UITableViewController {
    
    var chats:JSON?
    var chatLoaded: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getChatFromAPI()
        


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.getChatFromAPI()
    }
    
    func getChatFromAPI() {
        let tabBarController = self.tabBarController as! TabBarViewController
        let groupId = tabBarController.user!["groupId"]
        
        HttpHelper().request(GroupRouter.GetChats(groupId),
            success: {json in
                self.chats = json["data"]
                print("==========")
                print(self.chats)
                self.tableView.reloadData();
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

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numberOfCell = self.chats?.count {
            return numberOfCell
        }

        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:ChatGroupTableViewCell
        
        if indexPath.row == 0 {
            // First cell, own group chat
            cell = tableView.dequeueReusableCellWithIdentifier("OwnGroupCell", forIndexPath: indexPath) as! ChatGroupTableViewCell
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("ChatGroupCell", forIndexPath: indexPath) as! ChatGroupTableViewCell
        }
        
        if self.chats != nil {
            cell.initUI(self.chats![indexPath.row])
            print(indexPath)
            print("--------- Cell ID ----------")
            print(self.chats![indexPath.row]["_id"].string)
            print("---------- END Cell ID ---------")
            cell.chatId = self.chats![indexPath.row]["_id"].string
        }
        
        

        // Configure the cell...

        return cell
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
        performSegueWithIdentifier("ChatMessageSegue", sender: selectedCell)
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationVC = segue.destinationViewController as! MessageViewController
        let selectedCell = sender as! ChatGroupTableViewCell
        
        destinationVC.chatId = selectedCell.chatId
    }


}
