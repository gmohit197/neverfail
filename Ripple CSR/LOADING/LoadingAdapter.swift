//
//  LoadingAdapter.swift
//  Ripple CSR
//
//  Created by Acxiom Consulting on 06/06/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import Foundation

public class LoadingAdapter {
   
    var productname: String?
    var qty: String?
    var date: String?
    var price: String?
    
    init(productname: String?, qty: String?,date: String?,price: String?) {
        
        self.productname = productname
        self.qty = qty
        self.date = date
        self.price = price
    }
    
}
