//
//  SERIALADAPTER.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 07/01/21.
//  Copyright © 2021 aayush shukla. All rights reserved.
//

import Foundation

public class SERIALBATCHADAPTER {
    var lotid: String?
    var label: String?
    var qty: String?
    
    init(lotid: String,label: String,qty: String){
        self.lotid = lotid
        self.label = label
        self.qty = qty
    }
}
