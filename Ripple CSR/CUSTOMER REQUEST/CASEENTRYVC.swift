//
//  CASEENTRYVC.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 13/08/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import SwiftEventBus
import SQLite3

class CASEENTRYVC: BASEACTIVITY {

    var uid: String!
    var casetype: String!
    
    @IBOutlet var casetitleedt: UITextField!
    @IBOutlet var casetypelbl: UILabel!
    @IBOutlet var caseinfoedt: UITextView!
    var first = "Case : "
    @IBOutlet var namelbl: UILabel!
    @IBOutlet var addresslbl: UILabel!
    @IBOutlet var numberlbl: UILabel!
    
    @IBAction func donebtn(_ sender: UIBarButtonItem) {
        done()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    self.setnav(title: self.navigationItem.title!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.casetypelbl.text = first + self.casetype
        setdetail()
        
        SwiftEventBus.onMainThread(self, name: "cdone") { (result) in
            self.hideindicator()
            self.push(storybId: "CUSTREQ", vcId: "SCNC", vc: self)
            self.showmsg(msg: "Case created successfully")
        }
        SwiftEventBus.onMainThread(self, name: "cnot") { (result) in
            self.hideindicator()
            self.showToast(message: "Unable to raise case")
        }
        SwiftEventBus.onMainThread(self, name: "cperr") { (result) in
            self.hideindicator()
            self.showToast(message: "Error in API")
        }
     
    }
    
    func setdetail(){
        var stmt1:OpaquePointer?
//        custid , name ,city ,state ,street
        let query = "select custid , name ,ifnull(city,'-') ,ifnull(state,'-') ,ifnull(street,'-') from custsrch where custid = '\(CUSTORDERVC.custid!)'"

        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
        let name = String(cString: sqlite3_column_text(stmt1, 1))
        let state = String(cString: sqlite3_column_text(stmt1, 3))
            let street = String(cString: sqlite3_column_text(stmt1, 4))
            let city = String(cString: sqlite3_column_text(stmt1, 2))
            
            self.namelbl.text = name
            self.addresslbl.text = "\(street), \(city), \(state)"
            self.numberlbl.text = CUSTORDERVC.custid!
        }
    }
    
    func done (){
        if (self.casetitleedt.text == ""){
            self.showToast(message: "Provide Case title")
        }else{
            //insert into table
            if (AppDelegate.ntwrk > 0){
                updatecasetable(caseid : self.uid, title : self.casetitleedt.text!, descp : self.caseinfoedt.text)
                self.showIndicator("Loading...", vc: self)
                self.getcrmtoken()
            }else {
                self.showToast(message: "Internet connection required")
            }
            
        }
        
    }
    
    override func crmcallback() {
        self.postcase()
    }
    override func failcall() {
        self.hideindicator()
        self.showToast(message: "Authentication Failure...")
    }
}
