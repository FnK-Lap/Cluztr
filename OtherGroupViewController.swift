//
//  OtherGroupViewController.swift
//  Cluztr
//
//  Created by Franck LAPEYRE on 25/06/2016.
//  Copyright © 2016 Cluztr. All rights reserved.
//

import UIKit

class OtherGroupViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var group: JSON?

    @IBOutlet weak var firstMemberImage: UIImageView!
    @IBOutlet weak var secondMemberImage: UIImageView!
    @IBOutlet weak var thirdMemberImage: UIImageView!
    
    @IBOutlet weak var firstMemberName: UIButton!
    @IBOutlet weak var secondMemberName: UIButton!
    @IBOutlet weak var thirdMemberName: UIButton!
    
    @IBOutlet weak var bigPicture: UIImageView!
    
    @IBOutlet weak var InterestCollectionView: UICollectionView!
    
    @IBAction func sendCluztButton(sender: UIButton) {
        HttpHelper().request(GroupRouter.PostCluzt(group!["_id"]),
            success: {json in
                print(json)
            },
            errors: {error in
                let alertController = UIAlertController(title: "Error Network", message: "\(error["message"])", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OKAY", style: UIAlertActionStyle.Default, handler: nil ))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.InterestCollectionView.delegate = self
        self.InterestCollectionView.dataSource = self
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
        InterestCollectionView.reloadData()
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
        InterestCollectionView.reloadData()
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
        InterestCollectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("interestCell3", forIndexPath: indexPath) as! InterestListCollectionViewCell
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

    
    @IBAction func backButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func loadPictureFrom(URL: NSURL, withCompletion completion:(picture: UIImage?, error: NSError?) -> Void) {
        let data = NSData(contentsOfURL: URL)!
        let picture = UIImage(data: data)
        
        completion(picture: picture, error: nil)
    }
}
