//
//  WalkthroughViewController.swift
//  Cluztr
//
//  Created by Franck LAPEYRE on 05/10/2015.
//  Copyright © 2015 Cluztr. All rights reserved.
//

import UIKit

class WalkthroughViewController: UIViewController, UIPageViewControllerDataSource {
    
    var pageViewController : UIPageViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        startWalkthrough()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startWalkthrough() {
        /* Getting the page View controller */
        pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        
        let pageContentViewController = self.viewControllerAtIndex(0)
        self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }
    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
        
        let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageContentViewController") as! PageContentViewController
        
        if ((pageContentViewController.pageTitles.count == 0) || (index >= pageContentViewController.pageTitles.count)) {
            return nil
        }
        
        pageContentViewController.pageIndex   = index
        
        return pageContentViewController
    }
    
    
    // MARK: - Page View Controller DataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! PageContentViewController).pageIndex!
        let nbPages = (viewController as! PageContentViewController).pageTitles.count
        index++
        if (index >= nbPages) {
            return nil
        }
        
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! PageContentViewController).pageIndex!
        if (index <= 0) {
            return nil
        }
        index--
        
        return self.viewControllerAtIndex(index)
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
