//
//  PassThroughView.swift
//  Ripple CSR
//
//  Created by Acxiom Consulting on 12/06/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit

class PassThroughView: UIView {

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if !subview.isHidden && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
    
}
