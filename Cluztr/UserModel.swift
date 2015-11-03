//
//  UserModel.swift
//  Cluztr
//
//  Created by Franck LAPEYRE on 06/10/2015.
//  Copyright © 2015 Cluztr. All rights reserved.
//

import Foundation
import Locksmith

class UserModel {
    
    func loginUser(token: JSON, email: JSON) -> Void {
        do {
            let tokenStr = token["token"]
            try Locksmith.updateData(["access_token": "\(tokenStr)"], forUserAccount: "access_token")
            try Locksmith.updateData(["email": "\(email)"], forUserAccount: "email")
        } catch _ {
            print("Error on save access token in keychain")
        }
    }
}