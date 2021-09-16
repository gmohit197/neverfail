//
//  TRANSACTIONVC.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 16/09/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit

class TRANSACTIONVC: BASEACTIVITY {

    
    override func viewWillAppear(_ animated: Bool) {
                   self.setnav(title: self.navigationItem.title!)
       }
    @IBAction func donebtn(_ sender: UIBarButtonItem) {
           self.gotohome()
       }
    @IBOutlet var fromdate: UITextField!
    
    @IBOutlet var trantbl: UITableView!
    var datePicker: UIDatePicker?
       
       override func viewDidLoad() {
           super.viewDidLoad()

           datePicker = UIDatePicker()
            datePicker?.datePickerMode = .date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat =  "dd-MMM-yyyy"
        
        let max = dateFormatter.date(from: self.getdate(format: "dd-MMM-yyyy"))
        datePicker?.maximumDate = max
        
            let toolbar = UIToolbar();
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

            toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
            
            fromdate.inputAccessoryView = toolbar
            fromdate.inputView = datePicker
            
        self.fromdate.text = self.getdate(format: "dd-MMM-yyyy")
       }
    
    @IBAction func search(_ sender: UIButton) {
        self.showToast(message: "under construction")
    }
    
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        fromdate.text = formatter.string(from: self.datePicker!.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    

}
