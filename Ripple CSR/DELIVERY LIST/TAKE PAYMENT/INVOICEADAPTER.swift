//
//  INVOICEADAPTER.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 10/07/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import Foundation

class INVOICEADAPTER {
    
    var invid: String
    var isselected: Bool
    var desc: String
    
    init(invid: String,isselected: Bool,desc: String){
        self.invid = invid
        self.desc = desc
        self.isselected = isselected
    }
    
}
