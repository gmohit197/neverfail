//
//  MANAGEDELVC.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 02/07/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit

class MANAGEDELVC: BASEACTIVITY {
    
    @IBOutlet var reschedule: CardView!
    @IBOutlet var skip: CardView!
    @IBOutlet var neworder: CardView!
    @IBOutlet var cancelorder: CardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    func initdata(){
        let tapres = UITapGestureRecognizer(target: self, action: #selector(rescardtap))
        reschedule.addGestureRecognizer(tapres)
        
        let tapskip = UITapGestureRecognizer(target: self, action: #selector(skipcardtap))
        skip.addGestureRecognizer(tapskip)
        
        let tapnewordr = UITapGestureRecognizer(target: self, action: #selector(newordercardtap))
        neworder.addGestureRecognizer(tapnewordr)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
                self.setnav(title: self.navigationItem.title!)
        self.initdata()
    }
    
    @objc func rescardtap(){
        self.push(storybId: "MANAGEDEL", vcId: "RESNC", vc: self)
    }
    
    @objc func skipcardtap(){
//        self.showToast(message: "under construction")
        self.push(storybId: "MANAGEDEL", vcId: "SKIPNC", vc: self)
    }
    
    @objc func newordercardtap(){
        let storyboard = UIStoryboard(name: "RESQUENCING", bundle: nil)
        let custinfo = storyboard.instantiateViewController(withIdentifier: "CUSTINFOVC") as! CUSTOMERINFOVC
        AppDelegate.isorder = false 
        custinfo.navigationItem.title = "Sales Order"
        self.navigationController?.pushViewController(custinfo, animated: true)
    }
    
}
