//
//  PrestartTableAdapter.swift
//  Ripple CSR
//
//  Created by Acxiom Consulting on 08/06/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import Foundation

class PrestartTableAdapter{
    
    var descriptiontext: String
    var information: String
    var toogle: Bool
    var post: String
    
    init(description: String, info : String, toogle: Bool, post: String){
        self.descriptiontext = description
        self.information = info
        self.toogle = toogle
        self.post = post
    }
}
