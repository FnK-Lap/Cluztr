//
//  StringExtension.swift
//  Cluztr
//
//  Created by Franck LAPEYRE on 03/12/2015.
//  Copyright © 2015 Cluztr. All rights reserved.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluateWithObject(self)
    }
}