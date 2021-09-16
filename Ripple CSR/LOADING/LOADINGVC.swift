//
//  LOADINGVC.swift
//  Ripple CSR
//
//  Created by Acxiom Consulting on 06/06/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import SQLite3

class LOADINGVC: BASEACTIVITY,TapQty,UITableViewDelegate, UITableViewDataSource {
    
    func updateqty(at index: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView.tag == 1){
            return loadadapter.count
        }else{
            return bsadapter.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView.tag == 1){
            let list: LoadingAdapter
            list = loadadapter[indexPath.row]
            
            let itemid = self.getitemidfromname(itemname: list.productname!)
            self.checkbatchserial(itemid: itemid)
            if (isbatch || isserial){
                self.setbatchtable(itemid: itemid)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (tableView.tag == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadcell", for: indexPath) as! LOADIGCELL
            
            let list: LoadingAdapter
            list = loadadapter[indexPath.row]
            
            cell.productlbl.text = list.productname
            cell.qtylbl.text = list.qty
            cell.delegate = self
            cell.index = indexPath
            
            tableView.backgroundColor = UIColor.clear
            cell.backgroundColor = UIColor.clear
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "bcell", for: indexPath) as! BATCHCELL
            
            let list: SERIALBATCHADAPTER
            list = bsadapter[indexPath.row]
            
            cell.batchlbl.text = list.label!
            cell.bqtylbl.text = list.qty!
            
            return cell
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setbg()
        self.setnav(title: self.navigationItem.title!)
        if (self.navigationItem.title! == "Stock Transfer" && (TRANSFERREQVC.status! != "Open" || self.getselfcheck())){
            rejectstack.isHidden = true
            laststack.isHidden = true
        }
    }

    @IBOutlet var loadingtable: UITableView!
    @IBOutlet var rejectbox: UIButton!
    @IBOutlet var checkboxbtn: UIButton!
    
    @IBAction func closebtn(_ sender: UIButton) {
        self.batchserialview.isHidden = true
    }
    
    @IBOutlet var titlelbl: UILabel!
    @IBOutlet var bstable: UITableView!
    @IBOutlet var closebtn: UIButton!
    @IBOutlet var batchserialview: UIView!
    @IBOutlet var rejectstack: UIStackView!
    @IBOutlet var laststack: UIStackView!
    
    @IBAction func checkbox(_ sender: UIButton) {
       animatebtn()
        if self.rejectbox.isSelected {
                self.animaterbtn()
        }
    }
    @IBAction func rejectbtn(_ sender: UIButton) {
        animaterbtn()
        if self.checkboxbtn.isSelected {
            self.animatebtn()
        }
    }
    
    var loadadapter = [LoadingAdapter]()
    var bsadapter = [SERIALBATCHADAPTER]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingtable.delegate = self
        loadingtable.dataSource = self
        
        checkboxbtn.setImage(UIImage(named:"unselected"), for: .normal)
        checkboxbtn.setImage(UIImage(named:"selected"), for: .selected)
        
        rejectbox.setImage(UIImage(named:"unselected"), for: .normal)
        rejectbox.setImage(UIImage(named:"selected"), for: .selected)
        
        laststack.addBorder(color: .black, backgroundColor: .clear, thickness: 1)
        rejectstack.addBorder(color: .black, backgroundColor: .clear, thickness: 1)
        
        initdata()
        self.batchserialview.isHidden = true
    }
    
