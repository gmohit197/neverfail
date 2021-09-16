//
//  CardView.swift
//  Khadim
//
//  Created by Acxiom Consulting on 08/01/20.
//  Copyright © 2020 Acxiom Consulting. All rights reserved.
//

import UIKit
import ChameleonFramework
@IBDesignable
class CardView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 5
    
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 3
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: Float = 0.5
    
    override func layoutSubviews() {
     layer.cornerRadius = 8
        layer.shadowColor = HexColor(hexString: "#4E5F6C").cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
      layer.shadowRadius = 5
        layer.shadowOpacity = 0.9
//        layer.cornerRadius = cornerRadius
//        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
//
//        layer.masksToBounds = false
//        layer.shadowColor = shadowColor?.cgColor
//        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
//        layer.shadowOpacity = shadowOpacity
//        layer.shadowPath = shadowPath.cgPath
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
