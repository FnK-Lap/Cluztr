//
//  PageContentViewController.swift
//  Cluztr
//
//  Created by Franck LAPEYRE on 04/10/2015.
//  Copyright © 2015 Cluztr. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {
    
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var bkImageView: UIImageView!
    @IBOutlet weak var pageControlDot: UIPageControl!
    @IBOutlet weak var contentLabel: UILabel!
    
    var pageIndex  : Int?
    var titleText  : String!
    var imageName  : String!
    var contentText: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageControlDot.currentPage = pageIndex!
        self.bkImageView.image = UIImage(named: imageName)
        self.heading.text  = self.titleText
        self.heading.alpha = 0.1
        self.contentLabel.text  = self.contentText
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