    func setbatchtable(itemid: String){
        
        self.bstable.delegate = self
        self.bstable.dataSource = self
        self.bsadapter.removeAll()
        var stmt1: OpaquePointer?
        var query = ""
        
        if (self.isbatch){
            if (self.navigationItem.title! == "Stock Transfer"){
                query = "select inventbatchid,qty from TransferDetailsSku where itemid = '\(itemid)' and skuid = '\(TRANSFERREQVC.transferid!)'"
            }else{
                query = "select batch,qty from loading where itemid = '\(itemid)'"
            }
            
            self.titlelbl.text = "Batch Details"
        }else if (self.isserial){
            if (self.navigationItem.title! == "Stock Transfer"){
                query = "select inventserialid,qty from TransferDetailsSku where itemid = '\(itemid)' and skuid = '\(TRANSFERREQVC.transferid!)'"
            }else{
                query = "select serial,qty from loading where itemid = '\(itemid)'"
            }
            
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
    
    @IBAction func donebtn(_ sender: UIBarButtonItem) {
        if (self.navigationItem.title! == "Stock Transfer" && TRANSFERREQVC.status != "Open"){
            self.navigationController?.popViewController(animated: true)
        }else{
        if validate() {
            if (AppDelegate.ntwrk > 0){
                self.showIndicator("Syncing...", vc: self)
                self.gettoken()
            }else{
                self.showToast(message: "Internet connection required.")
            }
        }else{
            self.showToast(message: "Please verify the items first.")
        }
      }
    }
    
    var isbatch = false
    var isserial = false
    
    func getselfcheck() -> Bool{
        var flag = false
        var stmt1:OpaquePointer?
        
        let query = "select driverid from TruckMaster where code = (select fromtruck from TransferDetails a where trucktransferid = '\(TRANSFERREQVC.transferid!)')"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return flag
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            let id = String(cString: sqlite3_column_text(stmt1, 0))
            if (id == UserDefaults.standard.string(forKey: "did")!){
                flag = true
            }else{
                flag = false
            }
        }else{
            flag = false
        }
        return flag
    }
    
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
    var flag = 0
    
    override func callback() {
      flag = 0
        print("accept/reject ---> \(flag)")
        if (self.navigationItem.title! == "Stock Transfer"){
            if (self.checkboxbtn.isSelected){
                flag = 1
            }else{
                flag = 2
            }
            self.posttransferstatus(acceptreject: flag, transferid: TRANSFERREQVC.transferid!)
        }else{
            if (self.checkboxbtn.isSelected){
                flag = 1
            }else{
                flag = 0
            }
            self.postload(acceptreject: flag)
        }
    }
    
    override func tdgot() {
        self.hideindicator()
        self.updatestatus(transferid: TRANSFERREQVC.transferid!,status: flag)
        self.navigationController?.popViewController(animated: true)
        self.showmsg(msg: "Transfer details successfully sent to server")
    }
    
    override func tdnot() {
        self.hideindicator()
        self.showToast(message: "Unable to send Transfer details due to API error")
    }
    
    override func tderr() {
        self.hideindicator()
        self.showToast(message: "Unable to send Transfer details due to Server error")
    }
    
    override func rlgot(tid: String) {
        UserDefaults.standard.set(self.getdate(format: "yyyy-MM-dd"), forKey: "trkdate")
        let alert = UIAlertController(title: "Alert", message: "Load data sent successfully with Transfer ID - \(tid)", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: .destructive) { (action) in
            UserDefaults.standard.set("", forKey: "syncdate")
            self.gotohome()
        }
        alert.addAction(dismiss)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func rlnot() {
        self.hideindicator()
        self.showToast(message: "Load data not sent due to API error")
    }
    override func rlnodta(msg: String) {
        self.hideindicator()
        self.showToast(message: msg)
    }
    override func rlerr() {
        self.hideindicator()
        self.showToast(message: "Load data not sent due to Server error")
    }
    
    override func failcall() {
        self.hideindicator()
        self.showToast(message: "Authentication failed!!!")
    }
    
    func validate()-> Bool{
        
        var flag = true
        
        if (!self.checkboxbtn.isSelected && !self.rejectbox.isSelected){
            flag = false
        }
        return flag
    }
    
    func initdata(){
        loadadapter.removeAll()
        var stmt1: OpaquePointer?
        var query = ""
        
        if (self.navigationItem.title! == "Stock Transfer"){
            query = "select itemname,qty from TransferDetailsSku where skuid = '\(TRANSFERREQVC.transferid!)'"
        }else{
            query = "select itemname, sum (qty) as qty from loading group by itemname"
        }
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let itemname = String(cString: sqlite3_column_text(stmt1, 0))
            let qty = String(cString: sqlite3_column_text(stmt1, 1))
            
            loadadapter.append(LoadingAdapter(productname: itemname, qty: qty,date:  "", price: ""))
        }
        
        self.loadingtable.reloadData()
    }
    
    @objc func animatebtn(){
        print("animation started")
        UIView.animate(withDuration: 0.05, delay: 0.05, options: .curveLinear, animations: {
            self.checkboxbtn.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        }) { (success) in
            UIView.animate(withDuration: 0.05, delay: 0.05, options: .curveLinear, animations: {
                self.checkboxbtn.isSelected = !self.checkboxbtn.isSelected
                self.checkboxbtn.transform = .identity
                
            }, completion: nil)
        }
    }
    @objc func animaterbtn(){
           print("animation started")
           UIView.animate(withDuration: 0.05, delay: 0.05, options: .curveLinear, animations: {
               self.rejectbox.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
           
           }) { (success) in
               UIView.animate(withDuration: 0.05, delay: 0.05, options: .curveLinear, animations: {
                   self.rejectbox.isSelected = !self.rejectbox.isSelected
                   self.rejectbox.transform = .identity
                
               }, completion: nil)
           }
       }
}

