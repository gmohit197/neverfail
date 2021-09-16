//
//  RESCHEDULEVC.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 11/07/20.
//  Copyright © 2020. All rights reserved.
//

import UIKit
import SQLite3

class RESCHEDULEVC: BASEACTIVITY {

    @IBOutlet var reasonspnr: DropDown!
    @IBOutlet var date: UITextField!
    
    @IBAction func donebtn(_ sender: Any) {
        
        if(validate()){
            print(reasonspnr.text!)
            print(date.text!)
            let date  = self.convertDateFormater(date: self.date.text!, input: "dd-MMM-yyyy", output: "yyyy-MM-dd")
            let rcode = self.rcodearr[self.reasonspnr.selectedIndex!]
            self.insertnodelreason(ordernum: CUSTORDERVC.custid!, reasoncode: rcode, description: reasonspnr.text!, note: "", date: date,skipcancelname : "", type: NoDelReason.reschedule.rawValue)
            self.updatelastactivity(activityid: NoDelReason.reschedule.rawValue, ordernum: CUSTORDERVC.custid!)
            self.push(storybId: "RESQUENCING", vcId: "ORDERDELNC", vc: self)
        }
    }
    
    var datePicker: UIDatePicker?
    
    override func viewWillAppear(_ animated: Bool) {
        self.setnav(title: self.navigationItem.title!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        date.inputAccessoryView = toolbar
        date.inputView = datePicker
        
        setRescheduleReason()
        reasonspnr.isSearchEnable = false
    }
    @objc func donedatePicker(){
           let formatter = DateFormatter()
           formatter.dateFormat = "dd-MMM-yyyy"
           date.text = formatter.string(from: self.datePicker!.date)
           self.view.endEditing(true)
       }
       
       @objc func cancelDatePicker(){
           self.view.endEditing(true)
       }
    var rcodearr = [String]()
    func setRescheduleReason(){
        reasonspnr.optionArray.removeAll()
        self.rcodearr.removeAll()
        var stmt1:OpaquePointer?
        let query = "SELECT description,reasoncode from RescheduleReason"
        
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
            self.showToast(message: "Please Select Reschedule Reason")
            return false
        }
       else if(date.text == ""){
            self.showToast(message: "Please Enter Valid Date")
            return false
        }
        return true
        
    }
}
