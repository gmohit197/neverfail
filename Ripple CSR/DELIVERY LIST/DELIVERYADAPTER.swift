//
//  DELIVERYADAPTER.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 20/09/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import Foundation

class DELIVERYADAPTER: Codable{
    
    var name: String?
    var stradd: String?
    var stateadd: String?
    var custid: String?
    var status: String?
    var city: String?
    var lastactivityid: String?
    
    init(custid: String,name: String, stradd: String, stateadd: String, status: String,city: String,lastactivityid: String){
        self.custid = custid
        self.name = name
        self.stradd = stradd
        self.stateadd = stateadd
        self.status = status
        self.city = city
        self.lastactivityid = lastactivityid
    }
}

