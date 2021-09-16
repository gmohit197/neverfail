
//
//  CUSTORDERVC.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 25/06/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import SQLite3

class CUSTORDERVC: BASEACTIVITY,UITableViewDelegate,UITableViewDataSource,TapQty,UITextFieldDelegate,batchqty {
    
    func bqtytapped(at index: IndexPath) {
        let list : SERIALBATCHADAPTER
        list = batchadapter[index.row]
        let qty = list.qty!
        self.batchnum = list.label!
        self.quantittyedft.text = qty
        self.mainview.isHidden = false
    }
    
    func updateqty(at index: IndexPath) {
        let id = self.getlastactivityid(orderid: CUSTORDERVC.custid!)
        if (id == NoDelReason.cancelOrder.rawValue || id == NoDelReason.delivered.rawValue || id == NoDelReason.reschedule.rawValue){
        }else{
            print("index -- > \(index)")
            let list: CUSTORDERADAPTER
            list = orderadapter[index.row]
            self.sindex = index
            print("sindex -- > \(self.sindex)")
            print("tapped qty = \(list.qty!)")
            itemid = self.getitemidfromname(itemname: list.proddesc!)
//            self.lotid = self.getlotid(orderid: self.orderid, itemid: itemid)
            self.lotid = list.itemid!
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
    
    func setbatchdropdown(){
        
        var stmt1:OpaquePointer?
        self.batchdropdown.optionArray.removeAll()
        
        let query = "select batch from loading where itemid = '\(self.itemid!)' and batch not in (select batch from BatchSerial where lotid = '\(self.lotid)')"
        
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
        
        let query = "select serial from loading where itemid = '\(self.itemid!)' and serial not in (select serial from BatchSerial where lotid = '\(self.lotid)') and serial not in (select serial from Unloading where itemid = '\(self.itemid!)')"
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView.tag == 1){
            return orderadapter.count
        }else if (tableView.tag == 4){
            return bsadapter.count
        }else{
            return batchadapter.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = self.getlastactivityid(orderid: CUSTORDERVC.custid!)
        if (id == NoDelReason.delivered.rawValue || id == NoDelReason.reschedule.rawValue || id == NoDelReason.skip.rawValue){
            if (tableView.tag == 1){
                let list: CUSTORDERADAPTER
                list = orderadapter[indexPath.row]
                
                let itemid = self.getitemidfromname(itemname: list.proddesc!)
                self.itemid = itemid
                self.checkbatchserial()
                if (isbatch || isserial){
                    self.lotid =  list.itemid! //self.getlotid(orderid: CUSTORDERVC.custid!, itemid: itemid)
                    self.setbatchtable(lotid: self.lotid)
                }
            }
        }        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        return string.rangeOfCharacter(from: invalidCharacters) == nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        var cell : UITableViewCell
        if (tableView.tag == 1){   // for order table
            let cell = tableView.dequeueReusableCell(withIdentifier: "ordercell", for: indexPath) as! CUSTORDERCELL
            
            let list: CUSTORDERADAPTER
            list = orderadapter[indexPath.row]
            
            cell.proddesc.text = list.proddesc
            cell.qty.text = list.qty
            cell.price.text = "$" + list.price!
            cell.delegate = self
            cell.index = indexPath
            cell.itchlbl.text = list.itemch!
            cell.itdislbl.text = list.itemdis!
            
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
        }else if (tableView.tag == 3){  // for serial table
            let cell = tableView.dequeueReusableCell(withIdentifier: "scell", for: indexPath) as! SERIALCELL
            
            let list: SERIALBATCHADAPTER
            list = batchadapter[indexPath.row]
            
            cell.seriallbl.text = list.label
            cell.sqtylbl.text = list.qty
            //            cell.delegate = self
            
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let id  = self.getlastactivityid(orderid: CUSTORDERVC.custid!)
        if (id != NoDelReason.delivered.rawValue && id != NoDelReason.cancelOrder.rawValue){
            return true
        }else{
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            if (tableView.tag == 1){   // for order table
                let list: CUSTORDERADAPTER
                list = orderadapter[indexPath.row]
                let alert = UIAlertController(title: "Delete", message: "Do you want to delete this item?", preferredStyle: .alert)
                
                let okaction = UIAlertAction(title: "Yes", style: .default) { _ in
                    self.orderadapter.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
//                    let itemid = self.getitemidfromname(itemname: list.proddesc!)
//                    let lotid = self.getlotid(orderid: self.orderid, itemid: itemid)
                    let lotid = list.itemid!
                    self.deleteinvline(lotid: lotid)
                    self.deletebatchitems(lotid: lotid, type: "custorder")
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
                    self.deleteerialbatch(lotid: list.lotid!, batch: list.label!, serial: "", type: "custorder")
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
                    self.deleteerialbatch(lotid: list.lotid!, batch: "", serial: list.label!, type: "custorder")
                    self.setserialtable()
                    alert.dismiss(animated: true, completion: nil)
                }
                
                let noaction = UIAlertAction(title: "No", style: .cancel, handler: nil)
                alert.addAction(okaction)
                alert.addAction(noaction)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    var setscanresult = false
    var sindex : IndexPath!
    var orderadapter = [CUSTORDERADAPTER]()
    var itemid,price: String!
    @IBOutlet weak var invoicedesc: UILabel!
    @IBOutlet weak var orderttable: UITableView!
    @IBOutlet weak var addbtn: UIButton!
    @IBOutlet weak var subtotal: UILabel!
    @IBOutlet weak var gst: UILabel!
    @IBOutlet weak var invoicetotal: UILabel!
    @IBOutlet var quantittyedft: UITextField!
    @IBOutlet var batchscan: UIButton!
    
    @IBAction func batchscanbtn(_ sender: UIButton) {
        
    }
    
    @IBAction func batchenterbtn(_ sender: UIButton) {
        self.insertbatch(batch: self.batchedt.text!)
    }
    
    func insertbatch(batch: String){
//        self.lotid = self.getlotid(orderid: self.orderid, itemid: itemid)
        if (batch.count > 0){
            self.insertbatchserial(lotid: self.lotid, batch: batch, serial: "", qty: "0", type: "custorder", post: "0")
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
        
        let query = "select batch,qty from batchserial where lotid = '\(self.lotid)'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let lable = String(cString: sqlite3_column_text(stmt1, 0))
            let qty = String(cString: sqlite3_column_text(stmt1, 1))
            
            self.batchadapter.append(SERIALBATCHADAPTER(lotid: self.lotid, label: lable, qty: qty))
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
        
        let query = "select serial,qty from batchserial where lotid = '\(self.lotid)'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        //Custorder(custid text,userid text, itemid text, qty text, date text, price text, totvalue text, status text,post text)
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let lable = String(cString: sqlite3_column_text(stmt1, 0))
            let qty = String(cString: sqlite3_column_text(stmt1, 1))
            
            self.batchadapter.append(SERIALBATCHADAPTER(lotid: self.lotid, label: lable, qty: qty))
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
//        self.lotid = self.getlotid(orderid: self.orderid, itemid: itemid)
        if (serial.count > 0){
            var qty = 1
            if (!self.serialedt.isHidden){
                qty = -1
            }
            self.insertbatchserial(lotid: self.lotid, batch: "", serial: serial, qty: "\(qty)", type: "custorder", post: "0")
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
        vc.origin = "BS"
        vc.lotid = self.lotid
        self.navigationController?.pushViewController(vc, animated: true)
    }
    var bsadapter = [SERIALBATCHADAPTER]()
    func setbatchtable(lotid: String){
        
        self.bstable.delegate = self
        self.bstable.dataSource = self
        self.bsadapter.removeAll()
        var stmt1: OpaquePointer?
        var query = ""
        
        if (self.isbatch){
            query = "select batch,cast(qty as Int) from batchserial where lotid = '\(lotid)'"
            self.titlelbl.text = "Batch Details"
        }else if (self.isserial){
            query = "select serial,cast(qty as Int) from batchserial where lotid = '\(lotid)'"
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
    
    func setrview(){
        self.revenueview.isHidden = false
        self.setrevenuedropdown()
        self.setcathrigedropdown()
    }
    var revcode = [String]()
    var itemarr = [String]()
    func setrevenuedropdown(){
        self.revenuedropdown.isSearchEnable = false
        self.revenuedropdown.optionArray.removeAll()
        self.revcode.removeAll()
        var stmt1:OpaquePointer?
        
        let query = "select code,description from RevenueSchedule"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let code = String(cString: sqlite3_column_text(stmt1, 0))
            let description = String(cString: sqlite3_column_text(stmt1, 1))
            
            revcode.append(code)
            self.revenuedropdown.optionArray.append(description)
        }
    }
    
    func setcathrigedropdown(){
        self.cathrigedropdown.isSearchEnable = false
        self.cathrigedropdown.optionArray.removeAll()
        self.itemarr.removeAll()
        var stmt1:OpaquePointer?
        
        if (self.getitemtype() == "13"){
            let query = "select itemcode,itemname from Itemmaster where itemtype = '12'"
            
            if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                print("error preparing get: \(errmsg)")
                return
            }
            while(sqlite3_step(stmt1) == SQLITE_ROW){
                let code = String(cString: sqlite3_column_text(stmt1, 0))
                let name = String(cString: sqlite3_column_text(stmt1, 1))
                
                itemarr.append(code)
                self.cathrigedropdown.optionArray.append(name)
            }
        }
    }
    
    func getitemtype()-> String{
        var stmt1:OpaquePointer?
        var type = ""
        let fquery = "select itemtype from Itemmaster where itemcode = '\(itemid!)'"
        if  sqlite3_prepare_v2(Databaseconnection.dbs,fquery, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return type
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            type = String(cString: sqlite3_column_text(stmt1, 0))
        }
        return type
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
    
    func validaterevenue()-> Bool{
        var flag = true
        if (revenuedropdown.text?.count == 0){
            flag = false
            self.showToast(message: "Select Revenue to continue")
        }else if (self.getitemtype() == "13" && self.cathrigedropdown.text?.count == 0){
            flag = false
            self.showToast(message: "Select Catridge to continue")
        }
        return flag
    }
    
    
    @IBOutlet var revenuedropdown: DropDown!
    @IBOutlet var cathrigedropdown: DropDown!
    
    @IBOutlet var revenueview: UIView!
    @IBAction func revenuedone(_ sender: UIButton) {
        if (self.validaterevenue()){
            self.updaterevsch(lotid: lotid, revsch: self.revenuedropdown.text!, catitem: self.cathrigedropdown.text!)
            self.revenueview.isHidden = true
            self.revenuedropdown.text = ""
            self.cathrigedropdown.text = ""
        }
    }
    @IBOutlet var revenue: UIButton!
    @IBAction func revenuebtn(_ sender: UIButton) {
        self.setrview()
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
    @IBOutlet var chvallbl: UILabel!
    @IBOutlet var chgrplbl: UILabel!
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
    
    override func viewWillAppear(_ animated: Bool) {
        updateheader()
        self.setnav(title: self.navigationItem.title!)
        self.mainview.isHidden = true
        self.batchview.isHidden = true
        self.serialview.isHidden = true
        self.revenueview.isHidden = true
        self.gst.text = "0"
        self.invoicetotal.text = "0"
        self.subtotal.text = "0"
        self.chgrplbl.text = ""
        self.chvallbl.text = ""
        
        if (setscanresult){
            self.updateheader()
            self.setlist()
            self.updateqty(at: self.sindex)
        }else{
            self.updateheader()
            setlist()
        }
        
        self.batchdropdown.didSelect { (selection, id, index) in
            self.insertbatch(batch: selection)
        }
        self.serialdropdown.didSelect { (selection, id, index) in
            self.insertserial(serial: selection)
        }
        self.batchserialview.isHidden = true
        
        self.settotedtqty()
        self.setbatchedt()
        self.setserialqty()
    }
    
    static var custchgrp: String = ""
    static var custmod: String = ""
    static var custmodgrp: String = ""
    static var pomandate: String = ""
    var chcode: String = ""
    var orderid: String = ""
    var itemchgrp: String = ""
    var lotid: String = ""
    var orderdate: String = ""
    static var pricegrp: String?
    static var discountgrp: String?
    var gstvalue: String = ""
    var subtotalvalue: String = ""
    var chvalue: String  = ""
    static var custtaxgrp: String?
    var isbatch: Bool = false
    var isserial: Bool = false
    
    func updateheader(){
        
        var stmt1:OpaquePointer?
        
        let query = "select date,custpricegrp,custdisgrp,custid,custchgrp,custordrchcode,custordernum,custtaxgrp,date,custmod,custmodgrp,pomandate from CustorderHeader where custordernum =  '\(CUSTORDERVC.custid!)'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            let date = String(cString: sqlite3_column_text(stmt1, 0))
            let pricegrp = String(cString: sqlite3_column_text(stmt1, 1))
            let disgrp = String(cString: sqlite3_column_text(stmt1, 2))
            let custid = String(cString: sqlite3_column_text(stmt1, 3))
            let chgrp = String(cString: sqlite3_column_text(stmt1, 4))
            let chcode = String(cString: sqlite3_column_text(stmt1, 5))
            let orderid = String(cString: sqlite3_column_text(stmt1, 6))
            let custtaxgrp = String(cString: sqlite3_column_text(stmt1, 7))
            let custmod = String(cString: sqlite3_column_text(stmt1, 9))
            let custmodgrp = String(cString: sqlite3_column_text(stmt1, 10))
            let poman = String(cString: sqlite3_column_text(stmt1, 11))
            
            CUSTORDERVC.orderdate = date
            CUSTORDERVC.pricegrp = pricegrp
            CUSTORDERVC.discountgrp = disgrp
            CUSTOMERINFOVC.custid = custid
            self.chcode = chcode
            CUSTORDERVC.custchgrp = chgrp
            self.orderid = orderid
            CUSTORDERVC.custtaxgrp = custtaxgrp
            
            CUSTORDERVC.custmod = custmod
            CUSTORDERVC.custmodgrp = custmodgrp
            CUSTORDERVC.pomandate = poman
        }
        
        //        self.updatechargesheader(custid: self.customerid, custchgrp: self.custchgrp, chcode: self.chcode, orderid: self.orderid)
    }
    
    public static var custid: String?
    public static var orderdate: String?
    public static var contid: String? = ""
    var batchnum = ""
    @IBAction func closebtn(_ sender: UIButton) {
        self.batchserialview.isHidden = true
    }
    
    @IBOutlet var titlelbl: UILabel!
    @IBOutlet var bstable: UITableView!
    @IBOutlet var closebtn: UIButton!
    @IBOutlet var batchserialview: UIView!
    @IBOutlet var mainview: UIView!
    @IBAction func minusbtn(_ sender: UIButton) {
//        if (isbatch){
            if (self.quantittyedft.text!.count > 0){
                self.quantittyedft.text = "\(Int(self.quantittyedft.text!)! - 1)"
            }
//        }else{
//            if (self.quantittyedft.text!.count > 0 && self.quantittyedft.text != "0"){
//                self.quantittyedft.text = "\(Int(self.quantittyedft.text!)! - 1)"
//            }
//        }
    }
    @IBAction func addbutton(_ sender: UIButton) {
        if (self.quantittyedft.text!.count > 0){
            print("qty --> \(self.quantittyedft.text!)")
            self.quantittyedft.text = "\(Int(self.quantittyedft.text!)! + 1)"
        }
    }
    @IBAction func done(_ sender: UIButton) {
        if (self.quantittyedft.text!.count > 0){
            self.isbtot = false
            self.updateqtynow(qty: self.quantittyedft.text!)
        }
        self.mySelect()
    }
    
    func updateqtynow(qty: String){
        if (qty.count > 0){
//            self.lotid = self.getlotid(orderid: self.orderid, itemid: itemid)
            if (isbatch){
                if (isbtot){
                    self.updatetotalqty(qty: qty, lotid: self.lotid)
                    self.batchview.isHidden = true
                }else{
                    self.insertbatchserial(lotid: self.lotid, batch: self.batchnum, serial: "", qty: qty, type: "custorder", post: "0")
                    self.mainview.isHidden = true
                    self.setbatchtable()
                }
            }else{
                self.updatetotalqty(qty: qty, lotid: self.lotid)
                self.serialview.isHidden = true
            }
            print("qty inserted ---> \(qty)")
        }
    }
    
    func updatetotalqty(qty: String, lotid: String){
        self.updateorderqty(lotid: lotid, qty: qty)
        self.itemchgrp = self.getitemchgrp(orderid: self.orderid, itemid: itemid)
        
        self.updateprice(itemid: itemid, orderdate: self.orderdate, custid: CUSTOMERINFOVC.custid, pricegroup: CUSTORDERVC.pricegrp!, orderid: self.orderid)
        self.updatediscount(itemid: itemid, custid: CUSTOMERINFOVC.custid, discountgrp: CUSTORDERVC.discountgrp!, orderid: self.orderid)
        self.updatelineamt(orderid: self.lotid, itemid: itemid)
        self.updatetaxline(itemid: itemid, orderid: self.orderid, lotid: self.lotid)
        self.updatechargeline(itemid: itemid, orderid: self.orderid, lotid: self.lotid, custid: CUSTOMERINFOVC.custid, custchgrp: CUSTORDERVC.custchgrp, itemchgrp: self.itemchgrp)
        
        setlist()
        self.mainview.isHidden = true
    }
    //    MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        print("customer =========>\(CUSTORDERVC.custid!)")
        
        self.orderttable.delegate = self
        self.orderttable.dataSource = self
        
        let tapqty = UITapGestureRecognizer(target: self, action: #selector(self.tapmain))
        mainview.addGestureRecognizer(tapqty)
        
        let tapr = UITapGestureRecognizer(target: self, action: #selector(self.taprev))
        revenueview.addGestureRecognizer(tapr)
        
        self.quantittyedft.delegate = self
        
        let id = self.getlastactivityid(orderid: CUSTORDERVC.custid!)
        if (id == NoDelReason.delivered.rawValue || id == NoDelReason.reschedule.rawValue || id == NoDelReason.skip.rawValue){
            self.navigationItem.rightBarButtonItem = nil
            self.addbtn.isHidden = true
        }else{
            self.navigationItem.rightBarButtonItem = getbarbutton()
            self.addbtn.isHidden = false
        }
        
        self.navigationItem.leftBarButtonItem = self.getbackbarbutton()
        
    }
    
    override func backbuttonPressed() {
        self.gotohome()
    }
    
    @objc func tapmain(){
        self.mainview.isHidden = true
    }
    @objc func taprev(){
        self.revenueview.isHidden = true
    }
    @objc func tapbatch(){
        self.batchview.isHidden = true
    }
    @objc func tapserial(){
        self.serialview.isHidden = true
    }
    
    @objc func tapEdit(recognizer: UITapGestureRecognizer)  {
        if recognizer.state == UIGestureRecognizer.State.ended {
            let tapLocation = recognizer.location(in: self.orderttable)
            if let tapIndexPath = self.orderttable.indexPathForRow(at: tapLocation) {
                if let tappedCell = self.orderttable.cellForRow(at: tapIndexPath) as? CUSTORDERCELL {
                    print("cell tapped ====> \(tappedCell.proddesc.text)")
                    let itemname = tappedCell.proddesc.text!
                    let itemid = self.getitemidfromname(itemname: itemname)
                    
                    let list: CUSTORDERADAPTER
                    list = orderadapter[tapIndexPath.row]
                    
                    if (itemid != ""){
                        let alert = UIAlertController(title: "Update Invoice Line", message: "Select the action you would like to complete for \(itemname)", preferredStyle: .alert)
                        
                        let change = UIAlertAction(title: "Change", style: .default) { (_) in
                            alert.dismiss(animated: true) {
                                let storyb = UIStoryboard(name: "UNLOADING", bundle: nil)
                                let next = storyb.instantiateViewController(withIdentifier: "ENTERQTYVC") as! ENTERQUANTITYVC
                                next.itemid = itemid
                                next.navigationItem.title = "Products"
                                self.navigationController?.pushViewController(next, animated: true)
                            }
                        }
                        let delete = UIAlertAction(title: "Delete", style: .default) { (_) in
                            alert.dismiss(animated: true) {
                            }
                        }
                        
                        alert.addAction(change)
                        alert.addAction(delete)
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    override func buttonPressed() {
        self.push(storybId: "RESQUENCING", vcId: "ORDERDELNC", vc: self)
    }
    
    func refreshtotal(){
        var stmt1:OpaquePointer?
        
        let query = "select ( (select ifnull(sum ( cast (totval as real) ),'0') from CustorderLine where custordernum = '\(self.orderid)') + (select ifnull (sum ( cast ( chamt as real ) ) ,'0') as taxamt from CustItemCharge where lotid in (select lotid from CustorderLine where custordernum = '\(self.orderid)')) ) as subtotal , ((select ifnull(sum ( cast (taxamt as real ) ) ,'0') as taxamt from CustItemTax where lotid in (select lotid from CustorderLine where custordernum = '\(self.orderid)')) + (select custorderchtax from CustorderHeader where custordernum = '\(self.orderid)')) as gst "
        
        
        print("query --> \(query)")
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            self.subtotalvalue = String(cString: sqlite3_column_text(stmt1, 0))
            self.gstvalue = String(cString: sqlite3_column_text(stmt1, 1))
            //                    let invtotal = String(cString: sqlite3_column_text(stmt1, 2))
            
            self.subtotal.text = "$ " + self.subtotalvalue
            print("gst =====> \(self.gstvalue)")
            self.gst.text = "$ " + self.gstvalue
            
        }
        setchargeslbl()
    }
    func setchargeslbl(){
        
        var stmt1:OpaquePointer?
        
        let query = "select custordrchcode, custorderchval from  CustorderHeader where custordernum = '\(self.orderid)'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            let chcode = String(cString: sqlite3_column_text(stmt1, 0))
            self.chvalue = String(cString: sqlite3_column_text(stmt1, 1))
            
            self.chgrplbl.text = chcode + " : "
            self.chvallbl.text = "$ " + self.chvalue
        }
        let gst = Double(self.gstvalue)
        let subtotal = Double(self.subtotalvalue)!
        let chvalue = Double(self.chvalue)!
        var intot = gst! + subtotal + chvalue
        intot = Double(round(100*intot)/100)
        print("gst --> \(gst) | subtotal --> \(subtotal) | chval --> \(chvalue) | intotal --> \(intot)")
        
        self.invoicetotal.text = "$ " + "\(intot)"
    }
    
    func deleteinvline(lotid: String){
        let query = "delete from CustorderLine where lotid = '\(lotid)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting inv line for \(itemid!)")
            return
        }
    }    
    
    @IBAction func addbtn(_ sender: UIButton) {
        //      let storyboard = UIStoryboard(name: "UNLOADING", bundle: nil)
        //            let registrationVC = storyboard.instantiateViewController(withIdentifier: "UNLOADSCANVC") as! UNLOADINGSCANTABVC
        //            registrationVC.navigationItem.title = "Products"
        //            self.navigationController?.pushViewController(registrationVC, animated: true)
        
        let storyboard = UIStoryboard(name: "UNLOADING", bundle: nil)
        let registrationVC = storyboard.instantiateViewController(withIdentifier: "ADDPRODUCTVC") as! SELECTCATEGORY
        registrationVC.navigationItem.title = "Products"
        registrationVC.origin = ""
        self.navigationController?.pushViewController(registrationVC, animated: true)
    }
    
    
    func setlist(){
        var stmt1:OpaquePointer?
        
        self.orderadapter.removeAll()
        
        let query = "select a.itemname,cast(a.qty as int) as qty ,a.price,c.date,ifnull(c.ordernote,'-'),(select ifnull(sum (chamt),'0') from CustItemCharge where lotid = a.lotid) as itemcharge,a.itemdisamt,a.lotid from CustorderLine a inner join CustorderHeader c on a.custordernum = c.custordernum where a.custordernum = '\(CUSTORDERVC.custid!)'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        //Custorder(custid text,userid text, itemid text, qty text, date text, |:"+{price text, totvalue text, status text,post text)
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let itemname = String(cString: sqlite3_column_text(stmt1, 0))
            let qty = String(cString: sqlite3_column_text(stmt1, 1))
            let price = String(cString: sqlite3_column_text(stmt1, 2))
            let date = String(cString: sqlite3_column_text(stmt1, 3))
            let ordernote = String(cString: sqlite3_column_text(stmt1, 4))
            let itemch = String(cString: sqlite3_column_text(stmt1, 5))
            let itemdis = String(cString: sqlite3_column_text(stmt1, 6))
            let itemid = String(cString: sqlite3_column_text(stmt1, 7))
            
            self.invoicedesc.text = ordernote
            
            orderadapter.append(CUSTORDERADAPTER(proddesc: itemname, qty: qty, price: price, date: date,itemch: itemch,itemdis: itemdis,itemid: itemid))
        }
        self.orderttable.reloadData()
        self.refreshtotal()
    }
    
}
