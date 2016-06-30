//
//  JoinCreateGroupSuccessViewController.swift
//  Cluztr
//
//  Created by Franck LAPEYRE on 30/06/2016.
//  Copyright © 2016 Cluztr. All rights reserved.
//

import UIKit

class JoinCreateGroupSuccessViewController: UIViewController {
    
    var groupId: String?
    var group: JSON?
    var user: JSON?
    
    @IBOutlet weak var firstMemberImage: UIImageView!
    @IBOutlet weak var secondMemberImage: UIImageView!
    @IBOutlet weak var thirdMemberImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HttpHelper().request(GroupRouter.GetGroup(JSON(self.groupId!)),
            success: {json in
                // User Login
                self.group = json["data"]
                self.initUI()
            },
            errors: {error in
                let alertController = UIAlertController(title: "Error Network", message: "\(error["message"])", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OKAY", style: UIAlertActionStyle.Default, handler: nil ))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        )
        
    }
    
    @IBAction func continueButton(sender: AnyObject) {
        let startViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Start") as? TabBarViewController
        startViewController?.user = self.user
        self.presentViewController(startViewController!, animated: true, completion: nil)
    }
    
    func initUI() {
        print(self.group)
        
        for (key, value) in self.group!["usersId"] {
            let url = NSURL(string: value["profilePicture"]["url"].string!)!
            if key == "0" {
                self.loadPictureFrom(url, withCompletion: { (picture, error) -> Void in
                    self.firstMemberImage.image = picture
                })
            } else if key == "1" {
                self.loadPictureFrom(url, withCompletion: { (picture, error) -> Void in
                    self.secondMemberImage.image = picture
                })
            } else if key == "2" {
                self.loadPictureFrom(url, withCompletion: { (picture, error) -> Void in
                    self.thirdMemberImage.image = picture
                })
            }
        }
    }
    
    func loadPictureFrom(URL: NSURL, withCompletion completion:(picture: UIImage?, error: NSError?) -> Void) {
        let data = NSData(contentsOfURL: URL)!
        let picture = UIImage(data: data)
        
        completion(picture: picture, error: nil)
    }
}
