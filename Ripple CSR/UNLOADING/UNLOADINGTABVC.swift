//
//  UNLOADINGTABVC.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 17/06/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import Foundation
import UIKit

class UNLOADINFGTABVC : UITabBarController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.viewControllers![1].beginAppearanceTransition(true, animated: true)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "ArialHebrew", size: 12)!], for: .normal)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "ArialHebrew", size: 12)!], for: .selected)
    }
    
}
