//
//  additem.swift
//  Ripple CSR
//
//  Created by hannan parvez on 26/02/20.
//  Copyright © 2020 hannan parvez. All rights reserved.
//

import Foundation


class additem{
     var itemprice:String?
     var itemname:String?
     var qty:String?
     var total:String?
     init(itemprice:String,itemname:String,qty:String,total:String) {
         self.itemprice=itemprice
         self.itemname=itemname
         self.qty=qty
         self.total=total
     }
}
