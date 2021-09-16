//
//  ADDSALESORDERVC.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 03/07/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import SQLite3

class ADDSALESORDERVC: BASEACTIVITY ,TapQty, UITableViewDelegate, UITableViewDataSource,batchqty {
    
    func bqtytapped(at index: IndexPath) {
        let list : SERIALBATCHADAPTER
        list = batchadapter[index.row]
        let qty = list.qty!
        self.batchnum = list.label!
        self.quantittyedft.text = qty
        self.mainview.isHidden = false
    }
    var batchnum = ""
    var isbatch: Bool = false
    var isserial: Bool = false
    func updateqty(at index: IndexPath) {
        print("index -- > \(index)")
        let list: CUSTORDERADAPTER
        list = unloadingadapter[index.row]
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
        
        let query = "select batch from loading where itemid = '\(self.itemid!)' and batch not in (select batch from BatchSerial where lotid = '\(self.lotid!)')"
                          
        print("query --> \(query)")
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
        
        let query = "select serial from loading where itemid = '\(self.itemid!)' and serial not in (select serial from BatchSerial where lotid = '\(self.lotid!)') and serial not in (select serial from Unloading where itemid = '\(self.itemid!)')"
                          
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
        return unloadingadapter.count
    }else{
        return batchadapter.count
    }
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if (tableView.tag == 1){   // for order table
    let cell = tableView.dequeueReusableCell(withIdentifier: "ordercell", for: indexPath) as! CUSTORDERCELL
        
        let list: CUSTORDERADAPTER
        list = unloadingadapter[indexPath.row]
        
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
            list = unloadingadapter[indexPath.row]
            let alert = UIAlertController(title: "Delete", message: "Do you want to delete this item?", preferredStyle: .alert)
            
                let okaction = UIAlertAction(title: "Yes", style: .default) { [self] _ in
                self.unloadingadapter.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                    //                    let itemid = self.getitemidfromname(itemname: list.proddesc!)
                    //                    let lotid = self.getlotid(orderid: self.orderid, itemid: itemid)
                                        let lotid = list.itemid!
                self.deleteinvline(lotid: lotid)
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
                self.deleteerialbatch(lotid: list.lotid!, batch: list.label!, serial: "", type: "salesorder")
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
                self.deleteerialbatch(lotid: list.lotid!, batch: "", serial: list.label!, type: "salesorder")
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
  
    var itemid,price,lotid: String!
    var unloadingadapter = [CUSTORDERADAPTER]()
    var flag: Bool = false
    var setscanresult = false
    var sindex : IndexPath!
    
    @IBAction func addprodbnt(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "UNLOADING", bundle: nil)
        let registrationVC = storyboard.instantiateViewController(withIdentifier: "ADDPRODUCTVC") as! SELECTCATEGORY
        registrationVC.navigationItem.title = "Sales Order"
        self.navigationController?.pushViewController(registrationVC, animated: true)
    }
    
    @IBOutlet var ordertable: UITableView!
    @IBOutlet var quantittyedft: UITextField!
    
    @IBOutlet var chvallbl: UILabel!
    @IBOutlet var chgrplbl: UILabel!
    @IBOutlet weak var subtotal: UILabel!
    @IBOutlet weak var gst: UILabel!
    @IBOutlet weak var invoicetotal: UILabel!
    
    @IBAction func donebtn(_ sender: UIBarButtonItem) {
        if (flag){
            if (AppDelegate.isdelivered){
                self.updatelastactivity(activityid: NoDelReason.delivered.rawValue, ordernum: CUSTORDERVC.custid!)
                self.push(storybId: "RESQUENCING", vcId: "ORDERDELNC", vc: self)
            }else{
                if (self.verifyqty()){
                    if (self.checkrevenue()){
                        self.insertnodelreason(ordernum: CUSTORDERVC.custid!, reasoncode: "", description: "", note: "", date: "",skipcancelname : "", type: NoDelReason.open.rawValue)
                        
                        if (AppDelegate.ntwrk > 0){
                            self.showIndicator("Syncing...", vc: self)
                            self.gettoken()
                        }else{
                            self.gotohome()
                        }
                    }else{
                        self.showToast(message: "Check Revenue in order lines")
                    }
                }else if (self.vitem != ""){
                    self.showToast(message: "Please check the Batch/Serial for \(self.vitem)")
                }else{
                    self.showToast(message: "Please select the Batch/Serial on the order lines")
                }
            }
            
            //        self.updatelastactivity(activityid: NoDelReason.delivered.rawValue, ordernum: CUSTORDERVC.custid!)
            //        self.push(storybId: "RESQUENCING", vcId: "ORDERDELNC", vc: self)
        }else{
            self.showToast(message: "None Items selected!!!")
        }
    }
    var notitem = ""
    func checkstockqty() -> Bool{

        var stmt1:OpaquePointer?
                
        var flag = false
        notitem = ""
        vitem = ""
        
        let query = "select c.itemname from CustorderLine a left outer join (select itemid, sum(netqty) as tqty from truckstock group by itemid) b inner join Itemmaster c on a.itemnum = c.itemcode where a.itemnum = b.itemid and CAST(a.qty as INTEGER) > cast(b.tqty as INTEGER) and a.custordernum = '\(CUSTORDERVC.custid!)' and c.isservice = 'false' and CAST(a.qty as INTEGER) >= 0"
        
        let recordcheck = "select b.itemname from CustorderLine a inner join itemmaster b on a.itemnum = b.itemcode where custordernum = '\(CUSTORDERVC.custid!)' and itemnum not in (select itemid from truckstock) and (b.isservice = 'false') and CAST(a.qty as INTEGER) >= 0"
                          
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
        if (!AppDelegate.isdelivered){
            flag = true
        }
        return flag
    }
    
    override func callback() {
        self.postcustorder()
    }
    
    override func orderdone() {
        self.hideindicator()
        self.showmsg(msg: "Order posted successfully")
        self.gotohome()
    }
    
    override func ordernot() {
        self.hideindicator()
        self.showToast(message: "Order not posted due to API error")
    }
    
    override func ordererr() {
        self.hideindicator()
        self.showToast(message: "Order not posted due to server error")
    }
    
    func checkrevenue()-> Bool{
        
        var stmt1:OpaquePointer?
        var flag = true
        let orderid = CUSTORDERVC.custid!
        
        let recordcheck = "select * from CustorderLine a inner join Itemmaster b on a.itemnum = b.itemcode where case when b.itemtype = '13' then a.revsch = '' and a.cathitem = '' and b.isserial = '1' when b.itemtype <> '13' then a.revsch = ''  and b.isserial = '1' end and a.custordernum  = '\(orderid)' and cast( a.qty as Int) >=0"
                                  
                 if  sqlite3_prepare_v2(Databaseconnection.dbs,recordcheck, -1, &stmt1, nil) != SQLITE_OK{
                     let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                     print("error preparing get: \(errmsg)")
                     return flag
                 }

                 if(sqlite3_step(stmt1) == SQLITE_ROW){
                    flag = false
                 }
        if (!AppDelegate.isdelivered){
            flag = true
        }
        return flag
    }
    var vitem = ""
    
    func verifyqty() -> Bool{

        var stmt1:OpaquePointer?
                
        var flag = false
        
        vitem = ""
        
        let query = "select c.itemname from CustorderLine a left OUTER join (select lotid, sum(qty) as tqty from BatchSerial group by lotid) b inner join Itemmaster c on a.itemnum = c.itemcode where a.lotid = b.lotid and CAST(a.qty as INTEGER) <> cast(b.tqty as INTEGER) and a.custordernum = '\(CUSTORDERVC.custid!)'"
        
        let recordcheck = "select * from CustorderLine a inner join itemmaster b on a.itemnum = b.itemcode where custordernum = '\(CUSTORDERVC.custid!)' and lotid not in (select lotid from BatchSerial) and (b.isbatch <> '0' or b.isserial <> '0')"
                          
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
        if (!AppDelegate.isdelivered){
            flag = true
        }
        return flag
    }
    
    
    //MARK:- update qty btns
    @IBOutlet var mainview: UIView!
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
        if (self.quantittyedft.text!.count > 0){
            self.isbtot = false
            if self.isbatch || self.isserial {
                self.updateqtynow(qty: self.quantittyedft.text!)
            }else{
                self.updatetotalqty(qty: self.quantittyedft.text!, lotid: self.lotid!)
            }
            
            setlist()
            self.mainview.isHidden = true
        }
    }
    @IBOutlet var batchscan: UIButton!
    
