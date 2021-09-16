//
//  COMPLIANCEVC.swift
//  Ripple CSR
//
//  Created by Acxiom Consulting on 10/06/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import SQLite3
import SwiftEventBus

class COMPLIANCEVC: BASEACTIVITY,UITableViewDelegate,UITableViewDataSource,ToogleBtnClicked {
    
    func ToogleTapped(at index: IndexPath) {
            setlist()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return complianceadapter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ccell", for: indexPath) as! complianceCELL
        
        let list: PREFIRSTADAPTER
        list = complianceadapter[indexPath.row]
        
        cell.title.text = list.desclabel
        cell.tooglebtn.isOn = list.toogele
        cell.delegate = self
        cell.indexPath = indexPath
        cell.info = list.info
        cell.uid = list.uid
        
        tableView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    var complianceadapter = [PREFIRSTADAPTER]()
    var i = 0
    
    @IBOutlet var datelbl: UILabel!
    @IBOutlet var ctable: UITableView!
    public var datePicker: UIDatePicker?
    
    @IBOutlet var userlbl: UILabel!
    @IBOutlet var starttime: UITextField!
    var tablecreate = [PrestartTableAdapter]()

    override func viewWillAppear(_ animated: Bool) {
        self.setbg()
        self.setnav(title: "Compliance Passport")
        
    }
    
    override func pingot() {
        self.buttonPressed()
    }
    
    override func pinnot(){
            self.hideindicator()
            self.view.isUserInteractionEnabled = true
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.showToast(message: "Pin code generation failed due to API error")
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = getbarbutton()
        if (UserDefaults.standard.string(forKey: "uname") != nil && UserDefaults.standard.string(forKey: "uname")! != ""){
            self.userlbl.text = UserDefaults.standard.string(forKey: "uname")!
        }else{
            self.userlbl.text = UserDefaults.standard.string(forKey: "userid")
        }
        self.datelbl.text = self.getdate(format: "dd/MM/yy")
        self.ctable.delegate = self
        self.ctable.dataSource = self
        setlist()
        self.starttime.text = self.getdate(format: "HH:mm:ss")
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm"

        let max = dateFormatter.date(from: self.getdate(format: "HH:mm"))
        datePicker?.maximumDate = max
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        starttime.inputAccessoryView = toolbar
        starttime.inputView = datePicker
        
        SwiftEventBus.onMainThread(self, name: "cdone") { (result) in
            self.hideindicator()
            self.push(storybId: "TRUCKLOAD", vcId: "TRUCKLOADFIRSTNC", vc: self)
           UserDefaults.standard.set(self.getdate(format: "yyyy-MM-dd"), forKey: "comdate")
        }
        SwiftEventBus.onMainThread(self, name: "cnot") { (result) in
            self.hideindicator()
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.showToast(message: "Error in API")
        }
        SwiftEventBus.onMainThread(self, name: "cerr") { (result) in
            self.hideindicator()
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.showToast(message: "Server not reachable")
        }
    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        starttime.text = formatter.string(from: self.datePicker!.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    override func callback() {
        if (i == 1){
            self.getpincode()
        }else if (i == 2){
        self.postcondition(type: "2")
        }
    }
    func setlist(){
            
            var stmt1:OpaquePointer?
            
            let query = "Select * from Compliance order by uid"
            
            complianceadapter.removeAll()
            
            if sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                print("error preparing get: \(errmsg)")
                return
            }
            while(sqlite3_step(stmt1) == SQLITE_ROW){
                
                let description = String(cString: sqlite3_column_text(stmt1, 2))
                   let info = String(cString: sqlite3_column_text(stmt1, 3))
                   let toogle = String(cString: sqlite3_column_text(stmt1, 4))
                let uid = String(cString: sqlite3_column_text(stmt1, 0))
                
                complianceadapter.append(PREFIRSTADAPTER(description: description, toogle: Bool(toogle)!, info: info,uid : uid))
            }
            self.ctable.reloadData()
        }
    
    override func buttonPressed() {
      var stmt1:OpaquePointer?
    
        savestarttime(starttime: self.starttime.text!)
        let query = "select * from Compliance where toogle = 'false'"
                                
        if sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
        let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
        print("error preparing get: \(errmsg)")
           return
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            if (AppDelegate.ntwrk > 0){
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                self.showIndicator("Loading...", vc: self)
            if (UserDefaults.standard.string(forKey: "pincode") == nil || UserDefaults.standard.string(forKey: "pincode")! == ""){
                self.i = 1
                self.gettoken()
                
            }else{
                self.hideindicator()
                self.view.isUserInteractionEnabled = true
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.push(storybId: "COMPLIANCE", vcId: "COMPLIANCEthirdNC", vc: self)
            }
            }else{
                self.showToast(message: "Internet connection required to continue...")
            }
        }else{
            if (AppDelegate.ntwrk > 0){
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                self.showIndicator("Loading...", vc: self)
                if (UserDefaults.standard.string(forKey: "pincode") == nil || UserDefaults.standard.string(forKey: "pincode")! == ""){
                    self.i = 1
                }else{
                    self.i = 2
                }
                self.gettoken()
            }else{
                self.showToast(message: "Internet connection required to continue...")
            }
        }
    }
    
    override func failcall() {
        self.view.isUserInteractionEnabled = false
        self.showToast(message: "Authentication failed!!!")
        self.hideindicator()
    }
    
   
}
