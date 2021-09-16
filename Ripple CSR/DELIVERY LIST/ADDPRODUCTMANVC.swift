//
//  ADDPRODUCTMANVC.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 29/06/20.
//  Copyright © 2020 hannan parvez. All rights reserved.
//

import UIKit

class ADDPRODUCTMANVC: BASEACTIVITY {

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let storyboard = UIStoryboard(name: "UNLOADING", bundle: nil)
        let registrationVC = storyboard.instantiateViewController(withIdentifier: "ADDPRODUCTVC") as! SELECTCATEGORY
        registrationVC.navigationItem.title = "Product"
        self.navigationController?.pushViewController(registrationVC, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.selectedIndex = 0
    }
}
