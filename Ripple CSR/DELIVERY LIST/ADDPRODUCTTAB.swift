//
//  ADDPRODUCTTAB.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 29/06/20.
//  Copyright © 2020 hannan parvez. All rights reserved.
//

import Foundation
import UIKit

class ADDPRODUCTTAB : UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllers![0].beginAppearanceTransition(true, animated: true)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "ArialHebrew", size: 12)!], for: .normal)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "ArialHebrew", size: 12)!], for: .selected)
        
    }
    
}
