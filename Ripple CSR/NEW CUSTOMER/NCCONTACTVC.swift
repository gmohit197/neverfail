//
//  NCCONTACTVC.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 20/07/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit

class NCCONTACTVC: BASEACTIVITY {

    @IBOutlet var fname: UITextField!
    
    @IBOutlet var conemail: UITextField!
    @IBOutlet var conphn: UITextField!
    @IBOutlet var lname: UITextField!
    
    @IBOutlet var acfname: UITextField!
    @IBOutlet var aclname: UITextField!
    @IBOutlet var acphn: UITextField!
    
    @IBOutlet var acemail: UITextField!
    
    var uid = ""
    
    override func viewWillAppear(_ animated: Bool) {
        self.setnav(title: self.navigationItem.title!)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func validate() -> Bool {
        
        var flag : Bool = true
        
        if (self.fname.text!.count == 0 || self.fname.text! == " "){
             flag = false
            self.showToast(message: "First name is mandatory")
        }else if (self.lname.text!.count == 0 || self.lname.text! == " "){
            flag = false
           self.showToast(message: "Lasr name is mandatory")
        }else if (self.conphn.text!.count == 0 || self.conphn.text! == " "){
            flag = false
            self.showToast(message: "Phone is mandatory")
        }else if (self.conemail.text!.count == 0 || self.conemail.text! == " "){
            flag = false
            self.showToast(message: "Email is mandatory")
       }else if (!self.isValidEmail(self.conemail.text!)){
            self.showToast(message: "Contact Email is invalid")
            flag = false
       }else if (self.acemail.text!.count > 0 && !self.isValidEmail(self.acemail.text!)){
           self.showToast(message: "Accounts Email is invalid")
           flag = false
       }
        return flag
    }
    
    
    @IBAction func donebtn(_ sender: UIBarButtonItem) {
    
        if (self.validate()){
            if (AppDelegate.ntwrk > 0){
                self.updatenewcustdetail(uid: uid, confname: self.fname.text!, conlname: self.lname.text!, conphone: self.conphn.text!, conemail: self.conemail.text!, acfname: self.acfname.text!, aclname: self.aclname.text!, acemail: self.acemail.text!, acphone: self.acphn.text!)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "NCTVC") as! NCTERMSVC
                vc.uid = self.uid
                self.navigationController?.pushViewController(vc, animated: true)
                
//                self.push(storybId: "NEWCUSTOMER", vcId: "NCCONTNC", vc: self)
            }else{
                self.showToast(message: "Internet connection required")
            }
        }
        
        
    }
}
