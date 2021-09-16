//
//  SKIPVC.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 02/07/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import SQLite3

class SKIPVC: BASEACTIVITY {

    @IBOutlet var reasonspnr: DropDown!
    @IBOutlet weak var skipName: UITextField!
    @IBOutlet weak var skipNote: UITextView!
    var rcodearr = [String]()
    @IBAction func donebtn(_ sender: UIBarButtonItem) {
        if(validate()){
            print(reasonspnr.text!)
            print(skipName.text!)
            print(skipNote.text!)
            let rcode = self.rcodearr[self.reasonspnr.selectedIndex!]
            self.insertnodelreason(ordernum: CUSTORDERVC.custid!, reasoncode: rcode, description: reasonspnr.text!, note: skipNote.text!, date: "", skipcancelname : skipName.text!,type: NoDelReason.skip.rawValue)
            self.updatelastactivity(activityid: NoDelReason.skip.rawValue, ordernum: CUSTORDERVC.custid!)
            self.push(storybId: "RESQUENCING", vcId: "ORDERDELNC", vc: self)
           
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setnav(title: self.navigationItem.title!)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSkipReason()
        reasonspnr.isSearchEnable = false
    }
    
    
    func setSkipReason(){
         reasonspnr.optionArray.removeAll()
        self.rcodearr.removeAll()
        var stmt1:OpaquePointer?
        let query = "SELECT description,skipcode from ReasonMaster where type = 0"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let description = String(cString: sqlite3_column_text(stmt1, 0))
            let rcode = String(cString: sqlite3_column_text(stmt1, 1))
            self.rcodearr.append(rcode)
            reasonspnr.optionArray.append(description)
        }
    }

    func validate() -> Bool {
        if(reasonspnr.text == ""){
            self.showToast(message: "Please Select Skip Reason")
            return false
        }
       else if(skipName.text == ""){
            self.showToast(message: "Please Enter Valid Name")
            return false
        }
        return true
        
    }
    
    func setSkipReasonIdfromName(){
        
        var stmt1:OpaquePointer?
        let query = "SELECT id from ReasonMaster where description = \(reasonspnr.text!)"
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let skipReasonid = String(cString: sqlite3_column_text(stmt1, 0))
            print(skipReasonid)
        }
    }
}
