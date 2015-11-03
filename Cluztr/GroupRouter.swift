//
//  UserRouter.swift
//  Cluztr
//
//  Created by Franck LAPEYRE on 06/10/2015.
//  Copyright © 2015 Cluztr. All rights reserved.
//

import Foundation
import Alamofire
import Locksmith

enum GroupRouter: URLRequestConvertible {
    static let baseURLString = "http://localhost:3000/api/v1"
    
    case CreateGroup()
    
    var method: Alamofire.Method {
        switch self {
        case .CreateGroup:
            return .POST
        }
    }
    
    var path: String {
        switch self {
        case .CreateGroup:
            return "/groups"
        }
    }
    
    // MARK: URLRequestConvertible
    
    var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: GroupRouter.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        
        switch self {
        default:
            if let token = Locksmith.loadDataForUserAccount("access_token"), let email = Locksmith.loadDataForUserAccount("email") {
                mutableURLRequest.addValue("\(token["access_token"]!)", forHTTPHeaderField: "x-access-token")
                mutableURLRequest.addValue("\(email["email"]!)", forHTTPHeaderField: "x-key")
            }
            return mutableURLRequest
        }
    }
}