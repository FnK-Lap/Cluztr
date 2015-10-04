//
//  ViewController.swift
//  Cluztr
//
//  Created by Franck LAPEYRE on 04/10/2015.
//  Copyright © 2015 Cluztr. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource {
    
    let pageTitles = ["Invite", "Recherche", "Rencontre"]
    var images = ["Walkthroughs","Walkthroughs","Walkthroughs"]
    var pageContents = ["Invite 2 de tes amis pour créer ton \n groupe Cluztr.", "Trouve d'autres groupes en fonction \n de leurs centres d'intérëts.", "Mettez vous d'accord d'un lieu et \n d'une activité avec le tchat."]
    var count = 0
    
    var pageViewController : UIPageViewController!
    
    func reset() {
        /* Getting the page View controller */
        pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        
        let pageContentViewController = self.viewControllerAtIndex(0)
        self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        /* We are substracting 30 because we have a start again button whose height is 30*/
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height
        )
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
        // Do any additional setup after loading the view.
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
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    
        var index = (viewController as! PageContentViewController).pageIndex!
        index++
        if(index >= self.images.count){
            return nil
        }
        return self.viewControllerAtIndex(index)
    
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
    
        var index = (viewController as! PageContentViewController).pageIndex!
        if(index <= 0){
            return nil
        }
        index--
        return self.viewControllerAtIndex(index)
    
    }
    
    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
        if((self.pageTitles.count == 0) || (index >= self.pageTitles.count)) {
            return nil
        }
        let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageContentViewController") as! PageContentViewController
    
        pageContentViewController.imageName   = self.images[index]
        pageContentViewController.titleText   = self.pageTitles[index]
        pageContentViewController.pageIndex   = index
        pageContentViewController.contentText = self.pageContents[index]
    
        return pageContentViewController
    }

}
