//
//  LOCATEASSET.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 28/08/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit

class LOCATEASSET: BASEACTIVITY {

   
    @IBOutlet var custname: UILabel!
    @IBOutlet var custnaumber: UILabel!
    @IBOutlet var custaddress: UILabel!
    @IBOutlet var assetlocation: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        self.setnav(title: self.navigationItem.title!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.assetlocation.text = "1, Suite I, Level 1, 146 Marsden ST., Parramata NSW - 2124"
        self.custaddress.text = "1, Suite I, Level 1, 146 Marsden ST., Parramata NSW - 2124"
        self.custname.text = "Danie Brown"
        self.custnaumber.text = "0123456789"
        self.navigationItem.rightBarButtonItem = self.getbarbutton()
    }
    
    override func buttonPressed() {
        CUSTORDERVC.custid = "201887463"
        CUSTORDERVC.orderdate! = self.getdate(format: "yyyy-MM-dd")
        self.push(storybId: "MANAGEDEL", vcId: "ADDSONC", vc: self)
    }
    
    
}
