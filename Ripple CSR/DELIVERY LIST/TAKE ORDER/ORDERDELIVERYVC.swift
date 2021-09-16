//
//  ORDERDELIVERYVC.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 01/07/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import MaterialComponents
import SwiftEventBus
import SQLite3

class ORDERDELIVERYVC: BASEACTIVITY {
    
    @IBOutlet var purchaseorder: MDCTextField!
    @IBOutlet var orderowner: MDCTextField!
    @IBAction func signaturebtn(_ sender: UIButton) {
        self.updatepono()
        self.sign = nil
        self.push(storybId: "RESQUENCING", vcId: "SIGNNC", vc: self)
    }
    @IBAction func photobtn(_ sender: UIButton) {
        if #available(iOS 13.0, *) {
            self.photo = nil
            let controller = CustomCameraController()
            self.present(controller, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    @IBAction func managedelbtn(_ sender: UIButton) {
        self.updatepono()
        self.push(storybId: "MANAGEDEL", vcId: "MANAGEDELNC", vc: self)
    }
    
    @IBAction func pomandate(_ sender: UISwitch) {
        
        let query = "update CustorderHeader set pomandate = '\(sender.isOn)' where custordernum = '\(CUSTORDERVC.custid!)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error update CustorderHeader - pomandate value")
            return
        }else{
            if (sender.isOn){
                CUSTORDERVC.pomandate = "true"
            }else{
                CUSTORDERVC.pomandate = "false"
            }
        }
    }
    @IBOutlet var pomandatebtn: UISwitch!
    @IBOutlet var signbtn: UIButton!
    @IBOutlet var managebtn: UIButton!
    @IBOutlet var photobtn: UIButton!
    @IBOutlet var donebtn: UIBarButtonItem!
    
    @IBAction func donebtn(_ sender: UIBarButtonItem) {
        self.checkimages()
        if (AppDelegate.isorder){
            self.do_salesorder()
        }else{
            self.do_custorder()
        }
        
    }
    
