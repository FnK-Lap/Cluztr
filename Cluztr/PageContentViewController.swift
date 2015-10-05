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
    
    let pageTitles = [
        "Invite",
        "Recherche",
        "Rencontre"
    ]
    let images = [
        "Walkthroughs - 01",
        "Walkthroughs - 02",
        "Walkthroughs - 03"
    ]
    let pageContents = [
        "Invite 2 de tes amis pour créer ton \n groupe Cluztr.",
        "Trouve d'autres groupes en fonction \n de leurs centres d'intérëts.",
        "Mettez vous d'accord d'un lieu et \n d'une activité avec le tchat."
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageControlDot.currentPage = pageIndex!
        
        self.bkImageView.image = UIImage(named: self.images[self.pageIndex!])
        
        self.heading.text  = self.pageTitles[self.pageIndex!]
        self.heading.alpha = 0.1
        
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
