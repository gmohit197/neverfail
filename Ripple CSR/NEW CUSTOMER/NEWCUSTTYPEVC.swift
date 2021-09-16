//
//  NEWCUSTTYPEVC.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 14/07/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit

class NEWCUSTTYPEVC: BASEACTIVITY {

    
    @IBOutlet var residential: CardView!
    @IBOutlet var commercial: CardView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.setnav(title: self.navigationItem.title!)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapres = UITapGestureRecognizer(target: self, action: #selector(restapped))
        residential.addGestureRecognizer(tapres)
        
        let tapcom = UITapGestureRecognizer(target: self, action: #selector(comtapped))
        commercial.addGestureRecognizer(tapcom)
    }
    @objc func restapped(){
        self.push(storybId: "NEWCUSTOMER", vcId: "NCRESMAINNC", vc: self)
    }
    @objc func comtapped(){
        self.push(storybId: "NEWCUSTOMER", vcId: "NCMAILNC", vc: self)
    }
}
