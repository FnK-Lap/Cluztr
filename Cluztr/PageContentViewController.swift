//
//  PageContentViewController.swift
//  Cluztr
//
//  Created by Franck LAPEYRE on 04/10/2015.
//  Copyright © 2015 Cluztr. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class PageContentViewController: UIViewController {
    
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var bkImageView: UIImageView!
    @IBOutlet weak var pageControlDot: UIPageControl!
    @IBOutlet weak var contentLabel: UILabel!
    
    var pageIndex  : Int?
    var loginButton: FBSDKLoginButton?
    
    let pageTitles = [
        "Rejoins",
        "Sors",
        "Amuse toi"
    ]
    let images = [
        "Walkthroughs - 01",
        "Walkthroughs - 02",
        "Walkthroughs - 03"
    ]
    let pageContents = [
        "Rejoins ou invite 2 de tes amis \n pour créer un groupe",
        "Sors entre amis et laisse Cluztr te présenter \n les groupes qui te correspondent",
        "Mettez-vous d'accord d'un lieu \n et faites connaissance"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Image
        self.bkImageView.image = UIImage(named: self.images[self.pageIndex!])
        
        // Heading
        self.heading.text  = self.pageTitles[self.pageIndex!]
        self.heading.alpha = 0.1
        
        // Content
        self.contentLabel.text  = self.pageContents[self.pageIndex!]
        self.contentLabel.alpha = 0.1
        
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.heading.alpha      = 1.0
            self.contentLabel.alpha = 1.0
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
