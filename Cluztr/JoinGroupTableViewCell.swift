//
//  JoinGroupTableViewCell.swift
//  Cluztr
//
//  Created by Franck LAPEYRE on 13/11/2015.
//  Copyright © 2015 Cluztr. All rights reserved.
//

import UIKit

class JoinGroupTableViewCell: UITableViewCell {
    
    var group: JSON?
    var user: JSON?

    @IBOutlet weak var userInviteLabel: UILabel!
    @IBOutlet weak var firstUserImage: UIImageView!
    @IBOutlet weak var secondUserImage: UIImageView!
    @IBOutlet weak var joinButton: UIButton!
    
    func initUI(user: JSON, group: JSON) {
        self.user = user
        self.group = group
        self.userInviteLabel.text = "\(self.user!["firstname"]) vous invite a rejoindre son groupe."
        
        for (key, value) in self.group!["usersId"] {
            let url = NSURL(string: value["profilePicture"]["url"].string!)!
            if key == "0" {
                self.loadPictureFrom(url, withCompletion: { (picture, error) -> Void in
                    self.firstUserImage.image = picture
                })
            } else if key == "1" {
                self.loadPictureFrom(url, withCompletion: { (picture, error) -> Void in
                    self.secondUserImage.image = picture
                })
            }
        }
    }
    
    func loadPictureFrom(URL: NSURL, withCompletion completion:(picture: UIImage?, error: NSError?) -> Void) {
        let data = NSData(contentsOfURL: URL)!
        let picture = UIImage(data: data)
        
        completion(picture: picture, error: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
