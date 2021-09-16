//
//  SIGNATUREVC.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 01/07/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import SignaturePad

class SIGNATUREVC: BASEACTIVITY,SignaturePadDelegate {
    func didStart() {
        if (signpad.isSigned){
                   self.done.tintColor = UIColor.systemBlue
               }else{
                   self.done.tintColor = UIColor.gray
               }
    }
    
    func didFinish() {
        if (signpad.isSigned){
            self.done.tintColor = UIColor.systemBlue
        }else{
            self.done.tintColor = UIColor.gray
        }
    }
    
    @IBOutlet var done: UIBarButtonItem!
    var uid = ""
    @IBOutlet var signpad: SignaturePad!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        signpad.layer.borderWidth = 2
        signpad.layer.borderColor = UIColor.blue.cgColor
        self.signpad.delegate = self
        if (signpad.isSigned){
            self.done.tintColor = UIColor.systemBlue
        }else{
            self.done.tintColor = UIColor.gray
        }
    }
    
    @IBAction func clearbtn(_ sender: UIButton) {
        self.signpad.clear()
        
        if (signpad.isSigned){
            self.done.tintColor = UIColor.systemBlue
        }else{
            self.done.tintColor = UIColor.gray
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setnav(title: self.navigationItem.title!)

    }
    
    @IBAction func donebtn(_ sender: Any) {
        if signpad.isSigned {
            if let sign = signpad.getSignature(){
                print("sign captured")
                if (self.navigationItem.title! == "New Customer"){
                    self.updatenewcustsign(uid: self.uid, sign: self.imagetobase(image: sign))
                }else if (self.navigationItem.title! == "Customer Order"){
                    let id = self.getlastactivityid(orderid: CUSTORDERVC.custid!)
                    self.insertimage(ordernum: CUSTORDERVC.custid!, image: self.imagetobase(image: sign), type: "1", date: self.getdate(format: "yyyy-MM-dd"), activity : id, post: "0")
                }
                self.navigationController?.popViewController(animated: true)
            }
        }else{
            self.showToast(message: "Signature is mandatory")
        }
    }
}
