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
    
    func initUI() {
        for (index, image) in self.memberImages.enumerate() {

        }
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
