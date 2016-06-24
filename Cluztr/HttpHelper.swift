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

class HttpHelper {
    var responseData: JSON?
    var status: Int?
    var errors: String?
    var message: String?
    
    func request(request : URLRequestConvertible, success: JSON -> Void, errors: JSON -> Void ) -> Void {
        Alamofire.request(request).responseJSON { response in
            if let data = response.result.value {
                let json = JSON(data)
                if json["status"] == 200 || json["status"] == 201 {
                    success(json)
                } else {
                    errors(json)
                }
            } else {
                let data = ["message" : "Vous n'avez pas de connection internet.", "response" : "\(response)"]
                let json = JSON(data)
                errors(json)
            }
        }
    }
}