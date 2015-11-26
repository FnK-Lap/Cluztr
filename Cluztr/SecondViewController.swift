//
//  SecondViewController.swift
//  Cluztr
//
//  Created by Franck LAPEYRE on 02/10/2015.
//  Copyright © 2015 Cluztr. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Locksmith

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem.selectedImage = UIImage.init(named: "ProfilIconSelected")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.tabBarItem.image = UIImage.init(named: "ProfilIcon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logout(sender: AnyObject) {
        FBSDKLoginManager().logOut()
        if let _ = Locksmith.loadDataForUserAccount("access_token") {
            do {
                try Locksmith.deleteDataForUserAccount("access_token")
                try Locksmith.deleteDataForUserAccount("email")
            } catch _ {
                print("Error delete access token from keychain")
            }
        }
        self.view.window?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

}

