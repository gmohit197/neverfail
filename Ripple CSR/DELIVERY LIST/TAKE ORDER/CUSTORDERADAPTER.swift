//
//  CUSTORDERADAPTER.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 25/06/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import Foundation

class CUSTORDERADAPTER {
    
    var proddesc : String?
    var qty : String?
    var price : String?
    var date: String?
    var itemch: String?
    var itemdis: String?
    var itemid: String?
    
    init(proddesc: String, qty: String, price: String,date: String,itemch: String, itemdis: String,itemid : String) {
        self.proddesc = proddesc
        self.qty = qty
        self.price = price
        self.date = date
        self.itemch = itemch
        self.itemdis = itemdis
        self.itemid = itemid
    }
}
