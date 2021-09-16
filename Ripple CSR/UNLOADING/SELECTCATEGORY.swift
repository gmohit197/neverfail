//
//  SELECTCATEGORY.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 19/06/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import MaterialComponents
import SQLite3

class SELECTCATEGORY: BASEACTIVITY,UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView.tag == 1){
            return mainadapter.count
        }else{
            return itemmasteradapter.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (tableView.tag == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "mcell", for: indexPath) as! MAINCELL
            
            let list : SERIALBATCHADAPTER
            list = mainadapter[indexPath.row]
            
            cell.label.text = list.label!
            
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "scell", for: indexPath) as! Searchcell
            
            let list : ITEMADAPTER
            list = itemmasteradapter[indexPath.row]
            
            cell.itemlbl.text = list.itemname
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (tableView.tag == 1){
            let list : SERIALBATCHADAPTER
            list = mainadapter[indexPath.row]
            cat = list.label!
            settbl(cat: cat, query: "")
        }else if (tableView.tag == 2){
            
            print("itemname ===> \(itemmasteradapter[indexPath.row].itemname)")
            let storyboard = UIStoryboard(name: "UNLOADING", bundle: nil)
            let registrationVC = storyboard.instantiateViewController(withIdentifier: "ENTERQTYVC") as! ENTERQUANTITYVC
            registrationVC.itemid = itemmasteradapter[indexPath.row].itemid
            registrationVC.navigationItem.title = self.navigationItem.title
            registrationVC.origin = self.origin
            navigationController?.pushViewController(registrationVC, animated: true)
        }
    }
    
    var origin = ""
    var cat: String!
    var mainadapter = [SERIALBATCHADAPTER]()
    
    @IBOutlet var searchbar: MDCTextField!
    
    @IBOutlet var maintable: UITableView!
    @IBOutlet var searchtbl: UITableView!
    @IBOutlet var searchccard: CardView!
    
    @IBOutlet var mainview: UIView!
    
    var searchcontroller: MDCTextInputControllerOutlined!
    var itemmasteradapter = [ITEMADAPTER]()
    
    @IBAction func cancelbtn(_ sender: Any) {
        self.mainview.isHidden = true
        self.searchbar.text = ""
        self.view.endEditing(true)
    }
    
    @IBAction func searchbar(_ sender: UITextField) {
        settbl(cat: cat, query: sender.text!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setbg()
        self.mainview.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        searchcontroller = MDCTextInputControllerOutlined(textInput: searchbar)
        searchcontroller.setfordark(field: searchbar, controller: self)
        self.setnav(title: self.navigationItem.title!)
        self.setlist()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // Trait collection has already changed
      searchcontroller.setfordark(field: searchbar, controller: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func setlist(){
        self.maintable.delegate = self
        self.maintable.dataSource = self
        
         var stmt1:OpaquePointer?
         
        let query = "SELECT articletyp from Itemmaster group by articletyp"
         
         mainadapter.removeAll()
         
         if sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
             let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
             print("error preparing get: \(errmsg)")
             return
         }
         while(sqlite3_step(stmt1) == SQLITE_ROW){
             let cat = String(cString: sqlite3_column_text(stmt1, 0))
            mainadapter.append(SERIALBATCHADAPTER(lotid: "", label: cat, qty: ""))
         }
         self.maintable.reloadData()
    }
    
    func settbl(cat: String,query: String){
        self.searchtbl.delegate = self
        self.searchtbl.dataSource = self
        
         var stmt1:OpaquePointer?
         
        var query = ""
         
        if (self.origin == "Checkinitems"){
            query = "select * from Itemmaster where articletyp = '\(cat)' and (itemname like '%\(query)%' or itemcode like '%\(query)%') and itemcode not in (select itemid from checkinitems)"
        }else if (self.origin == "loading"){
            query = "select * from Itemmaster where articletyp = '\(cat)' and (itemname like '%\(query)%' or itemcode like '%\(query)%') and itemcode not in (select itemid from loading)"
        }else if (self.origin == "stocktr"){
            query = "select * from Itemmaster where articletyp = '\(cat)' and (itemname like '%\(query)%' or itemcode like '%\(query)%') and itemcode not in (select itemid from StockTransfer where uid = '\(STOCKTRVC.uid!)')"
        }else{
            query = "select * from Itemmaster where articletyp = '\(cat)' and (itemname like '%\(query)%' or itemcode like '%\(query)%') --and itemcode not in (select itemnum from custorderline where custordernum = '\(CUSTORDERVC.custid!)')"
        }
         
         itemmasteradapter.removeAll()
         
         if sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
             let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
             print("error preparing get: \(errmsg)")
             return
         }
         while(sqlite3_step(stmt1) == SQLITE_ROW){
             let itemid = String(cString: sqlite3_column_text(stmt1, 0))
            let itemname = String(cString: sqlite3_column_text(stmt1, 1))
            let url = String(cString: sqlite3_column_text(stmt1, 8))
            
            itemmasteradapter.append(ITEMADAPTER(itemid: itemid, itemname: itemname, url: url))
         }
         self.searchtbl.reloadData()
        self.mainview.isHidden = false
    }
}
