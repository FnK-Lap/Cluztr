//
//  HttpHelper.swift
//  Cluztr
//
//  Created by Maxime Dumont on 16/10/15.
//  Copyright © 2015 Cluztr. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class HttpHelper: UIViewController {
    var responseData: JSON?
    var status: Int?
    var errors: String?
    var message: String?
    
    func request(request : URLRequestConvertible, fromController controller: UIViewController, success: JSON -> Void, errors: JSON -> Void ) -> Void {
        Alamofire.request(request).responseJSON { response in
            if let data = response.result.value {
                let json = JSON(data)
                if json["status"] == 200 || json["status"] == 201 {
                    success(json)
                } else {
                    errors(json)
                }
            } else {
                let alertController = UIAlertController(title: "Error Network", message: "Vous n'avez pas de connection internet.", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OKAY", style: UIAlertActionStyle.Default, handler: nil ))
                
                controller.presentViewController(alertController, animated: true, completion: nil)
                errors(nil)
            }
        }
    }
}