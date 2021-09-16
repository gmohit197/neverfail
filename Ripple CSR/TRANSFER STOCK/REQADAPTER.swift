//
//  REQADAPTER.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 23/01/21.
//  Copyright © 2021 aayush shukla. All rights reserved.
//

import Foundation

public class REQADAPTER {
    
    var trucktransferid : String?
    var fromtruck :  String?
    var totruck :  String?
    var driverid: String?
    var status: String?
    
    init(trucktransferid: String, fromtruck: String, totruck : String, driverid :  String, status : String){
        
        self.trucktransferid = trucktransferid
        self.fromtruck  = fromtruck
        self.totruck = totruck
        self.driverid = driverid
        self.status = status
    }
    
}
