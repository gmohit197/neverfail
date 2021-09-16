//
//  CANCELORDERVC.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 02/07/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import SQLite3

class CANCELORDERVC: BASEACTIVITY {

    @IBOutlet var canceldate: UITextField!
    @IBOutlet var nextdate: UILabel!
    @IBOutlet var cancelreason: DropDown!
    @IBOutlet weak var cName: UITextField!
    
    var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setCancelDatePicker()
        setCancelReason()
        cancelreason.isSearchEnable = false
    }
    
    func setCancelDatePicker(){
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "dd-MMM-yyyy"

        let max = dateFormatter.date(from: self.getdate(format: "dd-MMM-yyyy"))
        datePicker?.minimumDate = max
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        canceldate.inputAccessoryView = toolbar
        canceldate.inputView = datePicker

    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        canceldate.text = formatter.string(from: self.datePicker!.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    @IBAction func donebtn(_ sender: UIBarButtonItem) {
        if(validate()){
            print(cancelreason.text!)
            print(cName.text!)
            print(canceldate.text!)
            let date  = self.convertDateFormater(date: self.canceldate.text!, input: "dd-MMM-yyyy", output: "yyyy-MM-dd")
            let rcode = self.rcodearr[self.cancelreason.selectedIndex!]
            self.insertnodelreason(ordernum: CUSTORDERVC.custid!, reasoncode: rcode, description: cancelreason.text!, note: "", date: date, skipcancelname : cName.text!, type: NoDelReason.cancelOrder.rawValue)
            self.navigationController?.popViewController(animated: true)
            self.showmsg(msg: "Cancellation details saved")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setnav(title: self.navigationItem.title!)
        self.setnextdate()
    }
    
    func setnextdate(){
        var stmt1:OpaquePointer?
        let query = "SELECT nextdeldate from custorderheader where custordernum = '\(CUSTORDERVC.custid!)'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            let nextdate = String(cString: sqlite3_column_text(stmt1, 0))
            self.nextdate.text = nextdate
        }
    }
    var rcodearr = [String]()
    func setCancelReason(){
        cancelreason.optionArray.removeAll()
        self.rcodearr.removeAll()
        var stmt1:OpaquePointer?
        let query = "SELECT description,skipcode from ReasonMaster where type = 1"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let description = String(cString: sqlite3_column_text(stmt1, 0))
            let rcode = String(cString: sqlite3_column_text(stmt1, 1))
            self.rcodearr.append(rcode)
            cancelreason.optionArray.append(description)
        }
    }
    
    func validate() -> Bool {
        if(cName.text == ""){
            self.showToast(message: "Please Enter Valid Name")
            return false
        }
        else if(canceldate.text == ""){
            self.showToast(message: "Please Enter Valid Date")
            return false
        }
        else if(cancelreason.text == ""){
            self.showToast(message: "Please Select Cancel Reason")
            return false
        }
        return true
    }
}
