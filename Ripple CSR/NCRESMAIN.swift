//
//  NCRESMAIN.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 07/11/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import SQLite3

class NCRESMAIN: BASEACTIVITY,UITextFieldDelegate {

    
    @IBOutlet var salutation: UITextField!
    @IBOutlet var fname: UITextField!
    
    @IBOutlet var lname: UITextField!
    @IBOutlet var addr: SearchTextField!
    @IBOutlet var suburb: UITextField!
    @IBOutlet var state: UITextField!
    @IBOutlet var postcode: UITextField!
    @IBOutlet var mailaddr: SearchTextField!
    @IBOutlet var mailsuburb: UITextField!
    @IBOutlet var mailstate: UITextField!
    @IBOutlet var mailpostcode: UITextField!
    @IBOutlet var checkbox: UIButton!
    @IBOutlet var country: UITextField!
    @IBOutlet var lati: UITextField!
    
    @IBOutlet var longi: UITextField!
    @IBOutlet var mailcountry: UITextField!
    @IBOutlet var maillati: UITextField!
    @IBOutlet var maillongi: UITextField!
    @IBOutlet var lineofbus_spnr: DropDown!
    @IBOutlet var segment: DropDown!
    
    @IBOutlet var notes: UITextView!
    
    @IBOutlet var mainviewheight: NSLayoutConstraint!   // 1250
    var mailheight = 287
    
    @IBOutlet var mailviewheight: NSLayoutConstraint!    // = 287
    var mainheight = 1162

    @IBOutlet var mailview: UIView!
    
    @IBAction func checkbtn(_ sender: UIButton) {
        animatebtn()
    }
    
    var uid = ""
    
    override func viewWillAppear(_ animated: Bool) {
        self.setnav(title: self.navigationItem.title!)
        addr.delegate = self
        mailaddr.delegate = self
        self.setsegmentspnr()
        self.setLOBspnr()
        self.segment.isSearchEnable = false
        self.lineofbus_spnr.isSearchEnable = false
        
        self.addr.forceNoFiltering = true
        self.addr.startVisibleWithoutInteraction = true
        self.addr.comparisonOptions = [.caseInsensitive]
        self.addr.startSuggestingImmediately = true
        self.addr.theme.font = UIFont.systemFont(ofSize: 14)
        self.addr.theme.bgColor = UIColor.lightGray.withAlphaComponent(1)
        self.addr.theme.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
        self.addr.theme.separatorColor = UIColor.lightGray.withAlphaComponent(0.5)
        self.addr.theme.cellHeight = 35
        self.addr.maxResultsListHeight = 200
        self.addr.theme.placeholderColor = UIColor.lightGray
        
        self.mailaddr.forceNoFiltering = true
        self.mailaddr.startVisibleWithoutInteraction = true
        self.mailaddr.comparisonOptions = [.caseInsensitive]
        self.mailaddr.startSuggestingImmediately = true
        self.mailaddr.theme.font = UIFont.systemFont(ofSize: 14)
        self.mailaddr.theme.bgColor = UIColor.lightGray.withAlphaComponent(1)
        self.mailaddr.theme.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
        self.mailaddr.theme.separatorColor = UIColor.lightGray.withAlphaComponent(0.5)
        self.mailaddr.theme.cellHeight = 35
        self.mailaddr.maxResultsListHeight = 200
        self.mailaddr.theme.placeholderColor = UIColor.lightGray
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var updatedTextString : NSString = textField.text! as NSString
        updatedTextString = updatedTextString.replacingCharacters(in: range, with: string) as NSString
        
        if (textField.tag == 1){
            print("\naddr string -> \(string) | updatedTextString -> \(updatedTextString)")
            addstr = "\(updatedTextString)"
            self.api = 0
//            self.addr.hideResultsList()
            self.setaddr(tag: 1)
        }else if(textField.tag == 2){
            print("\nmail addr string -> \(string) | text -> \(updatedTextString)")
            addstr = "\(updatedTextString)"
            self.api = 2
//            self.mailaddr.hideResultsList()
            self.setaddr(tag: 2)
        }
        return true
    }
    
