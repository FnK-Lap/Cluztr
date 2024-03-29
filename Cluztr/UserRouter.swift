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
    static let baseURLString = "https://cluztr.herokuapp.com"
    
    case LoginUser([String: AnyObject])
    case GetInvitations()
    case PutInterests([String])
    
    var method: Alamofire.Method {
        switch self {
        case .LoginUser:
            return .POST
        case .GetInvitations:
            return .GET
        case .PutInterests:
            return .PUT
        }
    }
    
    var path: String {
        switch self {
        case .LoginUser:
            return "/login"
        case .GetInvitations:
            return "/api/v1/user/me/invitations"
        case .PutInterests:
            return "/api/v1/user/me/interest"
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
        case .PutInterests(let interests):
            if let token = Locksmith.loadDataForUserAccount("access_token"), let email = Locksmith.loadDataForUserAccount("email") {
                mutableURLRequest.addValue("\(token["access_token"]!)", forHTTPHeaderField: "x-access-token")
                mutableURLRequest.addValue("\(email["email"]!)", forHTTPHeaderField: "x-key")
            }
            
            let parameters = ["interests": interests]
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        default:
            if let token = Locksmith.loadDataForUserAccount("access_token"), let email = Locksmith.loadDataForUserAccount("email") {
                mutableURLRequest.addValue("\(token["access_token"]!)", forHTTPHeaderField: "x-access-token")
                mutableURLRequest.addValue("\(email["email"]!)", forHTTPHeaderField: "x-key")
            }
            return mutableURLRequest
        }
    }
}