//
//  InvitationViewController.swift
//  Cluztr
//
//  Created by Franck LAPEYRE on 02/12/2015.
//  Copyright © 2015 Cluztr. All rights reserved.
//

import UIKit

class InvitationViewController: UIViewController {
    
    @IBOutlet weak var mailInput: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendInvitation(sender: AnyObject) {
        // No email
        if (self.mailInput.text!.isEmpty) {
            let alertController = UIAlertController(title: "Adresse mail manquante", message: "Veuillez entrer une adresse email", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Fermer", style: UIAlertActionStyle.Default, handler: nil ))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            let mail = self.mailInput.text
            // Not valid email
            if !mail!.isValidEmail() {
                let alertController = UIAlertController(title: "Adresse mail invalide", message: "Veuillez entrer une adresse email valide", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Fermer", style: UIAlertActionStyle.Default, handler: nil ))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                // Valid email
                self.saveInvitation(mail!, callback: {
                    // Clear field
                    self.mailInput.text = ""
                    
                    let alertController = UIAlertController(title: "Invitation envoyée", message: "Votre invitation a été envoyée", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Fermer", style: UIAlertActionStyle.Default, handler: nil ))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                })
            }
        }
    }

    @IBAction func backButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func saveInvitation(email: String, callback: () -> Void) {
        let tabBarController = self.tabBarController as! TabBarViewController
        let user = tabBarController.user
        
        HttpHelper().request(GroupRouter.Invite(user!["groupId"], email),
            success: {json in
                callback()
            },
            errors: {error in
                let alertController = UIAlertController(title: "Error Network", message: "\(error["message"])", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OKAY", style: UIAlertActionStyle.Default, handler: nil ))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        )
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
