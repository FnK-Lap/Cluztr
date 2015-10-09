//
//  FirstViewController.swift
//  Cluztr
//
//  Created by Franck LAPEYRE on 02/10/2015.
//  Copyright © 2015 Cluztr. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem.selectedImage = UIImage.init(named: "GroupIconSelected")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.tabBarItem.image = UIImage.init(named: "GroupIcon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        
    
        //  any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// 44  0.1725
// 173 0.6784
// 198 0.7764
}

