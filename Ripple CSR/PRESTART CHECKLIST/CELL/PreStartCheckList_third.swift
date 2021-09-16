//
//  PreStartCheckList_third.swift
//  Ripple CSR
//
//  Created by Acxiom Consulting on 09/06/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import MaterialComponents
import SQLite3

class PreStartCheckList_third: UITableViewCell,UITextFieldDelegate {
    
    @IBOutlet var desclbl: UILabel!
    @IBOutlet var noteedt: MDCTextField!
    
    var index: String?
    var indexpath: IndexPath!
    
    @IBOutlet var resedt: MDCTextField!
    
    @IBAction func edtfield(_ sender: UITextField) {
        
        print("resolution intext - \(sender.text!) index - \(index!)")

        let query = "update PreStartChecklist set remarks = '\(sender.text!)' where uid = '\(index!)'"

        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
        print("Error update PreStartChecklist - resulution value")
        return
        }
    }
    
    var noteedtcontroller: MDCTextInputControllerOutlined?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        noteedtcontroller = MDCTextInputControllerOutlined(textInput: noteedt)
        noteedt.sizeToFit()
        noteedtcontroller?.setfordark(field: noteedt, controller: BASEACTIVITY())
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // Trait collection has already changed
                noteedtcontroller?.setfordark(field: noteedt, controller: BASEACTIVITY())
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
