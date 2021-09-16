//
//  UNLOADINGPRODUCTTABVC.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 19/06/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import SQLite3

class UNLOADINGPRODUCTTABVC: BASEACTIVITY,TapQty, UITableViewDelegate, UITableViewDataSource,batchqty {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView.tag == 1){
            return unloadingadapter.count
        }else{
            return batchadapter.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView.tag == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadcell", for: indexPath) as! LOADIGCELL
            
            let list: LoadingAdapter
            list = unloadingadapter[indexPath.row]
            
            cell.productlbl.text = list.productname
            cell.qtylbl.text = list.qty
            cell.delegate = self
            cell.index = indexPath
            tableView.backgroundColor = UIColor.clear
            cell.backgroundColor = UIColor.clear
            
            return cell
        }else if (tableView.tag == 2){  // for batch table
            let cell = tableView.dequeueReusableCell(withIdentifier: "bcell", for: indexPath) as! BATCHCELL
            
            let list: SERIALBATCHADAPTER
            list = batchadapter[indexPath.row]
            
            cell.batchlbl.text = list.label
            cell.bqtylbl.text = list.qty
            cell.index = indexPath
            cell.delegate = self
            
            return cell
        }else {  // for serial table
            let cell = tableView.dequeueReusableCell(withIdentifier: "scell", for: indexPath) as! SERIALCELL
            
            let list: SERIALBATCHADAPTER
            list = batchadapter[indexPath.row]
            
            cell.seriallbl.text = list.label
            cell.sqtylbl.text = list.qty
            //            cell.delegate = self
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if (tableView.tag == 1){
                let list: LoadingAdapter
                list = unloadingadapter[indexPath.row]
                let alert = UIAlertController(title: "Delete", message: "Do you want to delete this item?", preferredStyle: .alert)
                
                let okaction = UIAlertAction(title: "Yes", style: .default) { _ in
                    self.unloadingadapter.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    let itemid = self.getitemidfromname(itemname: list.productname!)
                    self.deleteinvline(itemid: itemid, date: list.date!)
                    self.deletebatchitems(lotid: itemid, type: self.origin)
                    self.setlist()
                    alert.dismiss(animated: true, completion: nil)
                }
                
                let noaction = UIAlertAction(title: "No", style: .destructive, handler: nil)
                alert.addAction(okaction)
                alert.addAction(noaction)
                
                self.present(alert, animated: true, completion: nil)
            }else if (tableView.tag == 2){  // for batch table
                let list: SERIALBATCHADAPTER
                list = batchadapter[indexPath.row]
                let alert = UIAlertController(title: "Delete", message: "Do you want to delete this item?", preferredStyle: .alert)
                
                let okaction = UIAlertAction(title: "Yes", style: .default) { _ in
                    self.batchadapter.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    self.deleteerialbatch(lotid: list.lotid!, batch: list.label!, serial: "", type: self.origin)
                    self.setbatchtable()
                    alert.dismiss(animated: true, completion: nil)
                }
                
                let noaction = UIAlertAction(title: "No", style: .destructive, handler: nil)
                alert.addAction(okaction)
                alert.addAction(noaction)
                
                self.present(alert, animated: true, completion: nil)
            }else if (tableView.tag == 3){  // for serial table
                let list: SERIALBATCHADAPTER
                list = batchadapter[indexPath.row]
                let alert = UIAlertController(title: "Delete", message: "Do you want to delete this item?", preferredStyle: .alert)
                
                let okaction = UIAlertAction(title: "Yes", style: .default) { _ in
                    self.batchadapter.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    self.deleteerialbatch(lotid: list.lotid!, batch: "", serial: list.label!, type: self.origin)
                    self.setserialtable()
                    alert.dismiss(animated: true, completion: nil)
                }
                
                let noaction = UIAlertAction(title: "No", style: .destructive, handler: nil)
                alert.addAction(okaction)
                alert.addAction(noaction)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    var itemid,price,pname: String!
    
    func deleteinvline(itemid: String, date: String){
        var query = ""
        if (self.navigationItem.title! == "Load"){
            query = "delete from loading where itemid = '\(itemid)'"
        }else if (self.navigationItem.title! == "Unload"){
            query = "delete from Checkinitems where datetime = '\(date)' and itemid = '\(itemid)'"
        }
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting inv line for \(itemid)")
            return
        }else{
            setlist()
        }
    }
    
    var unloadingadapter = [LoadingAdapter]()
    
    @IBOutlet var prodtable: UITableView!
    //MARK:- update qty btns
    @IBOutlet var quantittyedft: UITextField!
    @IBOutlet var mainview: UIView!
    @IBAction func minusbtn(_ sender: UIButton) {
        if (self.quantittyedft.text!.count > 0 ){
            if (self.navigationItem.title! == "Load" && Int(self.quantittyedft.text!)! == 0){
            }else{
                self.quantittyedft.text = "\(Int(self.quantittyedft.text!)! - 1)"
            }
        }
    }
    @IBAction func addbutton(_ sender: UIButton) {
        if (self.quantittyedft.text!.count > 0){
            self.quantittyedft.text = "\(Int(self.quantittyedft.text!)! + 1)"
        }
    }
    @IBAction func done(_ sender: UIButton) {
        if (self.quantittyedft.text!.count > 0){
            if (self.navigationItem.title! == "Load"){
                self.isbtot = false
                self.updateqtynow(qty: self.quantittyedft.text!)
                self.mainview.isHidden = true
            }else if (self.navigationItem.title! == "Unload"){
                self.isbtot = false
                self.updateqtynow(qty: self.quantittyedft.text!)
            }
        }
    }
    
    var flag: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        self.setbg()
        //        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.setnav(title: self.navigationItem.title!)
        self.mainview.isHidden = true
        self.batchview.isHidden = true
        self.serialview.isHidden = true
        self.batchdropdown.text = ""
        self.serialdropdown.text = ""
        self.origin = AppDelegate.origin
        if (AppDelegate.setscanresult){
            self.setlist()
            self.updateqty(at: AppDelegate.sindex)
        }else{
            setlist()
        }
        
        self.batchdropdown.didSelect { (selection, id, index) in
            self.insertbatch(batch: selection)
        }
        self.serialdropdown.didSelect { (selection, id, index) in
            self.insertserial(serial: selection)
        }
        
        if (self.navigationItem.title! != "Load"){
            self.setbatchedt()
            self.settotedtqty()
            self.setserialqty()
        }
    }
    
    override func backbuttonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.navigationController?.setNavigationBarHidden(true, animated: true)
        prodtable.delegate = self
        prodtable.dataSource = self
    }
    
    func setlist(){
        var stmt1:OpaquePointer?
        
        self.unloadingadapter.removeAll()
        var query = ""
        if (self.navigationItem.title! == "Load"){
            query = "select id,itemname,qty,'-' as date,'-' as price from Loading"
        }else if (self.navigationItem.title! == "Unload"){
            query = "select a.*,'0' as price from Checkinitems a inner join itemmaster b on a.itemid = b.itemcode where a.datetime = '\(self.getdate(format: "yyyy-MM-dd"))'"
        }
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let itemname = String(cString: sqlite3_column_text(stmt1, 1))
            let qty = String(cString: sqlite3_column_text(stmt1, 2))
            let date = String(cString: sqlite3_column_text(stmt1, 3))
            let mrp = String(cString: sqlite3_column_text(stmt1, 4))
            
            flag = true
            self.unloadingadapter.append(LoadingAdapter(productname: itemname, qty: qty,date: date,price: mrp))
        } 
        self.prodtable.reloadData()
    }
    
    @IBAction func addbtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "UNLOADING", bundle: nil)
        let registrationVC = storyboard.instantiateViewController(withIdentifier: "ADDPRODUCTVC") as! SELECTCATEGORY
        registrationVC.navigationItem.title = self.navigationItem.title
        registrationVC.origin = self.origin
        self.navigationController?.pushViewController(registrationVC, animated: true)
    }
    
    @IBAction func donebtn(_ sender: Any) {
        if (flag){
            if (self.verifyqty()){
                if (origin == "Checkinitems"){
                    if (self.checkstockqty()){
                        self.do_done()
                    }else if (self.notitem.count > 0){
                        self.showToast(message: "The stock for \(self.notitem) was not loaded on the truck.")
                    }else if (self.vitem.count > 0){
                        self.showToast(message: "Not Enough Stock Available for \(self.vitem).")
                    }
                }else{
                    self.do_done()
                }
            }else if (self.vitem != ""){
                self.showToast(message: "Please check the Batch/Serial for \(self.vitem)")
            }else{
                self.showToast(message: "Please select the Batch/Serial on the order lines")
            }
        }else{
            self.showToast(message: "None Items selected!!!")
        }
    }
    
    func do_done(){
        if (AppDelegate.ntwrk > 0){
            self.showIndicator("Syncing data...", vc: self)
            self.gettoken()
        }else{
            self.showToast(message: "Internet connection required")
        }
    }
    
    var notitem = ""
    func checkstockqty() -> Bool{
        
        var stmt1:OpaquePointer?
        
        var flag = false
        notitem = ""
        vitem = ""
        
        let query = "select c.itemname,bs.qty,b.tqty,bs.batch,bs.serial from checkinitems a inner join batchserial bs on a.itemid = bs.lotid and bs.type = 'Checkinitems' left outer join (select itemid, netqty as tqty,batch,serial from truckstock) b inner join Itemmaster c on a.itemid = c.itemcode where a.itemid = b.itemid and CAST(bs.qty as INTEGER) > cast(b.tqty as INTEGER)  and c.isservice = 'false' and b.batch = bs.batch and b.serial = bs.serial "
        
        let recordcheck = "select b.itemname from Checkinitems a inner join itemmaster b on a.itemid = b.itemcode where a.itemid not in (select itemid from truckstock) and (b.isservice = 'false')"
        
        print("query --> \(query)")
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,recordcheck, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return flag
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            self.notitem = String(cString: sqlite3_column_text(stmt1, 0))
            flag = false
        }else{
            if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                print("error preparing get: \(errmsg)")
                return flag
            }
            if(sqlite3_step(stmt1) == SQLITE_ROW){
                self.vitem = String(cString: sqlite3_column_text(stmt1, 0))
                flag = false
            }else{
                flag = true
            }
        }
        
        return flag
    }
    
    var vitem = ""
    func verifyqty() -> Bool{
        
        var stmt1:OpaquePointer?
        var flag = false
        vitem = ""
        
        let query = "select a.itemname from \(self.origin) a left outer join (select lotid, sum(qty) as tqty,type from BatchSerial where type = '\(self.origin)' group by lotid) b inner join Itemmaster c on a.itemid = c.itemcode where a.itemid = b.lotid and CAST(a.qty as INTEGER) <> cast(b.tqty as INTEGER)"
        var recordcheck = ""
        if (origin == "Checkinitems"){
            recordcheck = "select * from Checkinitems a inner join itemmaster b on a.itemid = b.itemcode where a.datetime = '\(self.getdate(format: "yyyy-MM-dd"))' and a.itemid not in (select lotid from BatchSerial where type = 'Checkinitems') and (b.isbatch <> '0' or b.isserial <> '0')"
        }else if(origin == "loading"){
            recordcheck = "select * from loading a inner join itemmaster b on a.itemid = b.itemcode where a.itemid not in (select lotid from BatchSerial where type = 'loading') and (b.isbatch <> '0' or b.isserial <> '0')"
        }
        
        print("query --> \(query)")
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,recordcheck, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return flag
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            flag = false
        }else{
            if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                print("error preparing get: \(errmsg)")
                return flag
            }
            if(sqlite3_step(stmt1) == SQLITE_ROW){
                self.vitem = String(cString: sqlite3_column_text(stmt1, 0))
                flag = false
            }else{
                flag = true
            }
        }
        return flag
    }
    override func callback() {
        if (origin == "Checkinitems"){
            self.postunload()
        }else if(origin == "loading"){
            self.postload(acceptreject: -1)
        }
    }
    
    override func undone() {
        UserDefaults.standard.set(self.getdate(format: "yyyy-MM-dd"), forKey: "trkdate")
        self.hideindicator()
        let alert = UIAlertController(title: "Alert", message: "Unload data sent successfully", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: .destructive) { (action) in
            //            alert.dismiss(animated: true, completion: nil)
            self.gotohome()
        }
        alert.addAction(dismiss)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func unnot() {
        self.hideindicator()
        if (UserDefaults.standard.string(forKey: "loadnum") == "" || UserDefaults.standard.string(forKey: "loadnum") == nil){
            self.showToast(message: "No Load number found - Unable to sent Unload data")
        }else if (AppDelegate.loaderr.count > 0){
            self.showToast(message: AppDelegate.loaderr)
        }
        else{
            self.showToast(message: "Unable to sent Unload data due to API Error")
        }
    }
    
    override func unerr() {
        self.hideindicator()
        self.showToast(message: "Unable to sent Unload data due to Server Error")
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
        self.showToast(message: "Authentication Error")
    }
    
    func bqtytapped(at index: IndexPath) {
        let list : SERIALBATCHADAPTER
        list = batchadapter[index.row]
        let qty = list.qty!
        self.batchnum = list.label!
        self.quantittyedft.text = qty
        self.mainview.isHidden = false
    }
    var batchnum = ""
    
    func updateqty(at index: IndexPath) {
        print("index -- > \(index)")
        let list: LoadingAdapter
        list = unloadingadapter[index.row]
        print("tapped qty = \(list.qty!)")
        itemid = self.getitemidfromname(itemname: list.productname!)
        AppDelegate.sindex = index
        print("sindex -- > \(AppDelegate.sindex!)")
        print("tapped qty = \(list.qty!)")
        price = list.price!
        pname = list.productname!
        checkbatchserial()
        if (self.isbatch){
            self.serialview.isHidden = true
            self.mainview.isHidden = true
            self.batchview.isHidden = false
            self.totalbqty.text = list.qty!
            self.setbview(qty: list.qty!)
        }else if (self.isserial){
            self.batchview.isHidden = true
            self.mainview.isHidden = true
            self.serialview.isHidden = false
            self.totalsqty.text = list.qty!
            self.setsview(qty: list.qty!)
        }else{
            self.serialview.isHidden = true
            self.batchview.isHidden = true
            self.quantittyedft.text = list.qty!
            self.mainview.isHidden = false
        }
    }
    
    func setbview(qty: String){
        if (qty.contains("-")){
            self.batchdropdown.isHidden = true
            self.batchedt.isHidden = false
            self.batchenter.isHidden = false
        }else{
            self.batchscan.isHidden = false
            self.batchdropdown.isHidden = false
            self.batchedt.isHidden = true
            self.batchenter.isHidden = true
        }
        self.batchscan.isHidden = true
        self.batchdropdown.text = ""
        self.setbatchdropdown()
        self.setbatchtable()
        if (self.navigationItem.title! == "Load"){
            self.batchdropdown.isHidden = true
            self.batchedt.isHidden = false
            self.batchenter.isHidden = false
        }
    }
    func setsview(qty: String){
        if (qty.contains("-")){
            self.serialscan.isHidden = true
            self.serialdropdown.isHidden = true
            self.serialedt.isHidden = false
            self.serialenter.isHidden = false
        }else{
            self.serialscan.isHidden = false
            self.serialdropdown.isHidden = false
            self.serialedt.isHidden = true
            self.serialenter.isHidden = true
        }
        self.serialdropdown.text = ""
        self.setserialdropdown()
        self.setserialtable()
        if (self.navigationItem.title! == "Load"){
            self.serialdropdown.isHidden = true
            self.serialedt.isHidden = false
            self.serialenter.isHidden = false
        }
    }
    
    func setbatchdropdown(){
        
        var stmt1:OpaquePointer?
        self.batchdropdown.optionArray.removeAll()
        
        let query = "select batch from loading where itemid = '\(self.itemid!)' and batch not in (select batch from BatchSerial where lotid = '\(self.itemid!)' and type = '\(self.origin)')"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let batchno = String(cString: sqlite3_column_text(stmt1, 0))
            self.batchdropdown.optionArray.append(batchno)
        }
    }
    func setserialdropdown(){
        
        var stmt1:OpaquePointer?
        self.serialdropdown.optionArray.removeAll()
        
        let query = "select serial from loading where itemid = '\(self.itemid!)' and serial not in (select serial from BatchSerial where lotid = '\(self.itemid!)' and type = '\(self.origin)')"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let batchno = String(cString: sqlite3_column_text(stmt1, 0))
            self.serialdropdown.optionArray.append(batchno)
        }
    }
    
    func checkbatchserial(){
        var stmt1:OpaquePointer?
        
        let query = "SELECT isbatch,isserial from Itemmaster where itemcode = '\(self.itemid!)'"
        
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
    
    var isbatch: Bool = false
    var isserial: Bool = false
    @IBOutlet var batchscan: UIButton!
    
    @IBAction func batchscanbtn(_ sender: UIButton) {
        
    }
    
    @IBAction func batchenterbtn(_ sender: UIButton) {
        self.insertbatch(batch: self.batchedt.text!)
    }
    
    func insertbatch(batch: String){
        if (batch.count > 0){
            self.insertbatchserial(lotid: self.itemid!, batch: batch, serial: "", qty: "0", type: self.origin, post: "0")
            self.batchedt.text = ""
            self.setbatchtable()
        }else{
            self.showToast(message: "Enter Batch number to continue")
        }
    }
    
    var batchadapter = [SERIALBATCHADAPTER]()
    //    MARK:- SET BATCH TABLE
    func setbatchtable(){
        self.batchtable.delegate = self
        self.batchtable.dataSource = self
        self.batchadapter.removeAll()
        var stmt1:OpaquePointer?
        
        let query = "select batch,qty from batchserial where lotid = '\(self.itemid!)' and type = '\(self.origin)'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let lable = String(cString: sqlite3_column_text(stmt1, 0))
            let qty = String(cString: sqlite3_column_text(stmt1, 1))
            
            self.batchadapter.append(SERIALBATCHADAPTER(lotid: self.itemid!, label: lable, qty: qty))
        }
        print("batch adapter count -- > \(self.batchadapter.count)")
        self.batchtable.reloadData()
        self.setbatchdropdown()
    }
    //    MARK:- SET SERIAL TABLE
    func setserialtable(){
        self.serialtable.delegate = self
        self.serialtable.dataSource = self
        self.batchadapter.removeAll()
        var stmt1:OpaquePointer?
        
        
        let query = "select serial,qty from batchserial where lotid = '\(self.itemid!)' and type = '\(self.origin)'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        //Custorder(custid text,userid text, itemid text, qty text, date text, price text, totvalue text, status text,post text)
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            
            let lable = String(cString: sqlite3_column_text(stmt1, 0))
            let qty = String(cString: sqlite3_column_text(stmt1, 1))
            
            self.batchadapter.append(SERIALBATCHADAPTER(lotid: self.itemid!, label: lable, qty: qty))
        }
        print("serial adapter count -- > \(self.batchadapter.count)")
        self.serialtable.reloadData()
        self.setserialdropdown()
    }
    
    @IBAction func batchclose(_ sender: UIButton) {
        self.tapbatch()
    }
    @IBAction func serialclose(_ sender: UIButton) {
        self.tapserial()
    }
    @IBOutlet var serialenter: UIButton!
    @IBAction func serialenterbtn(_ sender: UIButton) {
        self.insertserial(serial: self.serialedt.text!)
    }
    
    func insertserial(serial: String){
        if (serial.count > 0){
            self.insertbatchserial(lotid: self.itemid!, batch: "", serial: serial, qty: "1", type: self.origin, post: "0")
            self.serialedt.text = ""
            self.setserialtable()
        }else{
            self.showToast(message: "Enter Serial number to continue")
        }
    }
    var origin = ""
    @IBAction func serialscanbtn(_ sender: UIButton) {
        let sb = UIStoryboard(name: "UNLOADING", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "UNLOADSCANVC") as! UNLOADINGSCANTABVC
        print("index -- > \(AppDelegate.sindex)")
        vc.sindex = AppDelegate.sindex
        vc.origin = self.origin
        vc.lotid = self.itemid!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBOutlet var serialscan: UIButton!
    @IBOutlet var serialedt: UITextField!
    @IBOutlet var serialdropdown: DropDown!
    @IBOutlet var batchenter: UIButton!
    @IBOutlet var batchedt: UITextField!
    @IBOutlet var totalsqty: UITextField!
    @IBOutlet var batchdropdown: DropDown!
    @IBOutlet var totalbqty: UITextField!
    @IBOutlet var batchview: UIView!
    @IBOutlet var batchtable: UITableView!
    @IBOutlet var serialview: UIView!
    @IBOutlet var serialtable: UITableView!
    
    @IBAction func totalbqtyminus(_ sender: UIButton) {
        if (self.totalbqty.text!.count > 0 ){
            if (self.navigationItem.title! == "Load" && Int(self.totalbqty.text!)! == 0){
            }else{
                self.totalbqty.text = "\(Int(self.totalbqty.text!)! - 1)"
            }
        }
    }
    
    @IBAction func totalbqtyplus(_ sender: Any) {
        if (self.totalbqty.text!.count > 0 ){
            self.totalbqty.text = "\(Int(self.totalbqty.text!)! + 1)"
        }
    }
    var isbtot = false
    @IBAction func batchtotalqtydone(_ sender: UIButton) {
        if (self.totalbqty.text!.count > 0){
            isbtot = true
            self.updateqtynow(qty: self.totalbqty.text!)
        }
    }
    
    @IBAction func totalsqtyminus(_ sender: UIButton) {
        
        if (self.totalsqty.text!.count > 0 ){
            if (self.navigationItem.title! == "Load" && Int(self.totalsqty.text!)! == 0){
            }else{
                self.totalsqty.text = "\(Int(self.totalsqty.text!)! - 1)"
            }
        }
    }
    
    @IBAction func totalsqtyplus(_ sender: UIButton) {
        if (self.totalsqty.text!.count > 0 ){
            self.totalsqty.text = "\(Int(self.totalsqty.text!)! + 1)"
        }
    }
    
    @IBAction func serrialtotalqtydone(_ sender: UIButton) {
        if (self.totalsqty.text!.count > 0){
            self.updateqtynow(qty: self.totalsqty.text!)
        }
    }
    @objc func tapbatch(){
        self.batchview.isHidden = true
    }
    @objc func tapserial(){
        self.serialview.isHidden = true
    }
    
    func updateqtynow(qty: String){
        if (qty.count > 0){
            if (isbatch){
                if (isbtot){
                    self.updatetotalqty(qty: qty, lotid: self.itemid!)
                    self.batchview.isHidden = true
                }else{
                    self.insertbatchserial(lotid: self.itemid!, batch: self.batchnum, serial: "", qty: qty, type: self.origin, post: "0")
                    self.mainview.isHidden = true
                    self.setbatchtable()
                }
            }else{
                self.updatetotalqty(qty: qty, lotid: self.itemid!)
                self.serialview.isHidden = true
            }
            print("qty inserted ---> \(qty)")
        }
    }
    
    func updatetotalqty(qty: String, lotid: String){
        if (self.navigationItem.title! == "Load"){
            self.updateloadqty(qty: qty, itemid: lotid)
        }else if (self.navigationItem.title! == "Unload"){
            self.insertcheckintable(itemid : lotid,itemname : pname, qty : qty,datetime : self.getdate(format: "yyyy-MM-dd"))
        }
        setlist()
        self.mainview.isHidden = true
    }
    
    func settotedtqty(){
        let toolbar = UIToolbar().minussign(mySelect : #selector(self.mySelect),minus: #selector(self.totqty_minus), controller: self)
        self.quantittyedft.inputAccessoryView = toolbar
    }
    
    @objc func totqty_minus(){
        if (self.quantittyedft.text!.count > 0 && Int(self.quantittyedft.text!)! != 0 ){
            self.quantittyedft.text = "\(Int(self.quantittyedft.text!)! * -1)"
        }
    }
    
    @objc func bqty_minus(){
        if (self.totalbqty.text!.count > 0 && Int(self.totalbqty.text!)! != 0 ){
            self.totalbqty.text = "\(Int(self.totalbqty.text!)! * -1)"
        }
    }
    
    @objc func sqty_minus(){
        if (self.totalsqty.text!.count > 0 && Int(self.totalsqty.text!)! != 0 ){
            self.totalsqty.text = "\(Int(self.totalsqty.text!)! * -1)"
        }
    }
    
    @objc func mySelect(){
        view.endEditing(true)
    }
    
    func setbatchedt(){
        let toolbar = UIToolbar().minussign(mySelect : #selector(self.mySelect),minus: #selector(self.bqty_minus), controller: self)
        self.totalbqty.inputAccessoryView = toolbar
    }
    
    func setserialqty(){
        let toolbar = UIToolbar().minussign(mySelect : #selector(self.mySelect),minus: #selector(self.sqty_minus), controller: self)
        self.totalsqty.inputAccessoryView = toolbar
    }
    
    
    
}
