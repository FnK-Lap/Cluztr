//
//  CALayerExtension.swift
//  Cluztr
//
//  Created by Franck LAPEYRE on 02/12/2015.
//  Copyright © 2015 Cluztr. All rights reserved.
//

import Foundation
import UIKit

extension CALayer {
    func setBorderColorFromUIColor(color:UIColor) {
        self.borderColor = color.CGColor
    }
}