//
//  SELECTREQVC.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 12/08/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import SwiftEventBus
import SQLite3

class SELECTREQVC: BASEACTIVITY {

    @IBOutlet var namelbl: UILabel!
    @IBOutlet var addresslbl: UILabel!
    @IBOutlet var numberlbl: UILabel!
    @IBOutlet var casecard: CardView!
    @IBOutlet var ordercard: CardView!
    @IBOutlet var paymentcard: CardView!
    
    var id = ""
   
    override func viewWillAppear(_ animated: Bool) {
        self.setnav(title: self.navigationItem.title!)
        setdetail()
    }
    
    func setdetail(){
        var stmt1:OpaquePointer?
        let query = "select custid , name ,ifnull(city,'-') ,ifnull(state,'-') ,ifnull(street,'-') from custsrch where custid = '\(CUSTORDERVC.custid!)' and id = '\(id)'"

        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            let name = String(cString: sqlite3_column_text(stmt1, 1))
            let state = String(cString: sqlite3_column_text(stmt1, 3))
            let street = String(cString: sqlite3_column_text(stmt1, 4))
            let city = String(cString: sqlite3_column_text(stmt1, 2))
            
            self.namelbl.text = name
            self.addresslbl.text = "\(street), \(city), \(state)"
            self.numberlbl.text = CUSTORDERVC.custid!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        init1()
        // Do any additional setup after loading the view.
    }
    
    

    //MARK:- init data
    func init1(){
        self.namelbl.text = CUSTORDERVC.custid
        self.numberlbl.text = "0123456789"
        self.addresslbl.text = "1, \(CUSTORDERVC.custid!), Smithville, NSW, 2000"
        
        let tapcase = UITapGestureRecognizer(target: self, action: #selector(self.casetapped))
        self.casecard.addGestureRecognizer(tapcase)
        
        let taporder = UITapGestureRecognizer(target: self, action: #selector(self.ordertaped))
        self.ordercard.addGestureRecognizer(taporder)
        
        self.paymentcard.isHidden = true
//        let tappayment = UITapGestureRecognizer(target: self, action: #selector(self.paymenttapped))
//        self.paymentcard.addGestureRecognizer(tappayment)
        
        self.updatecases(today: self.getdate(format: "dd-MMM-yy"))
    }
    
    @objc func ordertaped(){
        let storyboard = UIStoryboard(name: "RESQUENCING", bundle: nil)
        let custinfo = storyboard.instantiateViewController(withIdentifier: "CUSTINFOVC") as! CUSTOMERINFOVC
        CUSTOMERINFOVC.id = self.id
        AppDelegate.isorder = true
        custinfo.navigationItem.title = "Sales Order"
        self.navigationController?.pushViewController(custinfo, animated: true)
    }

    
    @objc func paymenttapped(){
        self.push(storybId: "RESQUENCING", vcId: "INVNC", vc: self)
    }
    
    @objc func casetapped(){
        let cvc = self.storyboard?.instantiateViewController(withIdentifier: "RAISEVC") as! RAISECASEVC
        self.navigationController?.pushViewController(cvc, animated: true)
    }
}
