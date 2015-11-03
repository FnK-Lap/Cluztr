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

enum UserRouter: URLRequestConvertible {
    static let baseURLString = "http://localhost:3000"
    static var userEmail: JSON? = nil
    
    case LoginUser([String: AnyObject])
    
    var method: Alamofire.Method {
        switch self {
        case .LoginUser:
            return .POST
        }
    }
    
    var path: String {
        switch self {
        case .LoginUser:
            return "/login"
        }
    }
    
    // MARK: URLRequestConvertible
    
    var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: UserRouter.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        
        switch self {
        case .LoginUser(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        default:
            if let token = Locksmith.loadDataForUserAccount("access_token") {
                mutableURLRequest.addValue("\(token)", forHTTPHeaderField: "x-access-token")
                mutableURLRequest.addValue("\(UserRouter.userEmail)", forHTTPHeaderField: "x-key")
            }
            return mutableURLRequest
        }
    }
}