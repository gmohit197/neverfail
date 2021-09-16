//
//  CUSTOMERINFOVC.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 29/06/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import SQLite3

class CUSTOMERINFOVC: BASEACTIVITY {
    
    var name: String?
    var custadd: String?
    static var id: String?
    static var custid = ""
    var email = ""
    var phone = ""
    var street = ""
    var city = ""
    var state = ""
    var lati = ""
    var longi = ""
    var modofdel = ""
    var custchgrp = ""
    var custtaxgrp = ""
    var custdisgrp = ""
    var custpricegrp = ""
    var custmod = ""
    var custmodgrp = ""
    var date = ""
    var pono = ""
    
    @IBOutlet var namelbl: UILabel!
    @IBOutlet var addresslbl: UILabel!
    @IBOutlet var calllbl: UILabel!
    @IBOutlet var emaillbl: UILabel!
    @IBOutlet var ordernoteslbl: UILabel!
    @IBOutlet var addstk: UIStackView!
    @IBOutlet var delnoteslbl: UITextView!
    
    @IBOutlet var ordernumlbl: UILabel!
    @IBOutlet var delnotestk: UIStackView!
    @IBOutlet var shipdatestack: UIStackView!
    @IBOutlet var shipdate: UITextField!
    @IBOutlet var orderdatestack: UIStackView!
    @IBOutlet var orderdatelbl: UILabel!
    @IBOutlet var cancelcard: CardView!
    
    public var datePicker: UIDatePicker?
    var first = "Customer Details: "
    var locManager = CLLocationManager()
    
    override func viewWillAppear(_ animated: Bool) {
        self.setnav(title: self.navigationItem.title!)
        locManager.requestWhenInUseAuthorization()
        initdata()
        
        let tapcancelordr = UITapGestureRecognizer(target: self, action: #selector(cancelordercardtap))
        cancelcard.addGestureRecognizer(tapcancelordr)
    }
    
    
    @objc func cancelordercardtap(){
        self.push(storybId: "MANAGEDEL", vcId: "CANCELNC", vc: self)
    }
    
    func initdata(){
        var stmt1:OpaquePointer?
        var query = ""
        if (AppDelegate.isorder){
            CUSTORDERVC.custid = AppDelegate.custid!
            query = "select name,email,street,city,state,phone,delnote,'-',custid,modeofdel,custmodgrp,'' as date,lati,longi,pomandate,pono from custsrch where custid = '\(CUSTORDERVC.custid!)' and id = '\(CUSTOMERINFOVC.id!)'"
        }else{
            CUSTORDERVC.custid = AppDelegate.custid
            self.ordernumlbl.text = first + CUSTORDERVC.custid!
            query = "select custname,custemail,ifnull(custstreet,'-'),ifnull(custcity,'-'),ifnull(custstate,'-'),custphone,ifnull(delnote,'-'),ifnull(ordernote,'-'),custid,custmod,custmodgrp,date,lati,longi,'-','-' from CustorderHeader where custordernum = '\(CUSTORDERVC.custid!)' group by custid"
        }
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            name = String(cString: sqlite3_column_text(stmt1, 0))
            email = String(cString: sqlite3_column_text(stmt1, 1))
            street = String(cString: sqlite3_column_text(stmt1, 2))
            city = String(cString: sqlite3_column_text(stmt1, 3))
            state = String(cString: sqlite3_column_text(stmt1, 4))
            phone = String(cString: sqlite3_column_text(stmt1, 5))
            self.delnote = String(cString: sqlite3_column_text(stmt1, 6))
            let custdel = String(cString: sqlite3_column_text(stmt1, 7))
            CUSTOMERINFOVC.custid = String(cString: sqlite3_column_text(stmt1, 8))
            custmod = String(cString: sqlite3_column_text(stmt1, 9))
            custmodgrp = String(cString: sqlite3_column_text(stmt1, 10))
            date = String(cString: sqlite3_column_text(stmt1, 11))
            self.lati = String(cString: sqlite3_column_text(stmt1, 12))
            self.longi = String(cString: sqlite3_column_text(stmt1, 13))
            let poman = String(cString: sqlite3_column_text(stmt1, 14))
            pono = String(cString: sqlite3_column_text(stmt1, 15))
            
            CUSTORDERVC.custmod = custmod
            CUSTORDERVC.custmodgrp = custmodgrp
            CUSTORDERVC.pomandate = poman
            
            self.namelbl.text = name
            self.addresslbl.text = "\(street), \(city), \(state)"
            self.emaillbl.text = email
            self.calllbl.text = phone
            self.delnoteslbl.text = self.delnote
            self.ordernoteslbl.text = custdel
            
        }
        
        if self.navigationItem.title == "Customer Information" {
            orderdatestack.isHidden = false
            shipdatestack.isHidden = true
        }else if self.navigationItem.title == "Sales Order" {
            orderdatestack.isHidden = false
            shipdatestack.isHidden = false
            self.delnotestk.isHidden = true
            self.cancelcard.isHidden = true
        }
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "EEEE, MMM d, yyyy"
        
        let max = dateFormatter.date(from: self.getdate(format: "EEEE, MMM d, yyyy"))
        datePicker?.minimumDate = max
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        shipdate.inputAccessoryView = toolbar
        shipdate.inputView = datePicker
        
        shipdate.text = self.getdate(format: "EEEE, MMM d, yyyy")
        
        if (date != ""){
            self.date = self.convertDateFormater(date: self.date, input: "yyyy-MM-dd", output: "EEEE, MMM d, yyyy")
            orderdatelbl.text = self.date
        }else{
            orderdatelbl.text = self.getdate(format: "EEEE, MMM d, yyyy")
            self.date = orderdatelbl.text!
        }
    }
    
