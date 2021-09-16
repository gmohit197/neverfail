//
//  SELECTCUSTVC.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 12/08/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import SwiftEventBus
import SQLite3

class SELECTCUSTVC: BASEACTIVITY {

    @IBOutlet var custspnr: DropDown!
    @IBOutlet var custview: UIView!
    @IBOutlet var searchedt: UITextField!
    @IBOutlet var srchbtn: UIButton!
    @IBOutlet var typespnr: DropDown!
    var custid = [String]()
    var custadd = [String]()
    var typeidarr = [String]()
    var typeid = -1
    var id = ""
    
    override func viewWillAppear(_ animated: Bool) {
        self.setnav(title: self.navigationItem.title!)
        
    }
    
    @IBAction func srch(_ sender: UIButton) {
        
        if (self.typespnr.text?.count == 0){
            self.showToast(message: "Select a search criteria")
        }else if (self.searchedt.text!.count == 0 && self.searchedt.text == " "){
            self.showToast(message: "Enter \(self.typespnr.text!) to search")
        }
        else{
            if (AppDelegate.ntwrk > 0){
                self.showIndicator("Loading...", vc: self)
                self.gettoken()
            }else{
                self.showToast(message: "Internet connection required")
            }
        }
    }
    
    override public func gotsrch(){
        self.hideindicator()
        initcustspnr()
    }
    
    func initcustspnr(){
        var stmt1: OpaquePointer?
        custspnr.optionArray.removeAll()
        custid.removeAll()
        custadd.removeAll()
        self.custspnr.isSearchEnable = false
        
        var flag : Bool! = true
        
        let query = "select name,custid,street,city,state,id from custsrch"
        //        custsrch(custid text, name text,city text,state text,street text)

                 if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
                     let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                     print("error preparing get: \(errmsg)")
                     return
                 }
        var street = "", city = "",state = ""
                 while(sqlite3_step(stmt1) == SQLITE_ROW){
                    let id = String(cString: sqlite3_column_text(stmt1, 5))
                    let name = String(cString: sqlite3_column_text(stmt1, 0))
                    let acnum = String(cString: sqlite3_column_text(stmt1, 1))
                    street = String(cString: sqlite3_column_text(stmt1, 2))
                    city = String(cString: sqlite3_column_text(stmt1, 3))
                    state = String(cString: sqlite3_column_text(stmt1, 4))
                    
                    if (street == ""){
                        street = "-"
                    }
                    if (city == ""){
                        city = "-"
                    }
                    if (state == "-"){
                        state = "-"
                    }
                    
                    let nameadd = "\(name) | \(street), \(city), \(state)"
                    
                    custspnr.optionArray.append(nameadd)
                    custid.append(acnum)
                    custadd.append(id)
                    flag = false
                 }
        if (flag){
            self.custview.isHidden = true
            self.showToast(message: "No result found")
        }else{
            self.custview.isHidden = false
        }
    }
    
    override public func notsrch(){
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.hideindicator()
        self.showToast(message: "Unable to get customers")
    }
    
    override public func srcherr(){
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.hideindicator()
        self.showToast(message: "Server not reachable.")
    }
    
    override func callback() {
        self.postcustsrch(srchstr: self.searchedt.text!, criteria: self.typeid)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.getbackbarbutton()

        custspnr.isSearchEnable = true
        
        custspnr.didSelect { (selection, index, id) in
            print("selection - \(selection) - index - \(index) id - \(id)")
            AppDelegate.custid = self.custid[index]
            CUSTORDERVC.custid = self.custid[index]
            CUSTORDERVC.contid = self.custid[index]
            self.id = self.custadd[index]
            
            if (AppDelegate.ntwrk > 0){
                self.showIndicator("Loading...", vc: self)
                self.getcrmtoken()
            }else{
                self.showToast(message: "Internet connection required.")
            }
        }
        
        typespnr.isSearchEnable = false
        
        typespnr.optionArray.removeAll()
        typespnr.optionArray.append("Name")
        typespnr.optionArray.append("Email")
        typespnr.optionArray.append("Phone")
        typespnr.optionArray.append("Address")

        typespnr.didSelect { (selection, index, id) in
            print("typespnr ====> \(selection) - \(index) - \(id)")
            self.typeid = index + 1
        }
        
        self.custview.isHidden = true
        
    }
    
    override func acgot(){
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.hideindicator()
        let nvc = self.storyboard?.instantiateViewController(withIdentifier: "SELECTREQVC") as! SELECTREQVC
        nvc.id = self.id
        self.navigationController?.pushViewController(nvc, animated: true)
    }
    
    override func acnot(){
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.hideindicator()
        self.showToast(message: "Unable to get account ID")
    }
    
    override func crmerr(){
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.hideindicator()
        self.showToast(message: "Customer Account Does not exist in D365 Customer Service")
    }
    
    override func acerr(){
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.hideindicator()
        self.showToast(message: "Server not reachable.")
    }
    
    override func backbuttonPressed() {
        self.gotohome()
    }
    override func crmcallback() {
        self.getaccountid(acountno: CUSTORDERVC.contid!)
    }
    
    override func failcall() {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.view.isUserInteractionEnabled = true
        self.showToast(message: "Authentication failed!!!")
        self.hideindicator()
    }
   
}
