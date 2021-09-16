//
//  STOCKTRVC.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 20/08/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import SQLite3

enum TransferStatus: Int{
    case Open = 0
    
    case Accepted = 1
    
    case Rejected = 2
}

class STOCKTRVC: BASEACTIVITY,UITableViewDelegate,UITableViewDataSource,TapQty,UITextFieldDelegate,batchqty {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView.tag == 1){
            return orderadapter.count
        }else{
            return batchadapter.count
        }
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
        let list: CUSTORDERADAPTER
        list = orderadapter[index.row]
        self.sindex = index
        print("sindex -- > \(self.sindex!)")
        print("tapped qty = \(list.qty!)")
        itemid = self.getitemidfromname(itemname: list.proddesc!)
        price = list.price!
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
            self.batchdropdown.isHidden = false
            self.batchedt.isHidden = true
            self.batchenter.isHidden = true
        }
        self.batchdropdown.text = ""
        self.setbatchdropdown()
        self.setbatchtable()
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
    }
    static var status : Int!
    func setbatchdropdown(){
        
        var stmt1:OpaquePointer?
        self.batchdropdown.optionArray.removeAll()
        
        let query = "select batch from loading where itemid = '\(self.itemid!)' and batch not in (select batch from BatchSerial where lotid = '\(self.itemid!)' and type = 'stocktr')"
        
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
        
        let query = "select serial from loading where itemid = '\(self.itemid!)' and serial not in (select serial from BatchSerial where lotid = '\(self.itemid!)' and type = 'stocktr') and serial not in (select serial from Unloading where itemid = '\(self.itemid!)')"
        
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        return string.rangeOfCharacter(from: invalidCharacters) == nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (tableView.tag == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ordercell", for: indexPath) as! CUSTORDERCELL
            
            let list: CUSTORDERADAPTER
            list = orderadapter[indexPath.row]
            
            cell.proddesc.text = list.proddesc
            cell.qty.text = list.qty
            cell.price.text = "$" + list.price!
            cell.delegate = self
            cell.index = indexPath
            
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
                let list: CUSTORDERADAPTER
                list = orderadapter[indexPath.row]
            let alert = UIAlertController(title: "Delete", message: "Do you want to delete this item?", preferredStyle: .alert)
            
            let okaction = UIAlertAction(title: "Yes", style: .default) { _ in
                self.orderadapter.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.deleteinvline(itemid: self.getitemidfromname(itemname: list.proddesc!), date: list.date!)
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
                self.deleteerialbatch(lotid: list.lotid!, batch: list.label!, serial: "", type: "stocktr")
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
                self.deleteerialbatch(lotid: list.lotid!, batch: "", serial: list.label!, type: "stocktr")
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
    var isbatch: Bool = false
    var isserial: Bool = false
    func updateqtynow(qty: String){
        if (qty.count > 0){
            if (isbatch){
                if (isbtot){
                    self.updatetotalqty(qty: qty, lotid: itemid!)
                    self.batchview.isHidden = true
                }else{
                    self.insertbatchserial(lotid: itemid!, batch: self.batchnum, serial: "", qty: qty, type: "stocktr", post: "0")
                    self.mainview.isHidden = true
                    self.setbatchtable()
                }
            }else{
                self.updatetotalqty(qty: qty, lotid: itemid!)
                self.serialview.isHidden = true
            }
            print("qty inserted ---> \(qty)")
        }
    }
    static var uid: String!
    func updatetotalqty(qty: String, lotid: String){
        self.updatestockqty(qty: qty, uid: STOCKTRVC.uid!, itemid: lotid)
        setlist()
        self.mainview.isHidden = true
    }
    var sindex : IndexPath!
    var refreshControl = UIRefreshControl()
    override func viewWillAppear(_ animated: Bool) {
        setlist()
        self.setnav(title: self.navigationItem.title!)
        self.mainview.isHidden = true
        self.batchview.isHidden = true
        self.serialview.isHidden = true
        self.navigationItem.leftBarButtonItem = self.getbackbarbutton()
        
        if (AppDelegate.setscanresult){
            self.sindex = AppDelegate.sindex
            self.setlist()
            self.updateqty(at: self.sindex)
        }else{
            setlist()
        }
        
        self.batchdropdown.didSelect { (selection, id, index) in
            self.insertbatch(batch: selection)
        }
        self.serialdropdown.didSelect { (selection, id, index) in
            self.insertserial(serial: selection)
        }
        
        self.settotedtqty()
        self.setbatchedt()
        self.setserialqty()
    }
    
    var api = -1
    override func callback() {
        refreshControl.endRefreshing()
        self.showIndicator("Syncing...", vc: self)
        STOCKTRVC.status = -1
        if (self.api == 1){
            self.getTruckTransferStatus()
        }else if(self.api == 2){
            let code = self.trarr[self.trwith.selectedIndex!]
            self.posttransferdetails(truckid: code)
        }
    }
    
    override func sdgot(id: String) {
        self.hideindicator()
        self.showmsg(msg: "Transfer details send successfully")
        self.gotohome()
    }
    
    override func sdnot() {
        self.hideindicator()
        self.showToast(message: "Transfer details not send due to API error")
    }
    
    override func sderr() {
        self.hideindicator()
        self.showToast(message: "Transfer details not send due to Server error")
    }
    
    override func backbuttonPressed() {
        self.gotohome()
    }
    
    @IBOutlet var mainview: UIView!
    @IBOutlet weak var orderttable: UITableView!
    @IBOutlet var quantittyedft: UITextField!
    @IBOutlet var trwith: DropDown!
    
    @IBAction func minusbtn(_ sender: UIButton) {
        if (self.quantittyedft.text!.count > 0){
            self.quantittyedft.text = "\(Int(self.quantittyedft.text!)! - 1)"
        }
    }
    @IBAction func addbutton(_ sender: UIButton) {
        if (self.quantittyedft.text!.count > 0){
            self.quantittyedft.text = "\(Int(self.quantittyedft.text!)! + 1)"
        }
    }
    @IBAction func done(_ sender: UIButton) {
        //        if (self.quantittyedft.text!.count > 0){
        //            self.insertstocktransfer(userid: "Test", itemid: itemid!, qty: quantittyedft.text!, date: self.getdate(format: "yyyy-MM-dd"), price: price, status: "0")
        //            setlist()
        //            self.mainview.isHidden = true
        //        }
        if (self.quantittyedft.text!.count > 0){
            self.isbtot = false
            self.updateqtynow(qty: self.quantittyedft.text!)
        }
    }
    
    @IBAction func addbtn(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "UNLOADING", bundle: nil)
        let registrationVC = storyboard.instantiateViewController(withIdentifier: "ADDPRODUCTVC") as! SELECTCATEGORY
        registrationVC.navigationItem.title = "Products"
        registrationVC.origin = "stocktr"
        self.navigationController?.pushViewController(registrationVC, animated: true)
    }
    
//    MARK:- VALIDATE HERE
    
    @IBAction func donebtn(_ sender: UIBarButtonItem) {
        if (self.trwith.text!.count == 0){
            self.showToast(message: "Enter Transfer with")
        }else if (self.orderadapter.count == 0){
            self.showToast(message: "Enter the Products to Transfer")
        }else if (!self.isitems){
            self.showToast(message: "No items to transfer")
        }else if(self.verifyqty()){
            if (self.checkstockqty()){
                let code = self.trarr[self.trwith.selectedIndex!]
                self.updatetrid(uid: STOCKTRVC.uid!, trkid: code)
                if (AppDelegate.ntwrk > 0){
                    self.showIndicator("Connecting...", vc: self)
                    self.api = 2
                    self.gettoken()
                }else{
                    self.showToast(message: "Internet connection required")
                }
            }else if (self.notitem.count > 0){
                self.showToast(message: "The stock for \(self.notitem) was not loaded on the truck.")
            }else if (self.vitem.count > 0){
                self.showToast(message: "Not Enough Stock Available for \(self.vitem).")
            }
        }else if (self.vitem != ""){
            self.showToast(message: "Please check the Batch/Serial for \(self.vitem)")
        }else{
            self.showToast(message: "Please select the Batch/Serial on the order lines")
        }
    }
    
    var notitem = ""
    func checkstockqty() -> Bool{

        var stmt1:OpaquePointer?
                
        var flag = false
        notitem = ""
        vitem = ""
        
        let query = "select c.itemname,bs.qty,b.tqty,bs.batch,bs.serial  from StockTransfer a inner join batchserial bs on a.itemid = bs.lotid and bs.type = 'stocktr' left outer join (select itemid, netqty as tqty,batch,serial from truckstock) b inner join Itemmaster c on a.itemid = c.itemcode where a.itemid = b.itemid and CAST(bs.qty as INTEGER) > cast(b.tqty as INTEGER) and a.uid = '\(STOCKTRVC.uid!)' and c.isservice = 'false' and b.batch = bs.batch and b.serial = bs.serial"
        
        let recordcheck = "select b.itemname from StockTransfer a inner join itemmaster b on a.itemid = b.itemcode where a.uid = '\(STOCKTRVC.uid!)' and a.itemid not in (select itemid from truckstock) and (b.isservice = 'false')"
                          
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
        
        let query = "select c.itemname from StockTransfer a left OUTER join (select lotid, sum(qty) as tqty from BatchSerial where type = 'stocktr' group by lotid) b inner join Itemmaster c on a.itemid = c.itemcode where a.itemid = b.lotid and CAST(a.qty as INTEGER) > cast(b.tqty as INTEGER) and a.uid = '\(STOCKTRVC.uid!)'"
        
        let recordcheck = "select * from StockTransfer a inner join itemmaster b on a.itemid = b.itemcode where a.uid = '\(STOCKTRVC.uid!)' and a.itemid not in (select lotid from BatchSerial where type = 'stocktr') and (b.isbatch <> '0' or b.isserial <> '0')"
                          
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
    
    var trarr = [String]()
    var orderadapter = [CUSTORDERADAPTER]()
    var itemid,price: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.orderttable.delegate = self
        self.orderttable.dataSource = self
        let tapqty = UITapGestureRecognizer(target: self, action: #selector(self.tapmain))
        mainview.addGestureRecognizer(tapqty)
        self.quantittyedft.delegate = self
        STOCKTRVC.uid = self.getuid()
        self.trwith.isSearchEnable = false
        settruckiddropdown()
        self.deletetable(tbl: "StockTransfer")
        self.deletesbatchtbl(type: "stocktr",post : "0")
    }
    
    func settruckiddropdown(){
        var stmt1:OpaquePointer?
        self.trarr.removeAll()
        self.trwith.optionArray.removeAll()
        
        let query = "select code , description from TruckMaster"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        //Custorder(custid text,userid text, itemid text, qty text, date text, price text, totvalue text, status text,post text)
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let code = String(cString: sqlite3_column_text(stmt1, 0))
            let name = String(cString: sqlite3_column_text(stmt1, 1))
            self.trarr.append(code)
            self.trwith.optionArray.append(name)
        }
    }
    
    @objc func tapmain(){
        self.mainview.isHidden = true
    }
    @objc func tapbatch(){
        self.batchview.isHidden = true
    }
    @objc func tapserial(){
        self.serialview.isHidden = true
    }
    
    func deleteinvline(itemid: String, date: String){
        let query = "delete from StockTransfer where itemid='\(itemid)' and uid = '\(STOCKTRVC.uid!)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting inv line for \(itemid)")
            return
        }else{
            setlist()
        }
    }
    var isitems = false
    func setlist(){
        var stmt1:OpaquePointer?
        
        self.orderadapter.removeAll()
        
        let query = "select a.qty,b.itemname from StockTransfer a inner join Itemmaster b on a.itemid = b.itemcode where a.uid = '\(STOCKTRVC.uid!)'"
        
        print("query -> \(query)")
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        //trkid text, itemid text, qty text, date text, uid text,post
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let itemname = String(cString: sqlite3_column_text(stmt1, 1))
            let qty = String(cString: sqlite3_column_text(stmt1, 0))
            
            orderadapter.append(CUSTORDERADAPTER(proddesc: itemname, qty: qty, price: "", date: "", itemch: "", itemdis: "", itemid: ""))
            isitems = true
        }
        self.orderttable.reloadData()
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
            self.totalbqty.text = "\(Int(self.totalbqty.text!)! - 1)"
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
            self.totalsqty.text = "\(Int(self.totalsqty.text!)! - 1)"
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
    
    @IBAction func batchenterbtn(_ sender: UIButton) {
        self.insertbatch(batch: self.batchedt.text!)
    }
    
    func insertbatch(batch: String){
        if (batch.count > 0){
            self.insertbatchserial(lotid: itemid, batch: batch, serial: "", qty: "0", type: "stocktr", post: "0")
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
        
        let query = "select batch,qty from batchserial where lotid = '\(itemid!)' and type = 'stocktr'"
        
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
        
        let query = "select serial,qty from batchserial where lotid = '\(itemid!)' and type = 'stocktr'"
        
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
            self.insertbatchserial(lotid: itemid!, batch: "", serial: serial, qty: "1", type: "stocktr", post: "0")
            self.serialedt.text = ""
            self.setserialtable()
        }else{
            self.showToast(message: "Enter Serial number to continue")
        }
    }
    
    @IBAction func serialscanbtn(_ sender: UIButton) {
        let sb = UIStoryboard(name: "UNLOADING", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "UNLOADSCANVC") as! UNLOADINGSCANTABVC
        print("index -- > \(sindex)")
        vc.sindex = self.sindex
        vc.origin = "stocktr"
        vc.lotid = self.itemid!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func settotedtqty(){
        let toolbar = UIToolbar().minussign(mySelect : #selector(self.mySelect),minus: #selector(self.totqty_minus), controller: self)
        self.quantittyedft.inputAccessoryView = toolbar
    }
    
    @objc func totqty_minus(){
        if (self.quantittyedft.text!.count > 0 && Int(self.quantittyedft.text!)! != 0){
            self.quantittyedft.text = "\(Int(self.quantittyedft.text!)! * -1)"
        }
    }
    
    @objc func bqty_minus(){
        if (self.totalbqty.text!.count > 0 && Int(self.totalbqty.text!)! != 0){
            self.totalbqty.text = "\(Int(self.totalbqty.text!)! * -1)"
        }
    }
    
    @objc func sqty_minus(){
        if (self.totalsqty.text!.count > 0 && Int(self.totalsqty.text!)! != 0){
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
