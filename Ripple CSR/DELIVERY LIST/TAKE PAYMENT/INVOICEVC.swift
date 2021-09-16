//
//  INVOICEVC.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 10/07/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import SQLite3

class INVOICEVC: BASEACTIVITY,UITableViewDelegate,UITableViewDataSource,InvoiceProt {
    func checktapped() {
        setlist()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoiceadapter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "invcell", for: indexPath) as! INVOICETBLCELL
        
        let list: INVOICEADAPTER
        list = invoiceadapter[indexPath.row]
        
        cell.checkbox.isSelected = list.isselected
        cell.invid = list.invid
        cell.desclbl.text = list.desc
        if (indexPath.row == 0){
            cell.headerlbl.isHidden = false
            cell.headerlbl.text = "Today's Invoice"
        }else if (indexPath.row == todaycount){
            cell.headerlbl.isHidden = false
            cell.headerlbl.text = "Previous Invoice"
        }else{
            cell.headerlbl.isHidden = true
        }
        cell.delegate = self
        
        return cell
    }
    
    var invoiceadapter = [INVOICEADAPTER]()
    
    @IBOutlet var totallbl: UILabel!
    @IBOutlet var invoicetbl: UITableView!
    var todaycount: Int8!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.invoicetbl.delegate = self
        self.invoicetbl.dataSource = self
        
        setlist()
    }
    @IBAction func takepaymentbtn(_ sender: UIButton) {
        self.showToast(message: "Under Construction...")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setnav(title: self.navigationItem.title!)

    }
    
    func getheadercont(){
        var stmt1:OpaquePointer?
                                 
        let query = "select count(*) from invoice where date  = '\(self.getdate(format: "dd/MM/yy"))' and status = '0' and custid = '1'"
                          
                 if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
                     let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                     print("error preparing get: \(errmsg)")
                     return
                 }
        //Custorder(custid text,userid text, itemid text, qty text, date text, price text, totvalue text, status text,post text)
                
                 if(sqlite3_step(stmt1) == SQLITE_ROW){
                    let count = String(cString: sqlite3_column_text(stmt1, 0))
                    todaycount = Int8(count)
                }
        
    }
    func setlist(){
        getheadercont()
        
        var stmt1:OpaquePointer?
                 
                self.invoiceadapter.removeAll()

            let query = "select * from Invoice where custid = '1' and status = '0'"
        
                 if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
                     let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                     print("error preparing get: \(errmsg)")
                     return
                 }
        //Custorder(custid text,userid text, itemid text, qty text, date text, price text, totvalue text, status text,post text)
                
                 while(sqlite3_step(stmt1) == SQLITE_ROW){
                    let date = String(cString: sqlite3_column_text(stmt1, 1))
                    let invid = String(cString: sqlite3_column_text(stmt1, 2))
                    let amt = String(cString: sqlite3_column_text(stmt1, 3))
                    let isselected = String(cString: sqlite3_column_text(stmt1, 5))
                    
                    invoiceadapter.append(INVOICEADAPTER(invid: invid, isselected: Bool(isselected)!, desc: "\(date) - \(invid) -  $\(amt)"))
                }
                self.invoicetbl.reloadData()
                self.refreshtotal()
    }
    
    
    func refreshtotal(){
//        select sum(amount) from invoice where isselected = 'true' and custid = '1' and status = '0'
        var stmt1:OpaquePointer?
                                 
        let query = "select ifnull(sum(amount),'0') from invoice where isselected = 'true' and custid = '1' and status = '0'"
                          
                 if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
                     let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                     print("error preparing get: \(errmsg)")
                     return
                 }
                
                 if(sqlite3_step(stmt1) == SQLITE_ROW){
                    let total = String(cString: sqlite3_column_text(stmt1, 0))
                    self.totallbl.text = "$\(total)"
                }
    }
    
}
