//
//  SelectGroupViewController.swift
//  Cluztr
//
//  Created by Franck LAPEYRE on 03/11/2015.
//  Copyright © 2015 Cluztr. All rights reserved.
//

import UIKit

class SelectGroupViewController: UIViewController {
    
    @IBOutlet weak var createGroupButton: UIButton!
    @IBOutlet weak var joinGroupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false);
    }
    
    func initUI() {
        // Add border to button
        self.createGroupButton.layer.cornerRadius = 4;
        self.createGroupButton.layer.borderWidth = 1;
        self.createGroupButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.joinGroupButton.layer.cornerRadius = 4;
        self.joinGroupButton.layer.borderWidth = 1;
        self.joinGroupButton.layer.borderColor = UIColor.whiteColor().CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createGroupButton(sender: AnyObject) {
        self.performSegueWithIdentifier("InterestSegue", sender: nil)
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
