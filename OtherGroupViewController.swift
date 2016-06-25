//
//  OtherGroupViewController.swift
//  Cluztr
//
//  Created by Franck LAPEYRE on 25/06/2016.
//  Copyright © 2016 Cluztr. All rights reserved.
//

import UIKit

class OtherGroupViewController: UIViewController {
    
    var group: JSON?

    @IBOutlet weak var firstMemberImage: UIImageView!
    @IBOutlet weak var secondMemberImage: UIImageView!
    @IBOutlet weak var thirdMemberImage: UIImageView!
    
    @IBOutlet weak var firstMemberName: UIButton!
    @IBOutlet weak var secondMemberName: UIButton!
    @IBOutlet weak var thirdMemberName: UIButton!
    
    @IBOutlet weak var bigPicture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        // Do any additional setup after loading the view.
    }
    
    func initUI() {
        // Set default value
        self.firstMemberName.titleLabel?.numberOfLines = 2
        self.firstMemberName.titleLabel?.textAlignment = .Center
        
        self.secondMemberName.titleLabel?.numberOfLines = 2
        self.secondMemberName.titleLabel?.textAlignment = .Center
        self.secondMemberName.setTitle("", forState: .Normal)
        
        self.thirdMemberName.titleLabel?.numberOfLines = 2
        self.thirdMemberName.titleLabel?.textAlignment = .Center
        self.thirdMemberName.setTitle("", forState: .Normal)

        for (key, user) in self.group!["usersId"] {
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
    
    @IBAction func clickFirstUser(sender: UIButton) {
        if firstMemberName.selected == false {
            firstMemberName.selected = true
            if self.group!["usersId"][0].error == nil {
                bigPicture.hidden = false
                let url = NSURL(string: self.group!["usersId"][0]["profilePicture"]["url"].string!)
                self.loadPictureFrom(url!, withCompletion: { (picture, error) -> Void in
                    self.bigPicture.image = picture
                })
            }
        } else {
            firstMemberName.selected = false
            self.bigPicture.hidden = true
        }
        secondMemberName.selected = false
        thirdMemberName.selected = false
//        interestCollectionview2.reloadData()
    }
    @IBAction func clickSecondUser(sender: UIButton) {
        if secondMemberName.selected == false {
            secondMemberName.selected = true
            if self.group!["usersId"][1].error == nil {
                bigPicture.hidden = false
                let url = NSURL(string: self.group!["usersId"][1]["profilePicture"]["url"].string!)
                self.loadPictureFrom(url!, withCompletion: { (picture, error) -> Void in
                    self.bigPicture.image = picture
                })
            }
        } else {
            secondMemberName.selected = false
            self.bigPicture.hidden = true
        }
        firstMemberName.selected = false
        thirdMemberName.selected = false
//        interestCollectionview2.reloadData()
    }
    
    @IBAction func clickThirdUser(sender: UIButton) {
        if thirdMemberName.selected == false {
            thirdMemberName.selected = true
            if self.group!["usersId"][2].error == nil {
                bigPicture.hidden = false
                let url = NSURL(string: self.group!["usersId"][2]["profilePicture"]["url"].string!)
                self.loadPictureFrom(url!, withCompletion: { (picture, error) -> Void in
                    self.bigPicture.image = picture
                })
            } else {
                thirdMemberName.selected = false
                self.bigPicture.hidden = true
            }
        } else {
            thirdMemberName.selected = false
            self.bigPicture.hidden = true
        }
        secondMemberName.selected = false
        firstMemberName.selected = false
//        interestCollectionview2.reloadData()
    }

    
    @IBAction func backButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func loadPictureFrom(URL: NSURL, withCompletion completion:(picture: UIImage?, error: NSError?) -> Void) {
        let data = NSData(contentsOfURL: URL)!
        let picture = UIImage(data: data)
        
        completion(picture: picture, error: nil)
    }
}
