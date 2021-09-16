//
//  RAISECASEADAPTER.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 13/08/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import Foundation

class RAISECASEADAPTER {
    var text: String?
    var date: String?
    var type: String?
    var id: String?
    var info: String?
    var status: String?
    
    init(id: String,text: String,date: String,type: String,info : String,status: String){
        self.text = text
        self.date = date
        self.type = type
        self.id = id
        self.info = info
        self.status = status
    }
}
