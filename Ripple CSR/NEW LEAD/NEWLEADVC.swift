//
//  NEWLEADVC.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 13/07/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import SwiftEventBus

class NEWLEADVC: BASEACTIVITY,UITextFieldDelegate {

    @IBOutlet var nameedt: UITextField!
    @IBOutlet var phoneedt: UITextField!
    @IBOutlet var emailedt: UITextField!
    @IBOutlet var addressedt: UITextField!
    @IBOutlet var suburbedt: UITextField!
    @IBOutlet var stateedt: UITextField!
    @IBOutlet var postcodeedt: UITextField!
    
    @IBOutlet var jobtitleedt: UITextField!
    @IBOutlet var lastnameedt: UITextField!
    @IBOutlet var company: UITextField!
    @IBOutlet var employeedt: UITextField!
    @IBOutlet var annualrevenueedt: UITextField!
    @IBOutlet var abnedt: UITextField!
    @IBOutlet var sourceinfo: UITextField!
    @IBOutlet var prefcoedt: UITextField!
    @IBOutlet var subjectedt: UITextField!
    @IBOutlet var noteedt: UITextField!
    @IBOutlet var bussphoneedt: UITextField!
    @IBOutlet var scrollview: UIScrollView!
    @IBOutlet var topicedt: UITextField!
    
    var uid = ""
    var noteflag = false
    var api = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uid = self.getdate(format: "yyyy-MM-dd HH:mm:ss.SSS")
        scrollview.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
//        SwiftEventBus.onMainThread(self, name: "lead") { (result) in
//            self.navigationItem.rightBarButtonItem?.isEnabled = true
//            self.hideindicator()
//            self.showToast(message: "Lead not sent.")
//        }
        SwiftEventBus.onMainThread(self, name: "lead") { (result) in
            self.api = 2
            self.getcrmtoken()
        }
//        SwiftEventBus.onMainThread(self, name: "lerr") { (result) in
//            self.navigationItem.rightBarButtonItem?.isEnabled = true
//            self.hideindicator()
//            self.showToast(message: "Server not reachable.")
//        }
        SwiftEventBus.onMainThread(self, name: "note") { (result) in
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.hideindicator()
            if (CONSTANT.leadname.count > 0 || CONSTANT.notename.count > 0){
                var name: String! = ""
                var nname: String! = ""
                name = CONSTANT.leadname[0]
                if (CONSTANT.leadname.count > 1){
                    for i in 1..<CONSTANT.leadname.count {
                        name = name + ", " + CONSTANT.leadname[i]
                    }
                }
                if (CONSTANT.notename.count > 0){
                    nname = CONSTANT.notename[0]
                    if (CONSTANT.leadname.count > 1){
                        for i in 1..<CONSTANT.notename.count {
                            nname = nname + ", " + CONSTANT.notename[i]
                        }
                    }
                    self.noteflag = true
                }
                if (self.noteflag == true){
                    self.showToast(message: "Error while uploading lead(s) - \(name!) and Note for lead(s) - \(nname!)")
                }else{
                    self.showToast(message: "Error while uploading lead(s) - \(name!) ")
                }
            }else{
//                self.showToast(message: "Data successfully sent")
                self.showmsg(msg: "Data successfully sent")
                self.gotohome()
            }
        }
        SwiftEventBus.onMainThread(self, name: "lndone") { (result) in
//            self.showToast(message: "Some data not posted.")
            
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.hideindicator()
            self.gotohome()
        }
        SwiftEventBus.onMainThread(self, name: "lnskip") { (result) in
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.hideindicator()
            self.gotohome()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setnav(title: self.navigationItem.title!)
        
    }
   
    @IBAction func donebtn(_ sender: UIBarButtonItem) {
        
            if (validate()){
                
//                    self.deletetable(tbl: "lead")
                    self.insertlead(topic: self.topicedt.text!, leadid: self.uid, subject: self.subjectedt.text!, firstname: self.nameedt.text!, lastname: self.lastnameedt.text!, mobilephone: self.phoneedt.text!, telephone1: self.bussphoneedt.text!, emailaddress1: self.emailedt.text!, companyname: self.company.text!, address1_line1: self.addressedt.text!, address1_city: self.suburbedt.text!, address1_stateorprovince: self.stateedt.text!, address1_postalcode: self.postcodeedt.text!, revenue: self.annualrevenueedt.text!, numberofemployees: self.employeedt.text!, Jobtitle: self.jobtitleedt.text!, ABN: self.abnedt.text!, sourceinfo: self.sourceinfo.text!, contactmethod: self.prefcoedt.text!,note: self.noteedt.text!)
                if (AppDelegate.ntwrk > 0){
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                    self.view.isUserInteractionEnabled = false
                    self.showIndicator("Syncing...", vc: self)
                    self.api = 1
                    self.getcrmtoken()
            }else{
                self.gotohome()
            }
        }
    }
    
    override func crmcallback() {
        if (self.api == 1){
            self.postlead(token: self.accessToken)
        }else if (self.api == 2){
            self.postleadnote()
        }
        
    }
    override func failcall() {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.view.isUserInteractionEnabled = true
        self.showToast(message: "CRM Authentication failed!!!")
        self.hideindicator()
    }
    
    func validate()-> Bool {
        var flag: Bool = true
        
        if (self.topicedt.text?.count == 0 || self.topicedt.text == " "){
            flag = false
            self.showToast(message: "Topic is mandatory")
        }else if (self.lastnameedt.text?.count == 0 || self.lastnameedt.text == " "){
            flag = false
            self.showToast(message: "Last name is mandatory")
        }
        
        return flag
    }
    
}
