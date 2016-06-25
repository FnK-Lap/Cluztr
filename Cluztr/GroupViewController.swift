//
//  GroupViewController.swift
//  Cluztr
//
//  Created by Franck LAPEYRE on 02/10/2015.
//  Copyright © 2015 Cluztr. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var group: JSON?

    @IBOutlet weak var firstMemberImage: UIImageView!
    @IBOutlet weak var secondMemberImage: UIImageView!
    @IBOutlet weak var thirdMemberImage: UIImageView!
    @IBOutlet weak var bigPicture: UIImageView!
    
    @IBOutlet weak var firstMemberName: UIButton!
    @IBOutlet weak var secondMemberName: UIButton!
    @IBOutlet weak var thirdMemberName: UIButton!
    
    @IBOutlet weak var interestCollectionview2: UICollectionView!
    
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
        interestCollectionview2.reloadData()
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
        interestCollectionview2.reloadData()
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
        interestCollectionview2.reloadData()
    }
    
    @IBOutlet weak var invitationHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interestCollectionview2.delegate = self
        interestCollectionview2.dataSource = self
        let tabBarController = self.tabBarController as! TabBarViewController
        let groupId = tabBarController.user!["groupId"]
        HttpHelper().request(GroupRouter.GetGroup(groupId),
            success: {json in
                // User Login
                self.group = json["data"]
                self.interestCollectionview2.reloadData()
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
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var groupInterests: [String] = []
        if (group != nil) {
            if self.group!["interests"]{
                return self.group!["interests"].count
            } else {
                for (_, user) in group!["usersId"] {
                    print("###################")
                    print(user["interests"])
                    for (_, interest) in user["interests"] {
                        if !(groupInterests.contains(interest["name"].string!)) {
                            groupInterests.append(interest["name"].string!)
                        }
                    }
                }
                
                self.group!["interests"] = JSON(groupInterests)
                return groupInterests.count
            }
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("interestCell2", forIndexPath: indexPath) as! InterestListCollectionViewCell
        cell.interestName.textColor = UIColor(red: 44/256, green: 173/256, blue: 198/256, alpha: 1)
        cell.backgroundColor = UIColor.whiteColor()
        if firstMemberName.selected {
            for (_, interest) in group!["usersId"][0]["interests"] {
                if (interest["name"].string == group!["interests"][indexPath.row].string!) {
                    cell.backgroundColor = UIColor(red: 44/256, green: 173/256, blue: 198/256, alpha: 1)
                    cell.interestName.textColor = UIColor.whiteColor()
                }
            }
        }
        if secondMemberName.selected {
            for (_, interest) in group!["usersId"][1]["interests"] {
                if (interest["name"].string == group!["interests"][indexPath.row].string!) {
                    cell.backgroundColor = UIColor(red: 44/256, green: 173/256, blue: 198/256, alpha: 1)
                    cell.interestName.textColor = UIColor.whiteColor()
                }
            }
        }
        if thirdMemberName.selected {
            for (_, interest) in group!["usersId"][2]["interests"] {
                if (interest["name"].string == group!["interests"][indexPath.row].string!) {
                    cell.backgroundColor = UIColor(red: 44/256, green: 173/256, blue: 198/256, alpha: 1)
                    cell.interestName.textColor = UIColor.whiteColor()
                }
            }
        }
        cell.interestName.text = group!["interests"][indexPath.row].string!
        
        return cell
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