    var delnote = ""
    var pomandate = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let addtap = UITapGestureRecognizer(target: self, action: #selector(self.gotomaps))
        //        self.addstk.addGestureRecognizer(addtap)
    }
    
    @objc func gotomaps(){
        let address = self.custadd!
        print("\n addr - \(address)")
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            
            else {
                // handle no location found
                print("\nNo location found")
                return
            }
            print("\nlocation found lat - \(location.coordinate.latitude)   long - \(location.coordinate.longitude)")
            // Use your location
            self.openMapForPlace(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
        }
    }
    
    func openMapForPlace(lat: Double,lng : Double) {
        let url = URL(string: "http://maps.apple.com/maps?saddr=&daddr=\(lat),\(lng)")
        UIApplication.shared.open(url!)
    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        shipdate.text = formatter.string(from: self.datePicker!.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    override func callback() {
        self.postdelnote(orderid: CUSTORDERVC.custid!)
    }
    
    override func gotdel() {
        self.hideindicator()
        self.showmsg(msg: "Details uploaded")
        self.navigationController?.popViewController(animated: true)
    }
    
    override func notdel() {
        self.hideindicator()
        self.showToast(message: "Unable to push data to server")
    }
    
    override func delerr() {
        self.hideindicator()
        self.showToast(message: "Error in API")
    }
    
    override func failcall() {
        self.hideindicator()
        self.showToast(message: "Authentication Error")
    }
    
    @IBAction func donebtn(_ sender: Any) {
        if self.navigationItem.title == "Customer Information" {
            if (self.delnoteslbl.text != self.delnote){
                
                let alert = UIAlertController(title: "Alert", message: "Do you want to update delivery note?", preferredStyle: .alert)
                
                let yes = UIAlertAction(title: "Yes", style: .default) { (result) in
                    self.updatedel(note: self.delnoteslbl.text!,id: CUSTORDERVC.custid!)
                    if (AppDelegate.ntwrk > 0){
                        self.showIndicator("Syncing...", vc: self)
                        self.gettoken()
                    }else{
                        self.showToast(message: "Internet connection required")
                    }
                    alert.dismiss(animated: true, completion: nil)
                }
                
                let no = UIAlertAction(title: "No", style: .destructive) { (result) in
                    alert.dismiss(animated: true, completion: nil)
                }
                
                alert.addAction(yes)
                alert.addAction(no)
                
                self.present(alert, animated: true, completion: nil)
                
            }else if (self.getcancelstate()){
                let alert = UIAlertController(title: "Alert", message: "Do you want to update cancel details?", preferredStyle: .alert)
                
                let yes = UIAlertAction(title: "Yes", style: .default) { (result) in
                    self.updatedel(note: self.delnoteslbl.text!,id: CUSTORDERVC.custid!)
                    if (AppDelegate.ntwrk > 0){
                        self.showIndicator("Syncing...", vc: self)
                        self.gettoken()
                    }else{
                        self.showToast(message: "Internet connection required")
                    }
                    alert.dismiss(animated: true, completion: nil)
                }
                
                let no = UIAlertAction(title: "No", style: .destructive) { (result) in
                    alert.dismiss(animated: true, completion: nil)
                }
                
                alert.addAction(yes)
                alert.addAction(no)
                
                self.present(alert, animated: true, completion: nil)
            }else{
                self.navigationController?.popViewController(animated: true)
            }
        }else if self.navigationItem.title == "Sales Order" {
            
            if (self.orderdatelbl.text! == self.shipdate.text!){
                AppDelegate.isdelivered = true
            }else{
                AppDelegate.isdelivered = false
            }
            
            CUSTORDERVC.orderdate = self.convertDateFormater(date: self.orderdatelbl.text!, input: "EEEE, MMM d, yyyy", output: "yyyy-MM-dd")
            let shipdate = self.convertDateFormater(date: self.shipdate.text!, input: "EEEE, MMM d, yyyy", output: "yyyy-MM-dd")
            let uid = self.getdate(format: "yyyy-MM-dd HH:mm:ss.SSS")
            let ordernum = uid.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: ":", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: " ", with: "")
            AppDelegate.custid = CUSTORDERVC.custid
            CUSTORDERVC.custid = ordernum
            if (AppDelegate.isorder){
                self.getcustheaderdetails()
            }
            if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
                    CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
                guard let currentLocation = locManager.location else {
                    return
                }
                print(currentLocation.coordinate.latitude)
                print(currentLocation.coordinate.longitude)
                self.lati = "\(currentLocation.coordinate.latitude)"
                self.longi = "\(currentLocation.coordinate.longitude)"
            }
            print("\nlat: \(self.lati) - longi: \(self.longi)")
            self.insertorderheader(custid: CUSTOMERINFOVC.custid, userid: UserDefaults.standard.string(forKey: "userid")!, custname: self.name!, custcity: self.city, custstreet: self.street, custstate: self.state, custemail: self.email, custphone: self.phone, lati: self.lati, longi: self.longi, delnote: self.delnote, ordernote: "", custtaxgrp: CUSTORDERVC.custtaxgrp!, custchgrp: CUSTORDERVC.custchgrp, custmod: CUSTORDERVC.custmod, custmodgrp: CUSTORDERVC.custmodgrp, custpricegrp: CUSTORDERVC.pricegrp!, custdisgrp: CUSTORDERVC.discountgrp!, custordernum: ordernum, custordrchcode: "", custorderchval: "0.0", custorderchtax: "0.0", date: CUSTORDERVC.orderdate!, nextdeldate: "", status: "b", lastactivityid : NoDelReason.open.rawValue, pono: pono,shipdate : shipdate, pomandate: CUSTORDERVC.pomandate, post: "0")
            
            self.updatechargesheader(custid: CUSTOMERINFOVC.custid, custchgrp: CUSTORDERVC.custchgrp, custmod: CUSTORDERVC.custmod,custmodgrp : CUSTORDERVC.custmodgrp, orderid: ordernum)
            AppDelegate.setscanresult = false
            self.push(storybId: "MANAGEDEL", vcId: "ADDSONC", vc: self)
        }
    }
    
