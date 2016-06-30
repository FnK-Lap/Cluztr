//
//  ReceivedCluztTableViewCell.swift
//  Cluztr
//
//  Created by Franck LAPEYRE on 29/06/2016.
//  Copyright © 2016 Cluztr. All rights reserved.
//

import UIKit

class ReceivedCluztTableViewCell: UITableViewCell {
    
    var cluzt: JSON?

    @IBOutlet weak var firstMemberImage: UIImageView!
    @IBOutlet weak var secondMemberImage: UIImageView!
    @IBOutlet weak var thirdMemberImage: UIImageView!
    
    @IBOutlet weak var firstMemberName: UILabel!
    @IBOutlet weak var secondMemberName: UILabel!
    
    @IBOutlet weak var firstMemberHeart: UIImageView!
    @IBOutlet weak var secondMemberHeart: UIImageView!
    
    func initUI(cluzt:JSON) {
        self.cluzt = cluzt
        
        
        print(cluzt)
        
        for (key, value) in self.cluzt!["sender"]["usersId"] {
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
        
        self.firstMemberHeart.tintColor = UIColor.lightGrayColor()
        self.secondMemberHeart.tintColor = UIColor.lightGrayColor()
        var indexHeart = 0
        var indexName = 0
        let connectedUser = NSUserDefaults.standardUserDefaults().objectForKey("userId") as! String
        for (key, user) in self.cluzt!["receiver"]["usersId"] {
            if user["_id"].stringValue != connectedUser && indexName == 0 {
                self.firstMemberName.text = user["firstname"].stringValue
                indexName++
            } else if user["_id"].stringValue != connectedUser && indexName == 1 {
                self.secondMemberName.text = user["firstname"].stringValue
                indexName++
            }
            if cluzt["acceptedUsers"].arrayValue.contains(user["_id"]) && user["_id"].stringValue != connectedUser {
                if indexHeart == 0 {
                    self.firstMemberHeart.tintColor = UIColor.init(red: 115/255, green: 217/255, blue: 150/255, alpha: 1)
                } else {
                    self.secondMemberHeart.tintColor = UIColor.init(red: 115/255, green: 217/255, blue: 150/255, alpha: 1)
                }
                indexHeart++
            }
        }
    }
    
    func loadPictureFrom(URL: NSURL, withCompletion completion:(picture: UIImage?, error: NSError?) -> Void) {
        let data = NSData(contentsOfURL: URL)!
        let picture = UIImage(data: data)
        
        completion(picture: picture, error: nil)
    }
    
}
