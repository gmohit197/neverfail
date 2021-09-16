//
//  NCRESCONVC.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 07/11/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import SwiftEventBus
import SQLite3

class NCRESCONVC: BASEACTIVITY {

    @IBOutlet var confname : UITextField!
    @IBOutlet var conlname : UITextField!
    @IBOutlet var conphn : UITextField!
    @IBOutlet var conemail : UITextField!
    
    @IBOutlet var temail: UITextField!
    @IBOutlet var checkbox: UIButton!
    var uid = ""
    var issign: Bool!
    @IBAction func checkbtn(_ sender: UIButton) {
        animatebtn()
    }
    @IBOutlet var signbtn: UIButton!
    @IBOutlet var tname: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        checkbox.setImage(UIImage(named:"unselected"), for: .normal)
        checkbox.setImage(UIImage(named:"selected"), for: .selected)
        SwiftEventBus.onMainThread(self, name: "cusdone") { (result) in
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.hideindicator()
            self.gotohome()
            self.showmsg(msg: "Residential Customer created")
        }
        SwiftEventBus.onMainThread(self, name: "cusnot") { (result) in
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.hideindicator()
            self.showToast(message: "Error in API")
        }
        SwiftEventBus.onMainThread(self, name: "cerr") { (result) in
            self.hideindicator()
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.showToast(message: "Server not reachable")
        }
    }
    
    override func cust() {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.hideindicator()
        if (CONSTANT.custname.count > 0){
            var name: String! = ""
            name = CONSTANT.custname[0]
            if (CONSTANT.custname.count > 1){
                for i in 1..<CONSTANT.custname.count {
                    name = name + ", " + CONSTANT.custname[i]
                }
            }
            if (CONSTANT.IS_DEBUG){
                self.showToast(message: "Error in customers - \(name!) : error - \(CONSTANT.msg)")
            }else{
                self.showToast(message: "Error while uploading customers - \(name!)")
            }
        }else{
//                self.showToast(message: "Data successfully sent")
            self.showmsg(msg: "Residential Customer created")
            self.gotohome()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setnav(title: self.navigationItem.title!)
        setsignbtn()
    }
    func setsignbtn(){
        var stmt1:OpaquePointer?
                
        let query = "select sign from NewCust where uid = '\(self.uid)' and sign <> ''"
                          
                 if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
                     let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                     print("error preparing get: \(errmsg)")
                     return
                 }
                 if(sqlite3_step(stmt1) == SQLITE_ROW){
                    self.signbtn.setBackgroundImage(UIImage(named: "button-done"), for: UIControl.State.normal)
                    issign = true
                 }else{
                    self.signbtn.setBackgroundImage(UIImage(named: "button"), for: UIControl.State.normal)
                    issign = false
                 }
    }
    
    @objc func animatebtn(){
           print("animation started")
           UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
               self.checkbox.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
           
           }) { (success) in
               UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
                   self.checkbox.isSelected = !self.checkbox.isSelected
                   self.checkbox.transform = .identity
               }, completion: nil)
           }
       }
    
    
    func validate() -> Bool {
        
        var flag : Bool = true
        
        if (self.confname.text!.count == 0 || self.confname.text! == " "){
             flag = false
            self.showToast(message: "First name is mandatory")
        }else if (self.conlname.text!.count == 0 || self.conlname.text! == " "){
            flag = false
           self.showToast(message: "Last name is mandatory")
        }else if (self.conphn.text!.count == 0 || self.conphn.text! == " "){
            flag = false
            self.showToast(message: "Phone is mandatory")
        }else if (self.conphn.text!.count > 0 && self.conphn.text!.count < 10){
            flag = false
            self.showToast(message: "Phone is invalid")
       }else if (self.conemail.text!.count == 0 || self.conemail.text! == " "){
            flag = false
            self.showToast(message: "Email is mandatory")
       }else if (!self.isValidEmail(self.conemail.text!)){
            self.showToast(message: "Contact Email is invalid")
            flag = false
       }else if (!self.checkbox.isSelected){
            self.showToast(message: "Accept terms and conditions to continue")
            flag = false
       }else if (self.tname.text!.count == 0 || self.tname.text! == " "){
           self.showToast(message: "Name is mandatory")
           flag = false
       }else if (!issign){
           self.showToast(message: "Signature is mandatory")
           flag = false
       }else if (self.temail.text!.count == 0 || self.temail.text! == " "){
           self.showToast(message: "Email is mandatory")
           flag = false
       }else if (!self.isValidEmail(self.temail.text!)){
           self.showToast(message: "Email to send terms and conditions is invalid")
           flag = false
       }
        return flag
    }
    
    @IBAction func donebtn(_ sender: UIBarButtonItem) {
        if (self.validate()){
                self.updatenewcustdetail(uid: uid, confname: self.confname.text!, conlname: self.conlname.text!, conphone: self.conphn.text!, conemail: self.conemail.text!, acfname: "", aclname: "", acemail: "", acphone: "")
                self.updatecustterms(uid: self.uid, tname: self.tname.text!, temail: self.temail.text!)
            if (AppDelegate.ntwrk > 0){
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                self.view.isUserInteractionEnabled = false
                self.showIndicator("Loading...", vc: self)
                self.gettoken()
            }else{
//                self.showToast(message: "Internet connection required")
                self.gotohome()

            }
        }
    }
    
    @IBAction func signbtn(_ sender: UIButton) {
        let storyb = UIStoryboard(name: "RESQUENCING", bundle: nil)
        let vc = storyb.instantiateViewController(withIdentifier: "SIGNVC") as! SIGNATUREVC
        vc.navigationItem.title = self.navigationItem.title
        vc.uid = self.uid
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func callback() {
        self.postnewcust()
    }
    
    override func failcall() {
        self.view.isUserInteractionEnabled = true
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.showToast(message: "Authentication failed!!!")
        self.hideindicator()
    }
    
}
