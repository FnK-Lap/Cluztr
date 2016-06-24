//
//  ListGroupTableViewCell.swift
//  Cluztr
//
//  Created by Franck LAPEYRE on 20/06/2016.
//  Copyright © 2016 Cluztr. All rights reserved.
//

import UIKit

class ListGroupTableViewCell: UITableViewCell {
    
    var group: JSON?
    
    @IBOutlet weak var firstMemberImage: UIImageView!
    @IBOutlet weak var secondMemberImage: UIImageView!
    @IBOutlet weak var thirdMemberImage: UIImageView!
    
    @IBOutlet weak var firstMemberLabel: UILabel!
    @IBOutlet weak var secondMemberLabel: UILabel!
    @IBOutlet weak var thirdMemberLabel: UILabel!
    
    @IBOutlet private weak var interestCollectionView: UICollectionView!
    
    func setCollectionViewDataSourceDelegate
        <D: protocol<UICollectionViewDataSource, UICollectionViewDelegate>>
        (dataSourceDelegate: D, forRow row: Int) {
            
            interestCollectionView.delegate = dataSourceDelegate
            interestCollectionView.dataSource = dataSourceDelegate
            interestCollectionView.tag = row
            interestCollectionView.reloadData()
    }
    
    func initUI(group: JSON) {
        self.group = group
        
        for (key, value) in self.group!["usersId"] {
            let url = NSURL(string: value["profilePicture"]["url"].string!)!
            if key == "0" {
                self.loadPictureFrom(url, withCompletion: { (picture, error) -> Void in
                    self.firstMemberImage.image = picture
                })
                self.firstMemberLabel.text = "\(value["firstname"].string!)"
            } else if key == "1" {
                self.loadPictureFrom(url, withCompletion: { (picture, error) -> Void in
                    self.secondMemberImage.image = picture
                })
                self.secondMemberLabel.text = "\(value["firstname"].string!)"
            } else if key == "2" {
                self.loadPictureFrom(url, withCompletion: { (picture, error) -> Void in
                    self.thirdMemberImage.image = picture
                })
                self.thirdMemberLabel.text = "\(value["firstname"].string!)"
            }
        }
        
    }
    
    func loadPictureFrom(URL: NSURL, withCompletion completion:(picture: UIImage?, error: NSError?) -> Void) {
        let data = NSData(contentsOfURL: URL)!
        let picture = UIImage(data: data)
        
        completion(picture: picture, error: nil)
    }
}