    func setaddr(tag: Int){
        if (AppDelegate.ntwrk > 0){
            if (tag == 1){
                self.addr.showLoadingIndicator()
            }else if(tag == 2){
                self.mailaddr.showLoadingIndicator()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.getaddrtoken()
            }
        }
    }
    var addridarr = [String]()
    var mailaddridarr = [String]()
    var addstr = "",mailaddstr = ""
    
    override func addrcallback() {
        if (api == 0 || api == 2){
            self.srchaddr(str: addstr)
        }else if (api == 1 || api == 3){
//            self.showIndicator("Loading...", vc: self)
            self.getaddr(id: self.resultid)
        }
    }
    
    override func gotaddr(postcode: String, suburb: String, state: String,country: String, lati: String, longi: String) {
        if (self.api == 1){
            self.state.text = state
            self.postcode.text = postcode
            self.suburb.text = suburb
            self.country.text = country
            self.lati.text = lati
            self.longi.text = longi
        }else if (self.api == 3){
            self.mailstate.text = state
            self.mailpostcode.text = postcode
            self.mailsuburb.text = suburb
            self.mailcountry.text = country
            self.maillati.text = lati
            self.maillongi.text = longi
        }
    }
    
    var api = 0
    var resultid = ""
    var text = ""
    var dtext = ""
    override func gotaddsrch(id: [String], add: [String], text: String) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                if (self.api == 0){
                    self.addridarr.removeAll()
                    self.addridarr = id
                    if (self.text != text){
                        self.addr.filterStrings(add)
                        self.addr.startVisible = true
                        self.addr.stopLoadingIndicator()
                        self.text = text
                        if (add.count > 0){
                            self.addr.itemSelectionHandler = {item, itemPosition in
                                self.addr.text = item[itemPosition].title
                                self.resultid = self.addridarr[itemPosition]
                                self.api = 1
                                self.getaddrtoken()
                            }
                        }
                    }
                }else if (self.api == 2){
                    self.mailaddridarr.removeAll()
                    self.mailaddridarr = id
                    if (self.dtext != text){
                        self.mailaddr.filterStrings(add)
                        self.mailaddr.stopLoadingIndicator()
                        self.dtext = text
                        if (add.count > 0){
                            self.mailaddr.itemSelectionHandler = {item, itemPosition in
                                self.mailaddr.text = item[itemPosition].title
                                self.resultid = self.mailaddridarr[itemPosition]
                                self.api = 3
                                self.getaddrtoken()
                            }
                        }
                    }
                }
            }
        }
    }
    @objc func animatebtn(){
           print("animation started")
           UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
               self.checkbox.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
           
           }) { (success) in
            UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: { [self] in
                   self.checkbox.isSelected = !self.checkbox.isSelected
                   self.checkbox.transform = .identity
                if (self.checkbox.isSelected){
                    self.mailview.isHidden = true
                    self.mailviewheight.constant = 0
                    self.mainviewheight.constant = CGFloat(self.mainheight) - CGFloat(self.mailheight)
                }else{
                    self.mailview.isHidden = false
                    self.mailviewheight.constant = CGFloat(self.mailheight)
                    self.mainviewheight.constant = CGFloat(self.mainheight)
                }
               }, completion: nil)
           }
       }

    func validate() -> Bool {
        var flag : Bool = true
        
        if (self.fname.text!.count == 0 || self.fname.text! == " "){
            flag = false
            self.showToast(message: "First Name is mandatory.")
        }else if ( self.lname.text!.count == 0 || self.lname.text! == " "){
            flag = false
            self.showToast(message: "Last Name is mandatory.")
        }else if ( self.addr.text!.count == 0 || self.addr.text! == " "){
            flag = false
            self.showToast(message: "Address is mandatory.")
        }else if ( self.suburb.text!.count == 0 || self.suburb.text! == " "){
            flag = false
            self.showToast(message: "Suburb is mandatory.")
        }else if ( self.state.text!.count == 0 || self.state.text! == " "){
            flag = false
            self.showToast(message: "State is mandatory.")
        }else if ( self.postcode.text!.count == 0 || self.postcode.text! == " "){
            flag = false
            self.showToast(message: "Postcode is mandatory.")
        }else if ( self.segment.text!.count == 0 || self.segment.text! == " "){
            flag = false
            self.showToast(message: "Segment is mandatory.")
        }
        
        return flag
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        uid = self.getdate(format: "yyyy-MM-dd HH:mm:ss.SSS")
        checkbox.setImage(UIImage(named:"unselected"), for: .normal)
        checkbox.setImage(UIImage(named:"selected"), for: .selected)
//        self.deletetable(tbl: "NewCust")
    }
    var segmentarr = [String]()
    var subsegmentarr = [String]()
    func setsegmentspnr(){
        var stmt1:OpaquePointer?
        
        self.segmentarr.removeAll()
        self.subsegmentarr.removeAll()
        self.segment.optionArray.removeAll()
//        SubSegment(segmentid text, subsegmentid text, descp text)
        let query = "select segmentid || ' - ' || subsegmentid || ' - ' || descp, segmentid, subsegmentid from SubSegment"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let desc = String(cString: sqlite3_column_text(stmt1, 0))
            let segment = String(cString: sqlite3_column_text(stmt1, 1))
            let subseg = String(cString: sqlite3_column_text(stmt1, 2))
            
            self.segment.optionArray.append(desc)
            self.segmentarr.append(segment)
            self.subsegmentarr.append(subseg)
        }
    }
    var lobarr = [String]()
    func setLOBspnr(){
        var stmt1:OpaquePointer?
        self.lobarr.removeAll()
        self.lineofbus_spnr.optionArray.removeAll()
//        LineOfBussiness(lobid text, descp text)
        let query = "select * from LineOfBussiness"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let id = String(cString: sqlite3_column_text(stmt1, 0))
            let desc = String(cString: sqlite3_column_text(stmt1, 1))
            
            self.lobarr.append(id)
            self.lineofbus_spnr.optionArray.append(desc)
        }
    }
    @IBAction func donebtn(_ sender: UIBarButtonItem) {
        if (self.validate()){
//            if (AppDelegate.ntwrk > 0){
            var lob = "",subseg = "",segment = ""
            if (self.lineofbus_spnr.text!.count > 0){
                lob = self.lobarr[self.lineofbus_spnr.selectedIndex!]
            }
            if (self.segment.text!.count > 0){
                subseg = self.subsegmentarr[self.segment.selectedIndex!]
                segment = self.segmentarr[self.segment.selectedIndex!]
            }
                if (self.checkbox.isSelected){
                    self.insertnewcust(uid: self.uid, salutation: self.salutation.text!, custtype: "0", fname: self.fname.text!, lname: self.lname.text!, deladdr: self.addr.text!, delsuburb: self.suburb.text!, delstate: self.state.text!, delpostcode: self.postcode.text!,del_country : "AUS", del_lat : lati.text!, del_long : longi.text!, mail_country : "AUS", mail_lat : lati.text!, mail_long : longi.text!, mailaddr: self.addr.text!, mailsuburb: self.suburb.text!, mailstate: self.state.text!, mailpostcode: self.postcode.text!, abn: "", segment: segment,subsegment: subseg, lob: lob, notes: self.notes.text)
                }else{
                self.insertnewcust(uid: self.uid, salutation: self.salutation.text!, custtype: "0", fname: self.fname.text!, lname: self.lname.text!, deladdr: self.addr.text!, delsuburb: self.suburb.text!, delstate: self.state.text!, delpostcode: self.postcode.text!,del_country : "AUS", del_lat : lati.text!, del_long : longi.text!, mail_country : "AUS", mail_lat : maillati.text!, mail_long : maillongi.text!, mailaddr: self.mailaddr.text!, mailsuburb: self.mailsuburb.text!, mailstate: self.mailstate.text!, mailpostcode: self.mailpostcode.text!, abn: "", segment: segment,subsegment: subseg, lob: lob, notes: self.notes.text)
                }
                let sb = UIStoryboard(name: "NEWCUSTOMER", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "NC2VC") as! NCRESCONVC
                vc.uid = self.uid
                self.navigationController?.pushViewController(vc, animated: true)
//            }else{
//                self.showToast(message: "Internet connection required")
//            }
            
        }
    }
    
}
