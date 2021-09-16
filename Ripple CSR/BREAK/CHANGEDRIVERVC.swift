//
//  CHANGEDRIVERVC.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 10/09/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit

class CHANGEDRIVERVC: BASEACTIVITY {

    @IBAction func donebtn(_ sender: UIBarButtonItem) {
        self.gotohome()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setnav(title: self.navigationItem.title!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
}
