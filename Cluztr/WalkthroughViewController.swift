//
//  WalkthroughViewController.swift
//  Cluztr
//
//  Created by Franck LAPEYRE on 05/10/2015.
//  Copyright © 2015 Cluztr. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class WalkthroughViewController: UIViewController, UIPageViewControllerDataSource, FBSDKLoginButtonDelegate {
    
    var pageViewController : UIPageViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check Facebook Login
        if FBSDKAccessToken.currentAccessToken() == nil {
            print("Not logged")
            startWalkthrough()
        } else {
            print("Logged in")
//            
//            // DEBUG : Logout button
//            var loginButton = FBSDKLoginButton()
//            loginButton.readPermissions = ["read_profile", "email"]
//            loginButton.delegate = self
//            loginButton.center = self.view.center
//            
//            self.view.addSubview(loginButton)

        }
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        if FBSDKAccessToken.currentAccessToken() != nil {
            print("View Did Appear logged")
            let startViewController = storyboard?.instantiateViewControllerWithIdentifier("Start") as? TabBarViewController
            self.presentViewController(startViewController!, animated: true, completion: nil)
        }
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
        
        // Create Fb Login Button
        let loginButton = FBSDKLoginButton()
        loginButton.delegate = self
        loginButton.readPermissions = ["public_profile", "email"]
        
        // Pass login button and index to pageViewController
        pageContentViewController.pageIndex   = index
        pageContentViewController.loginButton = loginButton
            
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
    
    // MARK: - Facebook Login
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if error == nil {
            // Retour de Facebook
            print("login complete")
            
            // TODO: - Check token with API
            performSegueWithIdentifier("StartSegue", sender: nil)
        } else {
            print(error.localizedDescription)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User logged out")
        startWalkthrough()
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
