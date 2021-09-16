//
//  TRUCKSTKVC.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 21/08/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import SQLite3

class TRUCKSTKVC: BASEACTIVITY,UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView.tag == 1){
            return loadadapter.count
        }else{
            return bsadapter.count
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView.tag == 1){
            let list: CUSTORDERADAPTER
            list = loadadapter[indexPath.row]
            
            let itemid = self.getitemidfromname(itemname: list.proddesc!)
            self.checkbatchserial(itemid: itemid)
            if (isbatch || isserial){
                self.setbatchtable(itemid: itemid)
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView.tag == 1){
        let cell = tableView.dequeueReusableCell(withIdentifier: "loadcell", for: indexPath) as! LOADTBLCELL
        
        let list: CUSTORDERADAPTER
        list = loadadapter[indexPath.row]
        
        cell.productlbl.text = list.proddesc
        cell.qtylbl.text = list.qty
        
        return cell
    }else{
        let cell = tableView.dequeueReusableCell(withIdentifier: "bcell", for: indexPath) as! BATCHCELL
        
        let list: SERIALBATCHADAPTER
        list = bsadapter[indexPath.row]
        
        cell.batchlbl.text = list.label!
        cell.bqtylbl.text = list.qty!
        cell.index = indexPath
        
        
        return cell
    }
    }
    var loadadapter = [CUSTORDERADAPTER]()
    var bsadapter = [SERIALBATCHADAPTER]()
    @IBOutlet var currentlbl: UILabel!
    @IBOutlet var loadedlbl: UILabel!
    @IBOutlet var loadtbl: UITableView!
    @IBAction func closebtn(_ sender: UIButton) {
        self.batchserialview.isHidden = true
    }
    
    @IBOutlet var titlelbl: UILabel!
    @IBOutlet var bstable: UITableView!
    @IBOutlet var closebtn: UIButton!
    @IBOutlet var batchserialview: UIView!
    @IBAction func donebtn(_ sender: UIBarButtonItem) {
        self.gotohome()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setnav(title: self.navigationItem.title!)
        self.batchserialview.isHidden = true
        self.updatets()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadtbl.delegate = self
        self.loadtbl.dataSource = self
        self.loadtbl.tableFooterView = UIView()
        
        setlist()
        setloadedweight()
    }
    
    var isbatch = false
    var isserial = false
    
    func checkbatchserial(itemid: String){
        var stmt1:OpaquePointer?
        
        let query = "SELECT isbatch,isserial from Itemmaster where itemcode = '\(itemid)'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            let batch = String(cString: sqlite3_column_text(stmt1, 0))
            let serial = String(cString: sqlite3_column_text(stmt1, 1))
            
            if (batch == "1"){
                self.isbatch = true
            }else{
                self.isbatch = false
            }
            if (serial == "1"){
                self.isserial = true
            }else{
                self.isserial = false
            }
        }
    }
    
    func setbatchtable(itemid: String){
        
        self.bstable.delegate = self
        self.bstable.dataSource = self
        self.bsadapter.removeAll()
        var stmt1: OpaquePointer?
        var query = ""
        
        if (self.isbatch){
            query = "select batch,netqty from TruckStock where itemid = '\(itemid)'"
            self.titlelbl.text = "Batch Details"
        }else if (self.isserial){
            query = "select serial,netqty from TruckStock where itemid = '\(itemid)'"
            self.titlelbl.text = "Serial Details"
        }
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let itemname = String(cString: sqlite3_column_text(stmt1, 0))
            let qty = String(cString: sqlite3_column_text(stmt1, 1))
            
            bsadapter.append(SERIALBATCHADAPTER(lotid: "", label: itemname, qty: qty))
        }
        self.bstable.reloadData()
        self.batchserialview.isHidden = false
    }
    
    func setloadedweight(){
        var stmt1:OpaquePointer?
        let query = "select ifnull( sum (IM.weight * LD.netqty),'0' ) as currentweight,ifnull( sum (IM.weight * LD.loadqty),'0' ) as loadedweigth from TruckStock LD inner join Itemmaster IM on LD.itemid = IM.Itemcode"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        } 
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let loadedweigth = String(cString: sqlite3_column_text(stmt1, 1))
            let currentweight = String(cString: sqlite3_column_text(stmt1, 0))
            self.loadedlbl.text = loadedweigth
            self.currentlbl.text = currentweight
        }
    }

    func setlist(){
        loadadapter.removeAll()
        var stmt1:OpaquePointer?
        let query = "select b.itemname, sum(a.netqty) from TruckStock a inner join itemmaster b on a.itemid = b.itemcode group by a.itemid"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let proddesc = String(cString: sqlite3_column_text(stmt1, 0))
            let qty = String(cString: sqlite3_column_text(stmt1, 1))
            
            self.loadadapter.append(CUSTORDERADAPTER(proddesc: proddesc, qty: qty, price: "", date: "",itemch: "",itemdis: "", itemid: ""))
        }
        loadtbl.reloadData()
    }
}
