//
//  PRESTARTCHECKLIST.swift
//  Ripple CSR
//
//  Created by Acxiom Consulting on 06/06/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import MaterialComponents
import SQLite3
import SwiftEventBus

class PRESTARTCHECKLIST: BASEACTIVITY,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prethirdadapter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "prethirdcell", for: indexPath) as! PreStartCheckList_third
        
        let list: PRETHIRDADAPTER
        list = prethirdadapter[indexPath.row]
        
        cell.desclbl.text = list.desclbl

        cell.noteedt.text = list.edittext
        cell.index = list.uid
        cell.indexpath = indexPath
        
        tableView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        return cell
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        print("cell off display - \(indexPath.row)")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "prethirdcell", for: indexPath) as! PreStartCheckList_third
        
        let list: PRETHIRDADAPTER
        list = prethirdadapter[indexPath.row]
        if cell.noteedt.text!.count > 0 {
        list.edittext = cell.noteedt.text!
        }else{
        list.edittext = ""
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("cell will display - \(indexPath.row)")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "prethirdcell", for: indexPath) as! PreStartCheckList_third
             
             let list: PRETHIRDADAPTER
             list = prethirdadapter[indexPath.row]
        
        cell.noteedt.text = list.edittext
    }
    
    var prethirdadapter = [PRETHIRDADAPTER]()
    
    @IBOutlet var userlbl: UILabel!
    @IBOutlet var datelbl: UILabel!

    @IBOutlet var innerviwe: UIView!
    @IBOutlet var prethirdtable: UITableView!
    @IBOutlet var pincodeedt: MDCTextField!
    
    @IBOutlet var donebtn: UIBarButtonItem!
    
   var pincodecontroller: MDCTextInputControllerOutlined?
    
    override func viewDidLoad() {

        self.prethirdtable.delegate = self
        self.prethirdtable.dataSource = self
        if (UserDefaults.standard.string(forKey: "uname") != nil && UserDefaults.standard.string(forKey: "uname")! != ""){
            self.userlbl.text = UserDefaults.standard.string(forKey: "uname")!
        }else{
            self.userlbl.text = UserDefaults.standard.string(forKey: "userid")
        }
        datelbl.text = self.getdate(format: "dd/MM/yy")
        initdata()
        SwiftEventBus.onMainThread(self, name: "cdone") { (result) in
            print("\n*** cdone called 3 ***\n")
//            self.push(storybId: "RUNSUMMARY", vcId: "RUNSUMMARYNC", vc: self)
            self.getcondition(type: "2")
               UserDefaults.standard.set(self.getdate(format: "yyyy-MM-dd"), forKey: "predate")
        }
        SwiftEventBus.onMainThread(self, name: "cnot") { (result) in
            self.showToast(message: "Error in API")
            self.hideindicator()
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.donebtn.isEnabled = true
        }
        SwiftEventBus.onMainThread(self, name: "cerr") { (result) in
            self.showToast(message: "Server not reachable")
            self.hideindicator()
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.donebtn.isEnabled = true
        }
        SwiftEventBus.onMainThread(self, name: "gotcom") { (result) in
            print("\n*** goto compliance called ***\n")
            self.hideindicator()
            self.view.isUserInteractionEnabled = true
            self.push(storybId: "COMPLIANCE", vcId: "COMPLIANCENC", vc: self)
            UserDefaults.standard.set(self.getdate(format: "yyyy-MM-dd"), forKey: "predate")
        }
        
        SwiftEventBus.onMainThread(self, name: "notcom") { (result) in
            self.hideindicator()
            self.view.isUserInteractionEnabled = true
            self.showToast(message: "Error in API")
        }
        
        SwiftEventBus.onMainThread(self, name: "cskip") { (result) in
            self.hideindicator()
            self.push(storybId: "TRUCKLOAD", vcId: "TRUCKLOADFIRSTNC", vc: self)
           UserDefaults.standard.set(self.getdate(format: "yyyy-MM-dd"), forKey: "comdate")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        SwiftEventBus.unregister(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.innerviwe.backgroundColor = UIColor.clear
        self.setbg()
        pincodecontroller = MDCTextInputControllerOutlined(textInput: pincodeedt)
        pincodeedt.sizeToFit()
        pincodecontroller?.setfordark(field: pincodeedt, controller: self)
        
        self.setnav(title: self.navigationItem.title!)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // Trait collection has already changed
        pincodecontroller?.setfordark(field: pincodeedt, controller: self)
    }
    
    func initdata(){
        var stmt1:OpaquePointer?
                
        let query = "select uid,description,ifnull(remarks,'') as remarks from prestartchecklist where toogle = 'false'"
                
        prethirdadapter.removeAll()
                
        if sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
        let uid = String(cString: sqlite3_column_text(stmt1, 0))
            let desc = String(cString: sqlite3_column_text(stmt1, 1))
            let edt = String(cString: sqlite3_column_text(stmt1, 2))
            prethirdadapter.append(PRETHIRDADAPTER(uid: uid, description: desc, edttxt: edt))
        }
        self.prethirdtable.reloadData()
    }
    
    override func callback() {
        self.postcondition(type: "1")
    }
    override func failcall() {
        self.view.isUserInteractionEnabled = true
        self.showToast(message: "Authentication failed!!!")
        self.hideindicator()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        SwiftEventBus.unregister(self)
    }
    @IBAction func donebtn(_ sender: Any) {
        
        var stmt1:OpaquePointer?
                
        let query = "select remarks from prestartchecklist where toogle = 'false' and remarks = ''"
                
        if sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        let pin = UserDefaults.standard.string(forKey: "pincode")!
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            self.showToast(message: "Resolution Note to be Filled for all Entries")
        }else if ((self.pincodeedt.text?.count) == 0){
            self.showToast(message: "Pincode is Mandatory")
        }else if (self.pincodeedt.text! != pin){
            self.showToast(message: "Pincode is Incorrect")
        }else{
            if (AppDelegate.ntwrk > 0){
                self.donebtn.isEnabled = false
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                self.showIndicator("Loading...", vc: self)
                self.gettoken()
            }else{
                self.showToast(message: "Internet connection required to continue...")
            }  
            
        }
    }
    
}