    @IBAction func batchscanbtn(_ sender: UIButton) {
        
    }
    
    @IBAction func batchenterbtn(_ sender: UIButton) {
        self.insertbatch(batch: self.batchedt.text!)
    }
    
    func insertbatch(batch: String){
//        self.lotid = self.getlotid(orderid: CUSTORDERVC.custid!, itemid: itemid!)
        if (batch.count > 0){
            self.insertbatchserial(lotid: self.lotid!, batch: batch, serial: "", qty: "0", type: "salesorder", post: "0")
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

        let query = "select batch,qty from batchserial where lotid = '\(self.lotid!)'"
                  
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

        
        let query = "select serial,qty from batchserial where lotid = '\(self.lotid!)'"
                  
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
//        self.lotid = self.getlotid(orderid: CUSTORDERVC.custid!, itemid: itemid!)
        if (serial.count > 0){
            var qty = 1
            if (!self.serialedt.isHidden){
                qty = -1
            }
            self.insertbatchserial(lotid: self.lotid!, batch: "", serial: serial, qty: "\(qty)", type: "salesorder", post: "0")
            self.serialedt.text = ""
            self.setserialtable()
        }else{
            self.showToast(message: "Enter Serial number to continue")
        }
    }
    
    @IBAction func serialscanbtn(_ sender: UIButton) {
        let sb = UIStoryboard(name: "UNLOADING", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "UNLOADSCANVC") as! UNLOADINGSCANTABVC
        print("index -- > \(sindex!)")
        vc.sindex = self.sindex
        vc.origin = "SO"
        vc.lotid = self.lotid!
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
//    MARK:- VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        self.setnav(title: self.navigationItem.title!)
        self.mainview.isHidden = true
        self.batchview.isHidden = true
        self.serialview.isHidden = true
        self.revenueview.isHidden = true
        self.setscanresult = AppDelegate.setscanresult
        if (setscanresult){
            self.sindex = AppDelegate.sindex!
            self.setlist()
            self.updateqty(at: self.sindex)
        }else{
            setlist()
        }
        let tapr = UITapGestureRecognizer(target: self, action: #selector(self.taprev))
        revenueview.addGestureRecognizer(tapr)
        
        self.settotedtqty()
        self.setbatchedt()
        self.setserialqty()
    }
    
    @objc func taprev(){
        self.revenueview.isHidden = true
    }
    
    override func backbuttonPressed() {
        self.removeorderheader(orderid: CUSTORDERVC.custid!)
        self.removeorderline(orderid: CUSTORDERVC.custid!)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        ordertable.delegate = self
        ordertable.dataSource = self
        
        self.batchdropdown.didSelect { (selection, id, index) in
            self.insertbatch(batch: selection)
        }
        self.serialdropdown.didSelect { (selection, id, index) in
            self.insertserial(serial: selection)
        }
        self.navigationItem.leftBarButtonItem = self.getbackbarbutton()
    }
    
    var gstvalue: String = ""
    var subtotalvalue: String = ""
    var chvalue: String  = ""
    
    func refreshtotal(){
        var stmt1:OpaquePointer?
                
        let query = "select ( (select ifnull(sum ( cast (totval as real) ),'0') from CustorderLine where custordernum = '\(CUSTORDERVC.custid!)') + (select ifnull (sum ( cast ( chamt as real ) ) ,'0') as taxamt from CustItemCharge where lotid in (select lotid from CustorderLine where custordernum = '\(CUSTORDERVC.custid!)')) ) as subtotal , ((select ifnull(sum ( cast (taxamt as real ) ) ,'0') as taxamt from CustItemTax where lotid in (select lotid from CustorderLine where custordernum = '\(CUSTORDERVC.custid!)')) + (select custorderchtax from CustorderHeader where custordernum = '\(CUSTORDERVC.custid!)')) as gst"
                          
        print("query --> \(query)")
        
                 if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
                     let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                     print("error preparing get: \(errmsg)")
                     return
                 }

                 if(sqlite3_step(stmt1) == SQLITE_ROW){
                    self.subtotalvalue = String(cString: sqlite3_column_text(stmt1, 0))
                    self.gstvalue = String(cString: sqlite3_column_text(stmt1, 1))
                    
                    self.subtotal.text = "$ " + self.subtotalvalue
                    print("gst =====> \(self.gstvalue)")
                    self.gst.text = "$ " + self.gstvalue
                }
        setchargeslbl()
    }
    func setchargeslbl(){
        
        var stmt1:OpaquePointer?
                
        let query = "select custordrchcode, custorderchval from CustorderHeader where custordernum = '\(CUSTORDERVC.custid!)'"
                          
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

    func setlist(){
        var stmt1:OpaquePointer?
         
        self.unloadingadapter.removeAll()
        
        let query = "select b.itemname,cast(a.qty as int) as qty ,a.price,c.date,ifnull(c.ordernote,'-'),(select ifnull(sum (chamt),'0') from CustItemCharge where lotid = a.lotid) as itemcharge,a.itemdisamt,a.lotid from CustorderLine a inner join Itemmaster b on a.itemnum = b.itemcode inner join CustorderHeader c on a.custordernum = c.custordernum where a.custordernum = '\(CUSTORDERVC.custid!)'"
                  
         if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
             let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
             print("error preparing get: \(errmsg)")
             return
         }
        
         while(sqlite3_step(stmt1) == SQLITE_ROW){
            let itemname = String(cString: sqlite3_column_text(stmt1, 0))
            let qty = String(cString: sqlite3_column_text(stmt1, 1))
            let price = String(cString: sqlite3_column_text(stmt1, 2))
            let date = String(cString: sqlite3_column_text(stmt1, 3))
            let ordernote = String(cString: sqlite3_column_text(stmt1, 4))
            let itemch = String(cString: sqlite3_column_text(stmt1, 5))
            let itemdis = String(cString: sqlite3_column_text(stmt1, 6))
            let lotid = String(cString: sqlite3_column_text(stmt1, 7))
            flag = true
            unloadingadapter.append(CUSTORDERADAPTER(proddesc: itemname, qty: qty, price: price, date: date,itemch: itemch,itemdis: itemdis, itemid: lotid))
        }
        self.ordertable.reloadData()
        
        refreshtotal()
    }
    var itemchgrp = ""
    func updatetotalqty(qty: String, lotid: String){
        self.updateorderqty(lotid: lotid, qty: qty)
        self.itemchgrp = self.getitemchgrp(orderid: CUSTORDERVC.custid!, itemid: itemid)
        
        self.updateprice(itemid: itemid, orderdate: CUSTORDERVC.orderdate!, custid: CUSTOMERINFOVC.custid, pricegroup: CUSTORDERVC.pricegrp!, orderid: CUSTORDERVC.custid!)
        self.updatediscount(itemid: itemid, custid: CUSTOMERINFOVC.custid, discountgrp: CUSTORDERVC.discountgrp!, orderid: CUSTORDERVC.custid!)
        self.updatelineamt(orderid: self.lotid, itemid: itemid)
        self.updatetaxline(itemid: itemid, orderid: CUSTORDERVC.custid!, lotid: self.lotid)
        self.updatechargeline(itemid: itemid, orderid: CUSTORDERVC.custid!, lotid: self.lotid, custid: CUSTOMERINFOVC.custid, custchgrp: CUSTORDERVC.custchgrp, itemchgrp: self.itemchgrp)
        
        setlist()
        self.mainview.isHidden = true
    }
    func updateqtynow(qty: String){
        if (qty.count > 0){
//            self.lotid = self.getlotid(orderid: CUSTORDERVC.custid!, itemid: itemid!)
            if (isbatch){
                if (isbtot){
                    self.updatetotalqty(qty: qty, lotid: self.lotid!)
                    self.batchview.isHidden = true
                }else{
                    self.insertbatchserial(lotid: self.lotid!, batch: self.batchnum, serial: "", qty: qty, type: "salesorder", post: "0")
                    self.mainview.isHidden = true
                    self.setbatchtable()
                }
            }else{
                self.updatetotalqty(qty: qty, lotid: self.lotid!)
                self.serialview.isHidden = true
            }
            print("qty inserted ---> \(qty)")
        }
    }
    @objc func tapbatch(){
        self.batchview.isHidden = true
    }
    @objc func tapserial(){
        self.serialview.isHidden = true
    }
    func deleteinvline(lotid: String){
        let query = "delete from CustorderLine where lotid = '\(lotid)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting inv line for \(lotid)")
            return
        }
    }
    func settotedtqty(){
        let toolbar = UIToolbar().minussign(mySelect : #selector(self.mySelect),minus: #selector(self.totqty_minus), controller: self)
        self.quantittyedft.inputAccessoryView = toolbar
    }
    
    @objc func totqty_minus(){
        if (self.quantittyedft.text!.count > 0 && Int(self.quantittyedft.text!)! > 0){
            self.quantittyedft.text = "\(Int(self.quantittyedft.text!)! * -1)"
        }
    }
    
    @objc func bqty_minus(){
        if (self.totalbqty.text!.count > 0 && Int(self.totalbqty.text!)! > 0){
            self.totalbqty.text = "\(Int(self.totalbqty.text!)! * -1)"
        }
    }
    
    @objc func sqty_minus(){
        if (self.totalsqty.text!.count > 0 && Int(self.totalsqty.text!)! > 0){
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
