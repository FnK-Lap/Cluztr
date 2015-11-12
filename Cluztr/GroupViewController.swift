//
//  GroupViewController.swift
//  Cluztr
//
//  Created by Franck LAPEYRE on 02/10/2015.
//  Copyright © 2015 Cluztr. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {
    
    var group: JSON?

    @IBOutlet weak var firstMemberImage: UIImageView!
    @IBOutlet weak var secondMemberImage: UIImageView!
    @IBOutlet weak var thirdMemberImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBarController = self.tabBarController as! TabBarViewController
        let groupId = tabBarController.user!["groupId"]
        HttpHelper().request(GroupRouter.GetGroup(groupId), fromController: self,
            success: {json in
                // User Login
                self.group = json["data"]
                self.initUI()
            },
            errors: {_ in
                // TODO: Error
            }
        )

        //  any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initUI() {
        self.tabBarItem.selectedImage = UIImage.init(named: "GroupIconSelected")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.tabBarItem.image = UIImage.init(named: "GroupIcon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        print(self.group)
        
        
        for (key, user) in self.group!["usersId"] {
            print(key)
            let url = NSURL(string: user["profilePicture"]["url"].string!)!
            print(url);
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


// 44  0.1725
// 173 0.6784
// 198 0.7764
}

