//
//  ChatViewController.swift
//  Cluztr
//
//  Created by Franck LAPEYRE on 07/10/2015.
//  Copyright © 2015 Cluztr. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem.selectedImage = UIImage.init(named: "ChatIconSelected")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.tabBarItem.image = UIImage.init(named: "ChatIcon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
