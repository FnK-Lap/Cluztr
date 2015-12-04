//
//  GroupViewController.swift
//  Cluztr
//
//  Created by Franck LAPEYRE on 02/10/2015.
//  Copyright © 2015 Cluztr. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {
    
    var group: JSON?

    @IBOutlet weak var firstMemberImage: UIImageView!
    @IBOutlet weak var secondMemberImage: UIImageView!
    @IBOutlet weak var thirdMemberImage: UIImageView!
    
    @IBOutlet weak var firstMemberName: UIButton!
    @IBOutlet weak var secondMemberName: UIButton!
    @IBOutlet weak var thirdMemberName: UIButton!
    
    @IBOutlet weak var invitationHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBarController = self.tabBarController as! TabBarViewController
        let groupId = tabBarController.user!["groupId"]
        HttpHelper().request(GroupRouter.GetGroup(groupId),
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

        //  any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initUI() {
        self.tabBarItem.selectedImage = UIImage.init(named: "GroupIconSelected")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.tabBarItem.image = UIImage.init(named: "GroupIcon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        print("----- Group Informations -----")
        print(self.group)
        
        // Show invitation button on top if group is not full
        if self.group!["usersId"].count < 3 {
            self.invitationHeightConstraint.constant = 150
        } else {
            self.invitationHeightConstraint.constant = 0
        }
        self.view.layoutIfNeeded()
        
        // Set default value
        self.firstMemberName.titleLabel?.numberOfLines = 2
        self.firstMemberName.titleLabel?.textAlignment = .Center
        
        self.secondMemberName.titleLabel?.numberOfLines = 2
        self.secondMemberName.titleLabel?.textAlignment = .Center
        self.secondMemberName.setTitle("Invite\nun ami", forState: .Normal)
        
        self.thirdMemberName.titleLabel?.numberOfLines = 2
        self.thirdMemberName.titleLabel?.textAlignment = .Center
        self.thirdMemberName.setTitle("Invite\nun ami", forState: .Normal)
        
        for (key, user) in self.group!["usersId"] {
            // User Informations
            let profilePictureUrl = NSURL(string: user["profilePicture"]["url"].string!)!
            let firstname         = user["firstname"].string!
            let ageString         = "\(user["age"].number!) ans"
            
            let nameRange = NSMakeRange(0, firstname.characters.count)
            
            // Gender Icon
            let genderAttachment = NSTextAttachment()
            genderAttachment.image = UIImage(named: "\(user["gender"])")
            genderAttachment.bounds = CGRectMake(0, -1, 10, 10)
            
            // Prepare String and concat
            let nameAttributedString   = NSMutableAttributedString(string: "\(firstname)\n")
            let genderAttributedString = NSAttributedString(attachment: genderAttachment) as! NSMutableAttributedString
            let ageAttributedString    = NSMutableAttributedString(string: "\(ageString)")

            nameAttributedString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(15), range: nameRange)
            nameAttributedString.appendAttributedString(genderAttributedString)
            nameAttributedString.appendAttributedString(ageAttributedString)

            
            if key == "0" {
                self.loadPictureFrom(profilePictureUrl, withCompletion: { (picture, error) -> Void in
                    self.firstMemberImage.image = picture
                })
                self.firstMemberName.setAttributedTitle(nameAttributedString, forState: .Normal)
                
            } else if key == "1" {
                self.loadPictureFrom(profilePictureUrl, withCompletion: { (picture, error) -> Void in
                    self.secondMemberImage.image = picture
                })
                self.secondMemberName.setAttributedTitle(nameAttributedString, forState: .Normal)
                
            } else if key == "2" {
                self.loadPictureFrom(profilePictureUrl, withCompletion: { (picture, error) -> Void in
                    self.thirdMemberImage.image = picture
                })
                self.thirdMemberName.setAttributedTitle(nameAttributedString, forState: .Normal)
            }
        }
    }
    func loadPictureFrom(URL: NSURL, withCompletion completion:(picture: UIImage?, error: NSError?) -> Void) {
        let data = NSData(contentsOfURL: URL)!
        let picture = UIImage(data: data)
        
        completion(picture: picture, error: nil)
    }
    
    /*
    // MARK: Navigation 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "InviteSegue" {
            let destinationVC = segue.destinationViewController as! InvitationViewController
            let tabBarViewController = self.tabBarController as! TabBarViewController
        }
    }
    */

// 44  0.1725
// 173 0.6784
// 198 0.7764
}