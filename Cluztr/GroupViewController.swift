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
        print(self.group)
        
        for (key, user) in self.group!["usersId"] {
            // User Informations
            let profilePictureUrl = NSURL(string: user["profilePicture"]["url"].string!)!
            let firstname         = user["firstname"].string!
            let ageString         = "\(user["age"].number!) ans"
            
            let ageRange = NSMakeRange(0, ageString.characters.count)
            
            // Gender Icon
            let genderAttachment = NSTextAttachment()
            genderAttachment.image = UIImage(named: "\(user["gender"])")
            genderAttachment.bounds = CGRectMake(0, -1, 10, 10)
            
            // Prepare String and concat
            let nameAttributedString   = NSMutableAttributedString(string: "\(firstname)\n")
            let genderAttributedString = NSAttributedString(attachment: genderAttachment) as! NSMutableAttributedString
            let ageAttributedString    = NSMutableAttributedString(string: "\(ageString)")

            ageAttributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(12), range: ageRange)
            nameAttributedString.appendAttributedString(genderAttributedString)
            nameAttributedString.appendAttributedString(ageAttributedString)

            
            if key == "0" {
                self.loadPictureFrom(profilePictureUrl, withCompletion: { (picture, error) -> Void in
                    self.firstMemberImage.image = picture
                })
                self.firstMemberName.titleLabel?.numberOfLines = 2
                self.firstMemberName.titleLabel?.textAlignment = .Center
                self.firstMemberName.setAttributedTitle(nameAttributedString, forState: .Normal)
                
            } else if key == "1" {
                self.loadPictureFrom(profilePictureUrl, withCompletion: { (picture, error) -> Void in
                    self.secondMemberImage.image = picture
                })
                self.secondMemberName.titleLabel?.numberOfLines = 2
                self.secondMemberName.titleLabel?.textAlignment = .Center
                self.secondMemberName.setAttributedTitle(nameAttributedString, forState: .Normal)
                
            } else if key == "2" {
                self.loadPictureFrom(profilePictureUrl, withCompletion: { (picture, error) -> Void in
                    self.thirdMemberImage.image = picture
                })
                self.thirdMemberName.titleLabel?.numberOfLines = 2
                self.thirdMemberName.titleLabel?.textAlignment = .Center
                self.thirdMemberName.setAttributedTitle(nameAttributedString, forState: .Normal)
            }
        }
    }
    
    func loadPictureFrom(URL: NSURL, withCompletion completion:(picture: UIImage?, error: NSError?) -> Void) {
        let data = NSData(contentsOfURL: URL)!
        let picture = UIImage(data: data)
        
        completion(picture: picture, error: nil)
    }


// 44  0.1725
// 173 0.6784
// 198 0.7764
}

