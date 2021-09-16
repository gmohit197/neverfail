//
//  SWRevealPush.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 13/07/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import Foundation
import UIKit
import SWRevealViewController

extension SWRevealViewController {
    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        var pushingController: Any?

        if frontViewController is UINavigationController {
            if (frontViewController as! UINavigationController).topViewController != viewController {
                pushingController = frontViewController
            }
        }
        else if let navigationController = frontViewController.navigationController {
            pushingController = navigationController
        }
        
        if pushingController != nil && !(viewController is UINavigationController) {
            (pushingController as! UINavigationController).pushViewController(viewController, animated: false)
            revealToggle(animated: animated)
        }
        else {
            pushFrontViewController(viewController, animated: animated)
        }
    }
}
