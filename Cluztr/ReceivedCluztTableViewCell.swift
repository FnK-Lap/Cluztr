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
    }
    
    func loadPictureFrom(URL: NSURL, withCompletion completion:(picture: UIImage?, error: NSError?) -> Void) {
        let data = NSData(contentsOfURL: URL)!
        let picture = UIImage(data: data)
        
        completion(picture: picture, error: nil)
    }
    
}
