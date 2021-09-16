//
//  TRUCKLOADFIRSTVC.swift
//  Ripple CSR
//
//  Created by Acxiom Consulting on 11/06/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit

class TRUCKLOADFIRSTVC: BASEACTIVITY {

    override func viewWillAppear(_ animated: Bool) {
        self.setbg()
        self.setnav(title: "Truck Load")

    }
    var window : UIWindow?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    @IBAction func yesbtn(_ sender: Any) {
        self.push(storybId: "TRUCKLOAD", vcId: "TRUCKLOADNC", vc: self)
    }
    @IBAction func nobtn(_ sender: Any) {
//        self.push(storybId: "RESQUENCING", vcId: "RESQUENCINGNC", vc: self)
        UserDefaults.standard.set(self.getdate(format: "yyyy-MM-dd"), forKey: "trkdate")
        self.gotohome()
    }
    
}
