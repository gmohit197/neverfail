//
//  ENTERQUANTITYVC.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 20/06/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import MaterialComponents
import SQLite3

class ENTERQUANTITYVC: BASEACTIVITY {

    @IBOutlet var prodname: UILabel!
    @IBOutlet var prodqty: UITextField!
    @IBOutlet var prodimage: UIImageView!
    var origin = ""
    var price: String!
    var datetime: String!
    var itemid: String?
    
    override func viewWillAppear(_ animated: Bool) {
       
        self.setnav(title: self.navigationItem.title!)
        self.settotedtqty()
    }
    
    func settotedtqty(){
        let toolbar = UIToolbar().minussign(mySelect : #selector(self.mySelect),minus: #selector(self.totqty_minus), controller: self)
        self.prodqty.inputAccessoryView = toolbar
    }
    
    @objc func mySelect(){
        view.endEditing(true)
    }
    
    @objc func totqty_minus(){
        if (self.prodqty.text!.count > 0 && Int(self.prodqty.text!)! != 0){
            self.prodqty.text = "\(Int(self.prodqty.text!)! * -1)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setproddetail()
    }
    
    @IBAction func qtyminus(_ sender: UIButton) {
        if (self.prodqty.text!.count > 0 ){
            self.prodqty.text = "\(Int(self.prodqty.text!)! - 1)"
        }
    }
    
    @IBAction func qtyplus(_ sender: UIButton) {
        if (self.prodqty.text!.count > 0 ){
            self.prodqty.text = "\(Int(self.prodqty.text!)! + 1)"
        }
    }
    
    @IBAction func donebtn(_ sender: UIBarButtonItem) {
    
        if (prodqty.text == ""){
            self.showToast(message: "Quantity is mandatory")
        }else if self.navigationItem.title == "Products" {
            if self.origin == "stocktr"{
                self.insertstocktransfer(trkid: "", itemid: itemid!, qty: prodqty.text!, date: self.getdate(format: "yyyy-MM-dd"), uid: STOCKTRVC.uid, post: "0")
                AppDelegate.setscanresult = false
                self.navigationController?.popViewController(animated: true)
                self.showmsg(msg: "Item Saved to Transfer")
            }else{
//                insert in order line
                self.insertneworderline()
//                self.push(storybId: "RESQUENCING", vcId: "CUSTORDERNC", vc: self)
            }
        }else if self.navigationItem.title == "Sales Order" {
//            insert order line for new order
            
            self.insertneworderline()
        }else if self.navigationItem.title == "Unload"{
            self.insertcheckintable(itemid : itemid!,itemname : prodname.text!, qty : prodqty.text!,datetime : self.getdate(format: "yyyy-MM-dd"))
            self.navigationController?.popViewController(animated: true)
            self.showmsg(msg: "Item Saved for Unloading")
        }else if self.navigationItem.title == "Load"{
            self.insertload(id: self.getdate(format: "yyyy-MM-dd HH:mm:ss.SSS"), itemname: prodname.text!, itemid: itemid!, qty: prodqty.text!, batch: "", serial: "")
            self.navigationController?.popViewController(animated: true)
            self.showmsg(msg: "Item Saved for Loading")
        }
    }
    
    func insertneworderline(){
        var stmt1:OpaquePointer?
        let uid = self.getdate(format: "yyyy-MM-dd HH:mm:ss.SSS")
        let lotid = uid.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: ":", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: " ", with: "")
        let query = "select itemgstgrp,itemchgrp,linedisgrp from itemmaster where itemcode = '\(itemid!)'"
                  
         if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
             let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
             print("error preparing get: \(errmsg)")
             return
         }
         if(sqlite3_step(stmt1) == SQLITE_ROW){
            let itemtax = String(cString: sqlite3_column_text(stmt1, 0))
            let itemchgrp = String(cString: sqlite3_column_text(stmt1, 1))
            
            self.insertorderline(lotid: lotid, custordernum: CUSTORDERVC.custid!, itemnum: itemid!, itemname: prodname.text!, qty: prodqty.text!, price: "0.0", priceunit: "1", itemdisper: "0.0", itemdisamt: "0.0", itemdis: "0.0", itemtaxgrp: itemtax, itembatch: "", totval: "0.0", cathitem: "",revsch : "", post: "0")
            self.updateprice(itemid: itemid!, orderdate: CUSTORDERVC.orderdate!, custid: CUSTOMERINFOVC.custid, pricegroup: CUSTORDERVC.pricegrp!, orderid: CUSTORDERVC.custid!)
            self.updatediscount(itemid: itemid!, custid: CUSTOMERINFOVC.custid, discountgrp: CUSTORDERVC.discountgrp!, orderid: CUSTORDERVC.custid!)
            self.updatelineamt(orderid: lotid, itemid: itemid!)
            self.updatetaxline(itemid: itemid!, orderid: CUSTORDERVC.custid!, lotid: lotid)
            self.updatechargeline(itemid: itemid!, orderid: CUSTORDERVC.custid!, lotid: lotid, custid: CUSTOMERINFOVC.custid, custchgrp: CUSTORDERVC.custchgrp, itemchgrp: itemchgrp)
            self.navigationController?.popViewController(animated: true)
            self.showmsg(msg: "Item Saved for Order")
         }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { [weak self] in
                self?.prodimage.image = UIImage(data: data)
            }
        }
    }
    
    func setproddetail(){
        var stmt1:OpaquePointer?
         //itemid text,category text, itemname text,price text ,url text)"
        let query = "select * from Itemmaster where itemcode = '\(itemid!)'"
                  
         if sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
             let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
             print("error preparing get: \(errmsg)")
             return
         }
         if(sqlite3_step(stmt1) == SQLITE_ROW){
            let itemname = String(cString: sqlite3_column_text(stmt1, 1))
            self.price = String(cString: sqlite3_column_text(stmt1, 3))
            let url = String(cString: sqlite3_column_text(stmt1, 8))
            
            self.prodqty.text = "0"
            
            prodname.text = itemname
            if (url.count > 0){
//                let weburl = URL(string: url)!
//                prodimage.load(url: weburl)
                if let data = Data(base64Encoded: url, options: .ignoreUnknownCharacters){
                    if let image = UIImage(data: data) {
                        self.prodimage.setImage(image)
                    }
                }
            }
        }
    }
}
