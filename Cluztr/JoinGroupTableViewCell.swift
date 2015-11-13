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
    @IBOutlet weak var acceptButton: UIButton!
    
    func initUI() {
        self.userInviteLabel.text = "\(self.user!["firstname"]) vous invite a rejoindre son groupe."
        
        for (key, user) in self.group!["usersId"] {
            print(key)
            let url = NSURL(string: user["profilePicture"]["url"].string!)!
            print(url);
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
    
    @IBAction func acceptButton(sender: AnyObject) {
        HttpHelper().request(GroupRouter.Join(),
            fromController: self,
            success: {_ in
                let tabBarViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Start") as TabBarViewController
                self.pushViewController(TabBarViewController, animated: true)
            },
            errors: {_ in
                //error message
            }
        )}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
