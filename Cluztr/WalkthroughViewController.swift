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
import Alamofire
import Locksmith


class WalkthroughViewController: UIViewController, UIPageViewControllerDataSource, FBSDKLoginButtonDelegate {
    
    var pageViewController : UIPageViewController!
    var logged: Bool = false
    var user: JSON?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("--------------- ACCESS TOKEN in Keychain ----------------")
        print(Locksmith.loadDataForUserAccount("access_token"))
        print("------------- FIN ACCESS TOKEN in Keychain --------------")
        
        // Check Facebook Login
        if FBSDKAccessToken.currentAccessToken() == nil {
            print("----- Not logged : (FB + API)")
            startWalkthrough()
        } else {
            print("----- Logged FB, Not logged API")
            
            self.loginAPI()
            
        }
        
        
        
        
        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginAPI() {
        HttpHelper().request(UserRouter.LoginUser(["fb_access_token":FBSDKAccessToken.currentAccessToken().tokenString]),
            success: {json in
                // User Login
                if (json["status"] == 200) {
                    print("-- User exist, log in")
                } else if (json["status"] == 201) {
                    // User Create
                    print("-- User create, log in")
                }
                
                self.logged = true
                self.user = json["user"]
                UserModel().loginUser(json["token"], email: self.user!["email"])
                if self.user!["groupId"] != nil {
                    self.performSegueWithIdentifier("StartSegue", sender: nil)
                } else {
                    self.performSegueWithIdentifier("SelectGroupSegue", sender: nil)
                }
            },
            errors: {error in
                print("else")
                
                let alertController = UIAlertController(title: "Error Network", message: "\(error["message"])", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OKAY", style: UIAlertActionStyle.Default, handler: nil ))
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
                if self.logged == false {
                    FBSDKLoginManager().logOut()
                    self.startWalkthrough()
                }
            }
        )
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
        loginButton.readPermissions = ["public_profile", "email", "user_birthday"]
        
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
            print("----- Logged FB, Not logged API")
            self.loginAPI()
            
        } else {
            print(error.localizedDescription)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("----- User logged out")
        self.logged = false
        
        if let _ = Locksmith.loadDataForUserAccount("access_token") {
            do {
                try Locksmith.deleteDataForUserAccount("access_token")
            } catch _ {
                print("Error delete access token from keychain")
            }
        }
        
        startWalkthrough()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "StartSegue" {
            let destinationVC = segue.destinationViewController as! TabBarViewController
            destinationVC.user = self.user
        }
    }

}
