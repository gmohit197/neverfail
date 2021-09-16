//
//  RUNSUMMARYVC.swift
//  Ripple CSR
//
//  Created by Acxiom Consulting on 10/06/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import SwiftEventBus

class RUNSUMMARYVC: BASEACTIVITY {

    @IBOutlet var totdroplbl: UILabel!
    @IBOutlet var totkmslbl: UILabel!
    @IBOutlet var tottimelbl: UILabel!
    
    override func callback() {
        self.getcondition(type: "2")
    }
    
    @IBOutlet var innerview: UIView!
    override func viewWillAppear(_ animated: Bool) {
        self.innerview.backgroundColor = UIColor.clear
        self.setbg()
        self.setnav(title: self.navigationItem.title!)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        totkmslbl.text = "35 kms"
        totdroplbl.text = "12"
        tottimelbl.text = "8 hr 42 mins"
        
        SwiftEventBus.onMainThread(self, name: "gotcom") { (result) in
            print("\n*** goto compliance called ***\n")
            self.view.isUserInteractionEnabled = true
            self.donebtn.isEnabled = true
            self.push(storybId: "COMPLIANCE", vcId: "COMPLIANCENC", vc: self)
        }
        
        SwiftEventBus.onMainThread(self, name: "notcom") { (result) in
            self.view.isUserInteractionEnabled = true
            self.showToast(message: "Error in API")
            self.donebtn.isEnabled = true
        }
        
        SwiftEventBus.onMainThread(self, name: "cskip") { (result) in
            self.push(storybId: "TRUCKLOAD", vcId: "TRUCKLOADFIRSTNC", vc: self)
           UserDefaults.standard.set(self.getdate(format: "yyyy-MM-dd"), forKey: "comdate")
        }
    }
    @IBOutlet var donebtn: UIBarButtonItem!
    
    override func viewDidAppear(_ animated: Bool) {
//        SwiftEventBus.
        
    }
    
    @IBAction func Nextbtn(_ sender: Any) {
        if (AppDelegate.ntwrk > 0){
            self.donebtn.isEnabled = false
            self.gettoken()
        }else{
            self.showToast(message: "No Internet connection")
        }
    }
}