    func set_pono(){
        var stmt1:OpaquePointer?
        let query = "select pono,acceptedby from CustorderHeader where custordernum = '\(CUSTORDERVC.custid!)'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            let pono = String(cString: sqlite3_column_text(stmt1, 0))
            self.purchaseorder.text = pono
            let purchaseby  = String(cString: sqlite3_column_text(stmt1, 1))
            self.orderowner.text = purchaseby
        }
    }
    
    func do_salesorder(){
        if (self.verifyqty()){
            if (self.checkrevenue()){
                if (self.validate()){
                    if (AppDelegate.isdelivered){
                        //                    validation here
                        if (self.checkstockqty(type: "salesorder")){
                            self.updatepono()
                            self.updateimages()
                            self.insertnodelreason(ordernum: CUSTORDERVC.custid!, reasoncode: "", description: "", note: "", date: "",skipcancelname : "", type: NoDelReason.delivered.rawValue)
                            self.insertts_fromSO(orderid: CUSTORDERVC.custid!)
                        }else if (self.notitem.count > 0){
                            self.showToast(message: "The stock for \(self.notitem) was not loaded on the truck.")
                        }else if (self.vitem.count > 0){
                            self.showToast(message: "Not Enough Stock Available for \(self.vitem).")
                        }
                    }else{
                        self.insertnodelreason(ordernum: CUSTORDERVC.custid!, reasoncode: "", description: "", note: "", date: "",skipcancelname : "", type: NoDelReason.open.rawValue)
                    }
                if (AppDelegate.ntwrk > 0){
                    self.showIndicator("Syncing...", vc: self)
                    self.gettoken()
                }else{
                    self.gotohome()
                }}
            }else{
                self.showToast(message: "Check Revenue in order lines")
            }
        }else if (self.vitem != ""){
            self.showToast(message: "Please check the Batch/Serial for \(self.vitem)")
        }else{
            self.showToast(message: "Please select the Batch/Serial on the order lines")
        }
    }
    
    func do_custorder(){
        let id = self.getlastactivityid(orderid: CUSTORDERVC.custid!)
        if (id == NoDelReason.open.rawValue){
            if (self.verifyqty()){
                if (self.checkrevenue()){
                    if (self.validate()){
                        if (self.checkstockqty(type: "custorder")){
                            self.updatepono()
                            self.updateimages()
                            self.updatelastactivity(activityid: NoDelReason.delivered.rawValue, ordernum: CUSTORDERVC.custid!)
                            self.insertnodelreason(ordernum: CUSTORDERVC.custid!, reasoncode: "", description: "", note: "", date: "", skipcancelname: "", type: NoDelReason.delivered.rawValue)
//                            self.insertindim()
                            self.insertts_fromSO(orderid: CUSTORDERVC.custid!)
                            if (AppDelegate.ntwrk > 0){
                                self.showIndicator("Syncing...", vc: self)
                                self.gettoken()
                            }else{
                                self.gotohome()
                            }
                        }else if (self.notitem.count > 0){
                            self.showToast(message: "The stock for \(self.notitem) was not loaded on the truck.")
                        }else if (self.vitem.count > 0){
                            self.showToast(message: "Not Enough Stock Available for \(self.vitem).")
                        }
                    }}else{
                        self.showToast(message: "Check Revenue in order lines")
                    }
            }else if (self.vitem != ""){
                self.showToast(message: "Please check the Batch/Serial for \(self.vitem)")
            }else{
                self.showToast(message: "Please select the Batch/Serial on the order lines")
            }
        }else{
            self.updatenodelreasonstate(orderid: CUSTORDERVC.custid!)
            if (AppDelegate.ntwrk > 0){
                self.showIndicator("Syncing...", vc: self)
                self.gettoken()
            }else{
                self.gotohome()
            }
        }
    }
    
    func insertindim(){
        var stmt1:OpaquePointer?
        let query = "select b.custordernum,c.itemcode,c.isservice,a.batch,a.serial,a.qty,b.lotid from BatchSerial a inner join CustorderLine b on a.lotid = b.lotid inner join Itemmaster c on b.itemnum=c.itemcode where b.custordernum = '\(CUSTORDERVC.custid!)'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let ordernum = String(cString: sqlite3_column_text(stmt1, 0))
            let itemid = String(cString: sqlite3_column_text(stmt1, 1))
            let batch = String(cString: sqlite3_column_text(stmt1, 3))
            let serial = String(cString: sqlite3_column_text(stmt1, 4))
            let qty = sqlite3_column_double(stmt1, 5)
            let lotid = String(cString: sqlite3_column_text(stmt1, 6))
            
            self.insertdimdetails(orderid: ordernum, itemid: itemid, batch: batch, serial: serial, qty: "\(qty)", post: "0", lotid: lotid)
        }
    }
    
    var notitem = ""
    func checkstockqty(type: String) -> Bool{
        
        var stmt1:OpaquePointer?
        var flag = false
        notitem = ""
        vitem = ""
        
        let query = "select c.itemname,bs.qty,b.tqty,bs.batch,bs.serial from CustorderLine a inner join batchserial bs on a.lotid = bs.lotid and bs.type = '\(type)' left outer join (select itemid, netqty as tqty,batch,serial from truckstock) b inner join Itemmaster c on a.itemnum = c.itemcode where a.itemnum = b.itemid and CAST(bs.qty as INTEGER) > cast(b.tqty as INTEGER) and a.custordernum = '\(CUSTORDERVC.custid!)' and c.isservice = 'false' and cast( a.qty as Int) >= 0 and b.batch = bs.batch and b.serial = bs.serial"
        
        let recordcheck = "select b.itemname from CustorderLine a inner join itemmaster b on a.itemnum = b.itemcode where custordernum = '\(CUSTORDERVC.custid!)' and itemnum not in (select itemid from truckstock) and (b.isservice = 'false') and cast( a.qty as Int) >= 0 "
        
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
    
    func updatepono(){
        
        let query = "update CustorderHeader set acceptedby = '\(self.orderowner.text!)' , pono = '\(self.purchaseorder.text!)' , pomandate = '\(self.pomandatebtn.isOn)' where custordernum = '\(CUSTORDERVC.custid!)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating in CustorderHeader Table")
            return
        }
    }
    
    func updateimages(){
        let query = "update images set activity = '\(NoDelReason.delivered.rawValue)' where activity = '\(NoDelReason.open.rawValue)' and date = '\(self.getdate(format: "yyyy-MM-dd"))' and ordernum = '\(CUSTORDERVC.custid!)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating in images Table")
            return
        }
    }
    
    func validate()-> Bool{
        var flag = true
        if (self.pomandatebtn.isOn && self.purchaseorder.text!.count == 0){
            self.showToast(message: "Purchase Order is mandatory")
            flag = false
        }else if (self.pomandatebtn.isOn && self.orderowner.text!.count == 0){
            self.showToast(message: "Order accepted by is mandatory")
            flag = false
        }else if self.sign == nil && self.photo == nil{
            self.showToast(message: "Either Signature or Photograph is mandatory.")
            flag = false
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
    
    var vitem = ""
    var orderid = ""
    
    func checkrevenue()-> Bool{
        
        var stmt1:OpaquePointer?
        var flag = true
        self.orderid = CUSTORDERVC.custid!
        
        let recordcheck = "select * from CustorderLine a inner join Itemmaster b on a.itemnum = b.itemcode where case when b.itemtype = '13' then a.revsch = '' and a.cathitem = '' and b.isserial = '1' when b.itemtype <> '13' then a.revsch = ''  and b.isserial = '1' end and a.custordernum  = '\(orderid)' and cast( a.qty as Int) >= 0 "
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,recordcheck, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return flag
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            flag = false
        }
        return flag
    }
    
    
    func verifyqty() -> Bool{
        
        var stmt1:OpaquePointer?
        var flag = false
        vitem = ""
        self.orderid = CUSTORDERVC.custid!
        
        let query = "select c.itemname from CustorderLine a left OUTER join (select lotid, sum(qty) as tqty from BatchSerial group by lotid) b inner join Itemmaster c on a.itemnum = c.itemcode where a.lotid = b.lotid and CAST(a.qty as INTEGER) <> cast(b.tqty as INTEGER) and a.custordernum = '\(self.orderid)'"
        
        let recordcheck = "select * from CustorderLine a inner join itemmaster b on a.itemnum = b.itemcode where custordernum = '\(self.orderid)' and lotid not in (select lotid from BatchSerial ) and (b.isbatch <> '0' or b.isserial <> '0')"
        
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
    @IBAction func takepayment(_ sender: UIButton) {
        self.push(storybId: "RESQUENCING", vcId: "INVNC", vc: self)
        //        self.showToast(message: "under construction...")
    }
    
    public var photo : UIImage?
    public var sign : UIImage?
    
    override func viewWillAppear(_ animated: Bool) {
        
        if (CUSTORDERVC.pomandate == "true"){
            self.pomandatebtn.isOn = true
        }else{
            self.pomandatebtn.isOn = false
        }
        
        if (AppDelegate.isorder){
            self.managebtn.isHidden = true
        }else{
            self.managebtn.isHidden = false
        }
        self.set_pono()
        purchaseordercontroller = MDCTextInputControllerOutlined(textInput: purchaseorder)
        orderownercontroller = MDCTextInputControllerOutlined(textInput: orderowner)
        purchaseordercontroller.setfordark(field: purchaseorder, controller: self)
        orderownercontroller.setfordark(field: orderowner, controller: self)
        self.setnav(title: self.navigationItem.title!)
        checkimages()
        SwiftEventBus.onMainThread(self, name: "Image") { Result in
            self.checkimages()
            if self.photo != nil {
                self.photobtn.setBackgroundImage(UIImage(named: "button-done"), for: UIControl.State.normal)
            }else{
                self.photobtn.setBackgroundImage(UIImage(named: "button"), for: .normal)
            }
            self.initmanagebtn()
        }
        
        if (self.sign != nil){
            self.signbtn.setBackgroundImage(UIImage(named: "button-done"), for: UIControl.State.normal)
        }else{
            self.signbtn.setBackgroundImage(UIImage(named: "button"), for: .normal)
        }
        if self.photo != nil {
            self.photobtn.setBackgroundImage(UIImage(named: "button-done"), for: UIControl.State.normal)
        }else{
            self.photobtn.setBackgroundImage(UIImage(named: "button"), for: .normal)
        }
        self.navigationItem.leftBarButtonItem = self.getbackbarbutton()
        
        self.initmanagebtn()
        
    }
    func initmanagebtn(){
        let id = self.getlastactivityid(orderid: CUSTORDERVC.custid!)
        
        if (id == NoDelReason.cancelOrder.rawValue || id == NoDelReason.reschedule.rawValue){
            self.managebtn.isEnabled = false
        }else{
            self.managebtn.isEnabled = true
        }    
    }
    
    func checkimages(){
        var stmt1 : OpaquePointer?
        let id = self.getlastactivityid(orderid: CUSTORDERVC.custid!)
        let query = "select * from images where ordernum = '\(CUSTORDERVC.custid!)' and activity = '\(id)'"
        
        print("query --> \(query)")
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let image = String(cString: sqlite3_column_text(stmt1, 1))
            let type = String(cString: sqlite3_column_text(stmt1, 2))
            
            if (type == "1"){
                self.sign = UIImage(data: Data(base64Encoded: image ,options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!)
            }else if (type == "2"){
                self.photo = UIImage(data: Data(base64Encoded: image ,options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!)
            }
        }
        if (id == NoDelReason.open.rawValue){
            if (self.sign != nil || self.photo != nil){
                self.donebtn.tintColor = UIColor.systemBlue
            }else{
                self.donebtn.tintColor = UIColor.gray
            }
        }
    }
    
    override func backbuttonPressed() {
        let alert  = UIAlertController(title: "Alert", message: "Going back will reset order state. Do you want to continue?", preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "Yes", style: .default) { (result) in
            self.deleteunsaveentry(orderid: CUSTORDERVC.custid!)
            if (AppDelegate.isorder){
                self.navigationController?.popViewController(animated: true)
            }else{
                self.push(storybId: "RESQUENCING", vcId: "CUSTORDERNC", vc: self)
            }
        }
        let no = UIAlertAction(title: "No", style: .destructive) { (result) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(yes)
        alert.addAction(no)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // Trait collection has already changed
        purchaseordercontroller.setfordark(field: purchaseorder, controller: self)
        orderownercontroller.setfordark(field: orderowner, controller: self)
    }
    
    var purchaseordercontroller: MDCTextInputControllerOutlined!
    var orderownercontroller: MDCTextInputControllerOutlined!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
