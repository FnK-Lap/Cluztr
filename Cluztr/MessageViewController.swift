//
//  MessageViewController.swift
//  Cluztr
//
//  Created by Franck LAPEYRE on 08/12/2015.
//  Copyright © 2015 Cluztr. All rights reserved.
//

import UIKit


class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var dockHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dockMaxHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomTextViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var dock: UIView!

    @IBOutlet weak var tableView: UITableView!
    
    var returnPressed:Int = 1
    var newLine:CGFloat = 0
    var previousRect:CGRect = CGRectZero
    
    var chatId:String?
    var isPrivate:Bool = true
    var messages: Array<JSON> = []
    let socket = SocketIOClient(socketURL: NSURL(string: "https://cluztr.herokuapp.com")!, options: [.Log(false), .ForcePolling(false)])
    
    @IBAction func sendMessageButton(sender: AnyObject) {
        print("Message Send")
        let tabBarController = self.tabBarController as! TabBarViewController
        let userId = tabBarController.user!["_id"]
        socket.emit("private message", "\(chatId!)", "\(userId)", "\(self.textView.text)")
        self.textView.text = "";
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        tableView.separatorColor = UIColor.clearColor()
        
        self.textView.delegate = self
        textView.layer.borderWidth = 1.0;
        textView.layer.borderColor = UIColor.lightGrayColor().CGColor
        textView.layer.cornerRadius = 6;
        textView.textColor = UIColor.lightGrayColor();
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasHidden:", name: UIKeyboardDidHideNotification, object: nil)
        
        
        print("---------------- SELF CHATID -------------")
        print(self.chatId)
        print("---------------- SELF IS PRIVATE -------------")
        print(self.isPrivate)
        
        if let chatId = self.chatId {
            getChat(chatId)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        socket.connect()
        
        socket.on(chatId!) { data, ack in
            if (self.tabBarController != nil) {
                print("new Message")
                let json = JSON(data[0])
                print("\(json["message"])")
                self.messages += [json["message"]]
                self.tableView.reloadData()
                self.scrollToLastRow()
                print(self.messages)
            }
        }

    }
    
    
    func textViewDidChange(textView: UITextView)
    {
        let oldHeight : CGFloat = textView.frame.size.height
        let fixedWidth : CGFloat = textView.frame.size.width
        let newSize : CGSize = textView.sizeThatFits(CGSizeMake(fixedWidth, CGFloat(MAXFLOAT)))
        var newFrame : CGRect = CGRectMake(8, 8, textView.frame.width, textView.frame.height)
        newFrame.size = CGSizeMake(CGFloat(fmaxf((Float)(newSize.width), (Float)(fixedWidth))),newSize.height)
        print(self.dockHeightConstraint.constant + (newSize.height - oldHeight))
        self.dockHeightConstraint.constant += (newSize.height - oldHeight)
        if self.dockHeightConstraint.constant < self.dockMaxHeightConstraint.constant {
            

            textView.frame = newFrame
        } else {
            if textView.frame.height > newFrame.height {
                textView.frame = newFrame
            }
        }
    }
    
    func keyboardWasShown(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1) { () -> Void in
            self.bottomTextViewConstraint.constant = keyboardFrame.size.height - 50
            self.scrollToLastRow()
        }
    }
    
    func keyboardWasHidden(notification: NSNotification) {
        UIView.animateWithDuration(0.1) { () -> Void in
            self.bottomTextViewConstraint.constant = 8
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getChat(id: String) {
        HttpHelper().request(ChatRouter.GetChat(id),
            success: {json in
                self.isPrivate = json["data"]["isPrivate"].boolValue
                self.messages = json["data"]["messages"].arrayValue
                print("-------------- Print Count JSON response Get Chat --------------")
                print(self.messages.count)
                self.tableView.reloadData();
                self.scrollToLastRow();
                print("-------------- FIN Count Print JSON response Get Chat --------------")
            },
            errors: {error in
                let alertController = UIAlertController(title: "Error Network", message: "\(error["message"])", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OKAY", style: UIAlertActionStyle.Default, handler: nil ))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        )

    }
    
    func scrollToLastRow() {
        if self.messages.count > 1 {
            let indexPath = NSIndexPath(forRow: self.messages.count - 1, inSection: 0)
            self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LeftChatCell", forIndexPath: indexPath) as! MessageTableViewCell
        let tabBarController = self.tabBarController as! TabBarViewController
        let user = tabBarController.user
        
        let message = self.messages[indexPath.row]
        
        if self.isPrivate, let userId = user!["_id"].string {
            
            
            if userId == (message["user"]["_id"].string != nil ? message["user"]["_id"].string : message["user"].string) {
                cell.rightLabel.text = message["message"].string
                cell.leftLabel.text = ""
                cell.leftLabelView.hidden = true
                cell.rightLabelView.hidden = false
            } else {
                cell.leftLabel.text = message["message"].string
                cell.rightLabel.text = ""
                cell.rightLabelView.hidden = true
                cell.leftLabelView.hidden = false
            }
        } else {
            let userId = user!["_id"].string
            print("ccccccccccccccccc")
            print(message["user"])
            
            if userId == (message["user"]["_id"].string != nil ? message["user"]["_id"].string : message["user"].string) {
                cell.rightLabel.text = message["message"].string
                cell.leftLabel.text = ""
                cell.leftLabelView.hidden = true
                cell.rightLabelView.hidden = false
            } else {
                cell.leftLabel.text = message["message"].string
                cell.rightLabel.text = ""
                cell.rightLabelView.hidden = true
                cell.leftLabelView.hidden = false
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
