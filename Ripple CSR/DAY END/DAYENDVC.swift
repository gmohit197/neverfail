//
//  DAYENDVC.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 11/09/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import SwiftEventBus

class DAYENDVC: BASEACTIVITY {
    
    override func viewWillAppear(_ animated: Bool) {
        self.setnav(title: self.navigationItem.title!)
    }
    
    var is_sync = false
    var txtField: UITextField!
    @IBOutlet var synccard: CardView!
    @IBOutlet var trancard: CardView!
    @IBOutlet var endcard: CardView!
    @IBOutlet var endview: UIView!
    var datePicker: UIDatePicker?
    
    @IBOutlet var odometer: UITextField!
    @IBAction func submitbtn(_ sender: UIButton) {
        self.doend()
    }
    
    override func sumcallback() {
        self.getsummaryreport(drid: UserDefaults.standard.string(forKey: "userid")!, date: self.date)
    }
    
    override func crmcallback() {
        self.postlead(token: self.accessToken)
    }
    override func lead() {
        self.postleadnote()
    }
    
    override func failcall() {
        self.hideindicator()
        self.showToast(message: "Authentication Failure")
    }
    
    override func note() {
        if (CONSTANT.leadname.count > 0 || CONSTANT.notename.count > 0){
            self.hideindicator()
            self.showToast(message: "Data sync failed - Lead not uploaded successfully")
            //            self.call = 1
            //            self.gettoken()
        }else{
            self.call = 1
            self.gettoken()
        }
    }
    override func callback() {
        CONSTANT.apicall = 0
        CONSTANT.failapi = 0
        AppDelegate.loaderr = ""
        AppDelegate.ordererr = ""
        
        if (call == 1){
            self.postnewcust()
        }else if (call == 2){
            self.postcustorder()
        }else if (call == 3){
            self.poststartbreak()
        }else if (call == 4){
            if (self.is_sync){
                self.hideindicator()
                self.showToast(message: "Sync check completed")
            }else{
              self.postendmyday(odometer: self.odometer.text!)
            }
        }
    }
    
    @IBOutlet var datecard: CardView!
    var call = 0
    var date = ""
    
    override func cust(){
        if (CONSTANT.custname.count > 0){
            self.hideindicator()
            self.showToast(message: "Data sync failed - Customer creation failed")
            //            self.call = 2
            //            self.gettoken()
        }else{
            self.call = 2
            self.gettoken()
        }
    }
    
    override func sbgot() {
        self.postendbreak()
    }
    
    override func sbnot() {
        self.hideindicator()
        self.showToast(message: "Data sync failed - Start break not posted.")
    }
    
    override func ebgot() {
        self.call = 4
        self.gettoken()
    }
    
    override func ebnot() {
        self.hideindicator()
        self.showToast(message: "Data sync failed - End break not posted.")
    }
    
    override func ordererr() {
        self.hideindicator()
    }
    
    override func ordernot() {
        self.hideindicator()
    }
    
    override func orderdone() {
        self.call = 3
        self.gettoken()
    }    
    
    func doend(){
        let alert = UIAlertController(title: "Alert", message: "Do you want to End your Day? You will be logged out of the Application.", preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "Yes", style: .default) { (result) in
            alert.dismiss(animated: true, completion: nil)
            if (AppDelegate.ntwrk > 0){
                self.is_sync = false
                self.showIndicator("Syncing...", vc: self)
                self.getcrmtoken()
            }else{
                self.showToast(message: "Internet connection required to End Day.")
            }
        }
        let no = UIAlertAction(title: "No", style: .destructive) { (result) in
            self.odometer.text = ""
            self.endview.isHidden = true
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(yes)
        alert.addAction(no)
        
        self.present(alert, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let endtap = UITapGestureRecognizer(target: self, action: #selector(self.endtapped))
        self.endcard.addGestureRecognizer(endtap)
        
        let dismiss = UITapGestureRecognizer(target: self, action: #selector(self.dismissview))
        self.endview.addGestureRecognizer(dismiss)
        
        let syncchck = UITapGestureRecognizer(target: self, action: #selector(self.syncchck))
        self.synccard.addGestureRecognizer(syncchck)
        
        let tr_report = UITapGestureRecognizer(target: self, action: #selector(self.calltrans_st))
        self.trancard.addGestureRecognizer(tr_report)
        self.date = self.getdate(format: "dd-MM-yyyy")
        self.dateview.isHidden = true
        
        let outdate = UITapGestureRecognizer(target: self, action: #selector(self.hideview))
        self.dateview.addGestureRecognizer(outdate)
        self.dateview.isHidden = true
    }
    
    @objc func hideview(){
        self.dateview.isHidden = true
    }
    
    @IBOutlet var rootview: UIView!
    
    @objc func calltrans_st(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "dd-MMM-yyyy"
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker!.center = view.center
        let max = dateFormatter.date(from: self.getdate(format: "dd-MMM-yyyy"))
        datePicker?.maximumDate = max
        
        self.datetxt.inputAccessoryView = toolbar
        self.datetxt.inputView = datePicker
        self.datetxt.text = self.getdate(format: "dd-MMM-yyyy")
        self.dateview.isHidden = false
//        self.datecard.isHidden = false
    }
    
    @IBOutlet var datetxt: UITextField!
    var datelbl = UILabel()
    let beffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    @IBOutlet var dateview: UIView!
    
    @IBAction func datedone(_ sender: UIButton) {
        self.trtapped()
    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        datetxt.text = formatter.string(from: self.datePicker!.date)
        self.date = self.convertDateFormater(date: self.datetxt.text!, input: "dd-MMM-yyyy", output: "dd-MM-yyyy")
        formatter.string(from: self.datePicker!.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }

    override func edone() {
        self.hideindicator()
        self.logout()
    }
    
    override func enot() {
        self.hideindicator()
        self.showToast(message: "Error while uploading Day End")
    }
    
    override func err() {
        self.hideindicator()
        self.showToast(message: "Error in API")
    }
    
    @objc func syncchck(){
        if (AppDelegate.ntwrk > 0){
            self.is_sync = true
            self.showIndicator("Syncing...", vc: self)
            self.getcrmtoken()
        }else{
            self.showToast(message: "Internet connection required to End Day.")
        }
    }
    func trtapped(){
        let alert = UIAlertController(title: "Alert", message: "Are you sure, you want to generate the Transaction Summary?", preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "Yes", style: .default) { (result) in
            self.dateview.isHidden = true
//            self.datecard.isHidden = true
            self.getsummary()
            alert.dismiss(animated: true, completion: nil)
        }
        let no = UIAlertAction(title: "No", style: .destructive) { (result) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(yes)
        alert.addAction(no)
        self.present(alert, animated: true, completion: nil)
    }
    
    func getsummary(){
        if (AppDelegate.ntwrk > 0){
            self.showIndicator("Loading...", vc: self)
            self.getsumtoken()
        }else{
            self.showToast(message: "Internet connection required.")
        }
    }
    
    override func sumdone (){
        self.hideindicator()
        self.showToast(message: "The Transaction Summary has been sent.")
    }
    
    override func sumerr(){
        self.hideindicator()
        self.showToast(message: "The Transaction Summary could not be sent.")
    }
    
    @objc func endtapped(){
        self.endview.isHidden = false
    }
    @objc func dismissview(){
        self.endview.isHidden = true
    }
    
}
