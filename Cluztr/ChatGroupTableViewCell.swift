//
//  ChatGroupTableViewCell.swift
//  Cluztr
//
//  Created by Franck LAPEYRE on 04/12/2015.
//  Copyright © 2015 Cluztr. All rights reserved.
//

import UIKit

class ChatGroupTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    @IBOutlet var memberImages: [UIImageView]!
    
    func initUI(chat:JSON) {
        print(chat)
        
        if chat["isPrivate"] {
            for (index, user) in chat["ownGroup"]["usersId"].enumerate() {
                let url = NSURL(string: user.1["profilePicture"]["url"].string!)
                self.loadPictureFrom(url!, withCompletion: { (picture, error) -> Void in
                    self.memberImages[index].image = picture
                })
            }
        } else {
            var chatName:String = ""
            for (index, user) in chat["otherGroup"]["usersId"].enumerate() {
                // Concat name
                chatName != "" ? (chatName += ", \(user.1["firstname"])") : (chatName += user.1["firstname"].string!)
                let url = NSURL(string: user.1["profilePicture"]["url"].string!)
                self.loadPictureFrom(url!, withCompletion: { (picture, error) -> Void in
                    self.memberImages[index].image = picture
                })
            }
            self.nameLabel.text = chatName
        }
        
        self.lastMessageLabel.text = chat["messages"][0]["message"].string
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadPictureFrom(URL: NSURL, withCompletion completion:(picture: UIImage?, error: NSError?) -> Void) {
        let data = NSData(contentsOfURL: URL)!
        let picture = UIImage(data: data)
        
        completion(picture: picture, error: nil)
    }

}
