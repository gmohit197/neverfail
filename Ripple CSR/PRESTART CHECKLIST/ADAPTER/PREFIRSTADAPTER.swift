//
//  PREFIRSTADAPTER.swift
//  Ripple CSR
//
//  Created by Acxiom Consulting on 08/06/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import Foundation


class PREFIRSTADAPTER {
    
    var desclabel: String?
    var toogele: Bool
    var info : String?
    var uid : String?
    
    init(description: String,toogle: Bool,info : String,uid : String){
        self.desclabel = description
        self.toogele = toogle
        self.info = info
        self.uid = uid
    }
}
