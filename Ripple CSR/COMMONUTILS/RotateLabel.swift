//
//  RotateLabel.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 01/07/20.
//  Copyright © 2020 hannan parvez. All rights reserved.
//

import UIKit

extension UILabel {
    @IBInspectable
    var rotation: Int {
        get {
            return 0
        } set {
            let radians = CGFloat(CGFloat(Double.pi) * CGFloat(newValue) / CGFloat(180.0))
            self.transform = CGAffineTransform(rotationAngle: radians)
        }
    }
}
