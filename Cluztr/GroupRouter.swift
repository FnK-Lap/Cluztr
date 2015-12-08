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
    case GetGroup(JSON)
    case Invite(JSON, String)
    case Join(String)
    case GetChats(JSON)
    
    var method: Alamofire.Method {
        switch self {
        case .CreateGroup:
            return .POST
        case .GetGroup:
            return .GET
        case .Invite:
            return .POST
        case .Join:
            return .POST
        case .GetChats:
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .CreateGroup:
            return "/groups"
        case .GetGroup(let id):
            return "/group/\(id)"
        case .Invite(let id, _):
            return "/group/\(id)/invite"
        case .Join(let id):
            return "/group/\(id)/join"
        case .GetChats(let id):
            return "/group/\(id)/chats"
        }
    }
    
    // MARK: URLRequestConvertible
    
    var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: GroupRouter.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        
        switch self {
        case .Invite(_, let email):
            if let token = Locksmith.loadDataForUserAccount("access_token"), let email = Locksmith.loadDataForUserAccount("email") {
                mutableURLRequest.addValue("\(token["access_token"]!)", forHTTPHeaderField: "x-access-token")
                mutableURLRequest.addValue("\(email["email"]!)", forHTTPHeaderField: "x-key")
            }

            let parameters = ["email": email]
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