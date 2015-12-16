//
//  MessageViewController.swift
//  Cluztr
//
//  Created by Franck LAPEYRE on 08/12/2015.
//  Copyright © 2015 Cluztr. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var dock: UIView!

    @IBOutlet weak var tableView: UITableView!
    
    var returnPressed:Int = 1
    var newLine:CGFloat = 0
    var previousRect:CGRect = CGRectZero
    
    var chatId:String?
    var isPrivate:Bool = true
    var messages: Array<JSON> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        tableView.separatorColor = UIColor.clearColor()
        
        textView.delegate = self
        textView.layer.borderWidth = 1.0;
        textView.layer.borderColor = UIColor.lightGrayColor().CGColor
        textView.layer.cornerRadius = 6;
        textView.textColor = UIColor.lightGrayColor();
        textView.text = "Place Holder"
        
        
        print("---------------- SELF CHATID -------------")
        print(self.chatId)
        print("---------------- SELF IS PRIVATE -------------")
        print(self.isPrivate)
        
        if let chatId = self.chatId {
            getChat(chatId)
        }
        // Do any additional setup after loading the view.
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        self.returnPressed += 1
        if self.returnPressed > 17 {
            self.textView.frame = CGRectMake(8, 8, self.textView.frame.size.width, self.textView.frame.size.height + 17)
            self.newLine = CGFloat(17) * CGFloat(returnPressed)
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.dock.transform = CGAffineTransformMakeTranslation(0, -250 - self.newLine)
            })
        }
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        let pos:UITextPosition = self.textView.endOfDocument
        
        let currentRect:CGRect = self.textView.caretRectForPosition(pos)
        
        if currentRect.origin.y > self.previousRect.origin.y || self.textView.text == "\n" {
            self.returnPressed += 1
            if self.returnPressed < 17 && self.returnPressed > 1 {
//                self.textView.frame = CGRectMake(8, 8, self.textView.frame.size.width, self.textView.frame.size.height + 17)
//                self.newLine = CGFloat(17) * CGFloat(self.returnPressed)
//                UIView.animateWithDuration(0.1, animations: { () -> Void in
//                    self.dock.transform = CGAffineTransformMakeTranslation(0, -250 - self.newLine)
//                })
            }
        }
        self.previousRect = currentRect
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if self.textView.text == "" || self.textView.text == "Place Holder" {
            self.textView.text = ""
        }
        
        self.textView.textColor = UIColor.blackColor()
//        UIView.animateWithDuration(0.209, animations: { () -> Void in
//            self.dock.transform = CGAffineTransformMakeTranslation(0, -250 - self.newLine)
//        })
        
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        let touch:UITouch = [touches:AnyObject]
//        if touch.phase == UITouchPhase.Began {
//            self.textView.resignFirstResponder()
//            self.view.endEditing(true)
//            let height:Int = self.returnPressed * 20
//            
//            UIView.animateWithDuration(0.209, animations: { () -> Void in
//                self.dock.transform = CGAffineTransformMakeTranslation(0, -CGFloat(height))
//            })
//            
//            if self.textView.text == "" {
//                self.textView.textColor = UIColor.lightGrayColor()
//                self.textView.text = "Place Holder"
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getChat(id: String) {
        HttpHelper().request(ChatRouter.GetChat(id),
            success: {json in
                self.messages = json["data"]["messages"].arrayValue
                print("-------------- Print Count JSON response Get Chat --------------")
                print(self.messages.count)
                self.tableView.reloadData();
                print("-------------- FIN Count Print JSON response Get Chat --------------")
            },
            errors: {error in
                let alertController = UIAlertController(title: "Error Network", message: "\(error["message"])", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OKAY", style: UIAlertActionStyle.Default, handler: nil ))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        )

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("LeftChatCell", forIndexPath: indexPath) as! MessageTableViewCell
        let tabBarController = self.tabBarController as! TabBarViewController
        let user = tabBarController.user
        
        let message = self.messages[indexPath.row]
        
        if self.isPrivate, let userId = user!["_id"].string {
            if userId == message["user"]["_id"].string {
                cell.rightLabel.text = message["message"].string
                cell.leftLabelView.hidden = true
            } else {
                cell.leftLabel.text = message["message"].string
                cell.rightLabelView.hidden = true
            }
        }
        
        
        
        return cell
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
