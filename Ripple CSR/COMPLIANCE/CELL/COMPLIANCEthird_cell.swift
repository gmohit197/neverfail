//
//  COMPLIANCEthird_cell.swift
//  Ripple CSR
//
//  Created by Acxiom Consulting on 11/06/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import MaterialComponents
import SQLite3

class COMPLIANCEthird_cell: UITableViewCell {

    @IBOutlet var resolutionnote: MDCTextField!
    @IBOutlet var desclbl: UILabel!
    var index: String?
    var indexpath: IndexPath!
    var resolutioncontroller: MDCTextInputControllerOutlined!
    
    @IBAction func resolutionedt(_ sender: UITextField) {
    
        print("resolution intext - \(sender.text!) index - \(index!)")
          let query = "update Compliance set remarks = '\(sender.text!)' where uid = '\(index!)'"

        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
          print("Error update Compliance - resulution value")
          return
        }
    
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        resolutioncontroller = MDCTextInputControllerOutlined(textInput: resolutionnote)
        resolutionnote.sizeToFit()
        resolutioncontroller.setfordark(field: resolutionnote, controller: BASEACTIVITY())
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // Trait collection has already changed
             resolutioncontroller.setfordark(field: resolutionnote, controller: BASEACTIVITY())
   }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