    func getcancelstate()-> Bool{
        var flag = false
        var stmt1:OpaquePointer?
        let query = "select * from NoDelReason where ordernum = '\(CUSTORDERVC.custid!)' and type = '4' and post = '0'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return flag
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            flag = true
        }
        return flag
    }
    
    
    func getcustheaderdetails(){
        
        var stmt1:OpaquePointer?
        let query = "select lati,longi,modeofdel,custpricegrp,custdisgrp,custchgrp,custtaxgrp,pomandate from custsrch where custid = '\(CUSTOMERINFOVC.custid)' and id = '\(CUSTOMERINFOVC.id!)'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            self.lati = String(cString: sqlite3_column_text(stmt1, 0))
            self.longi = String(cString: sqlite3_column_text(stmt1, 1))
            self.modofdel = String(cString: sqlite3_column_text(stmt1, 2))
            CUSTORDERVC.pricegrp = String(cString: sqlite3_column_text(stmt1, 3))
            CUSTORDERVC.discountgrp = String(cString: sqlite3_column_text(stmt1, 4))
            CUSTORDERVC.custchgrp = String(cString: sqlite3_column_text(stmt1, 5))
            CUSTORDERVC.custtaxgrp = String(cString: sqlite3_column_text(stmt1, 6))
            
        }
        
    }
    
}
