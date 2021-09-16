//
//  PRESTARTCHECKLISTVC_first.swift
//  Ripple CSR
//
//  Created by Acxiom Consulting on 08/06/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import SQLite3
import SwiftEventBus
import Alamofire

class PRESTARTCHECKLISTVC_first: BASEACTIVITY,UITableViewDelegate,UITableViewDataSource,ToogleBtnClicked {
    
    func ToogleTapped(at index: IndexPath) {
            setlist()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return preadapter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "prefirstcell", for: indexPath) as! PreStartCheckList_first
        
        let list: PREFIRSTADAPTER
        list = preadapter[indexPath.row]
        
        cell.desclbl.text = list.desclabel
        cell.tooglebtn.isOn = list.toogele
        cell.delegate = self
        cell.indexPath = indexPath
        cell.desc = list.info
        cell.uid = list.uid
        
        tableView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
  
    var preadapter = [PREFIRSTADAPTER]()
    var tablecreate = [PrestartTableAdapter]()
    var i = 0
    
    @IBOutlet var pretable: UITableView!
    @IBOutlet var odometer: UITextField!
    @IBOutlet var datelbl: UILabel!
    @IBOutlet var userlbl: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        self.setbg()
        self.setnav(title: self.navigationItem.title!)
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (UserDefaults.standard.string(forKey: "uname") != nil && UserDefaults.standard.string(forKey: "uname")! != ""){
            self.userlbl.text = UserDefaults.standard.string(forKey: "uname")!
        }else{
            self.userlbl.text = UserDefaults.standard.string(forKey: "userid")
        }
        
        datelbl.text = self.getdate(format: "dd/MM/yy")
        initdata()
                
        self.navigationItem.rightBarButtonItem = getbarbutton()
        SwiftEventBus.onMainThread(self, name: "gotcom") { (result) in
            print("\n*** goto compliance called ***\n")
            self.view.isUserInteractionEnabled = true
            self.hideindicator()
            self.push(storybId: "COMPLIANCE", vcId: "COMPLIANCENC", vc: self)
            UserDefaults.standard.set(self.getdate(format: "yyyy-MM-dd"), forKey: "predate")
        }
        
        SwiftEventBus.onMainThread(self, name: "notcom") { (result) in
            self.view.isUserInteractionEnabled = true
            self.hideindicator()
            self.showToast(message: "Error in API")
        }
        
        SwiftEventBus.onMainThread(self, name: "cskip") { (result) in
            self.hideindicator()
            self.push(storybId: "TRUCKLOAD", vcId: "TRUCKLOADFIRSTNC", vc: self)
           UserDefaults.standard.set(self.getdate(format: "yyyy-MM-dd"), forKey: "comdate")
        }
//        SwiftEventBus.onMainThread(self, name: "cdone") { (result) in
//            print("\n*** cdone called 1 ***\n")
//            self.push(storybId: "RUNSUMMARY", vcId: "RUNSUMMARYNC", vc: self)
//               UserDefaults.standard.set(self.getdate(format: "yyyy-MM-dd"), forKey: "predate")
//        }
//        SwiftEventBus.onMainThread(self, name: "cnot") { (result) in
//            self.showToast(message: "Something went wrong")
//            self.view.isUserInteractionEnabled = true
//            self.navigationItem.rightBarButtonItem?.isEnabled = true
//        }
//        SwiftEventBus.onMainThread(self, name: "cerr") { (result) in
//            self.showToast(message: "Server not reachable")
//            self.view.isUserInteractionEnabled = true
//            self.navigationItem.rightBarButtonItem?.isEnabled = false
//        }
    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        SwiftEventBus.unregister(self)
//    }
    
    override func callback() {
        if (i == 1){
            self.getpincode()
        }else if (i == 2){
            self.postpcondition(type: "1")
        }
    }
    
    override func pingot() {
            self.buttonPressed()
        }
    override func pinnot(){
        self.hideindicator()
        self.view.isUserInteractionEnabled = true
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.showToast(message: "Pin code generation failed due to API error")
    }
    override func pinerr(){
        self.hideindicator()
        self.view.isUserInteractionEnabled = true
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.showToast(message: "Pin code generation failed due to server error")
    }
    
    override func failcall() {
        self.view.isUserInteractionEnabled = true
        self.showToast(message: "Authentication failed!!!")
        self.hideindicator()
    }
    @objc override func buttonPressed(){
        if (odometer.text!.count > 0){
                   var stmt1:OpaquePointer?
            saveodometer(odometer: self.odometer.text!)
                   let query = "select * from PreStartChecklist where toogle = 'false'"
                                           
                   if sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
                   let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                   print("error preparing get: \(errmsg)")
                      return
                   }
                   if(sqlite3_step(stmt1) == SQLITE_ROW){
                    if (AppDelegate.ntwrk > 0){
                                    self.navigationItem.rightBarButtonItem?.isEnabled = false
                                    self.showIndicator("Loading...", vc: self)
                                if (UserDefaults.standard.string(forKey: "pincode") == nil || UserDefaults.standard.string(forKey: "pincode")! == ""){
                                    self.i = 1
                                    self.gettoken()
                                }else{
                                    self.hideindicator()
                                    self.view.isUserInteractionEnabled = true
                                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                                    self.push(storybId: "PRESTARTCHECKLIST", vcId: "PRE_third", vc: self)
                                }
                                }else{
                                    self.showToast(message: "Internet connection required to continue...")
                                }
                   
                   }else{
                    if (AppDelegate.ntwrk > 0){
                        self.view.isUserInteractionEnabled = false
                        self.navigationItem.rightBarButtonItem?.isEnabled = false
                        self.showIndicator("Loading...", vc: self)
                        if (UserDefaults.standard.string(forKey: "pincode") == nil || UserDefaults.standard.string(forKey: "pincode")! == ""){
                            self.i = 1
                        }else{
                            self.i = 2
                        }
                        self.gettoken()
                    }else{
                        self.showToast(message: "Internet connection required to continue...")
                    }                  
                    
                   }
               }else{
                   self.showToast(message: "Odometer Reading is Mandatory")
               }
    }

    func initdata(){
           self.pretable.delegate = self
           self.pretable.dataSource = self
        
        setlist()
        
//        self.insertcustorder(custid: "201887463", userid: "Test", itemid: "WA01", qty: "10", date: self.getdate(format: "yyyy-MM-dd"), price: "20.0", status: "0")
//        self.insertcustorder(custid: "201887463", userid: "Test", itemid: "WA02", qty: "20", date: self.getdate(format: "yyyy-MM-dd"), price: "30.0", status: "0")
//        self.insertcustorder(custid: "201887463", userid: "Test", itemid: "WA03", qty: "100", date: self.getdate(format: "yyyy-MM-dd"), price: "90.0", status: "0")
    }
    
    func setlist(){
        
        var stmt1:OpaquePointer?
        
        let query = "Select * from PreStartChecklist order by uid"
        
        preadapter.removeAll()
        
        if sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            
            let description = String(cString: sqlite3_column_text(stmt1, 2))
               let info = String(cString: sqlite3_column_text(stmt1, 3))
               let toogle = String(cString: sqlite3_column_text(stmt1, 4))
            let uid = String(cString: sqlite3_column_text(stmt1, 0))
            
            preadapter.append(PREFIRSTADAPTER(description: description, toogle: Bool(toogle)!,info : info,uid : uid))
        }
        self.pretable.reloadData()
    }
    
    //    MARK:- POST CONDITION
        func postpcondition(type : String){
            let todosEndpoint: String = CONSTANT.BASE_URL + "AcxDriverApp/AcxDriverAppService/postConditionHistory"

            let headers = [
                "Authorization": "Bearer \(self.accessToken)",
                ]
            
            var parameters: [String: AnyObject] = [:]
            var array: [AnyObject] = []
            var body: [String: [AnyObject]] = [:]
            
            var stmt1:OpaquePointer?

            var query = ""
            if (type == "1"){
                query = "select uid,toogle,userid,date,odometer,remarks,'' as starttime,description,information from PreStartChecklist where post = '0'"
            }else if (type == "2"){
                query = "select uid,toogle,userid,date,'0' as odometer,remarks,starttime,description,information from Compliance where post = '0'"
            }
                              
                     if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
                         let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                         print("error preparing get: \(errmsg)")
                         return
                     }
            //Custorder(custid text,userid text, itemid text, qty text, date text, price text, totvalue text, status text,post text)
                     while(sqlite3_step(stmt1) == SQLITE_ROW){
    //                    parameters.removeAll()
                        let cid = String(cString: sqlite3_column_text(stmt1, 0))
                        let status = String(cString: sqlite3_column_text(stmt1, 1)) == "true" ? 1 : 0
                        let userid = String(cString: sqlite3_column_text(stmt1, 2))
                        let submitdatetine = String(cString: sqlite3_column_text(stmt1, 3))
                        let odometer = String(cString: sqlite3_column_text(stmt1, 4))
                        let resnote = String(cString: sqlite3_column_text(stmt1, 5))
                        let starttime = String(cString: sqlite3_column_text(stmt1, 6))
                        let cname = String(cString: sqlite3_column_text(stmt1, 7))
                        let cdesc = String(cString: sqlite3_column_text(stmt1, 8))
                        
                        parameters = [
                            "conditionType" : type as AnyObject,
                            "ConditionId" : cid as AnyObject,
                            "Stauts" : status as AnyObject,
                            "UserID" : userid as AnyObject,
                            "SubmittedDateTime" : submitdatetine as AnyObject,
                            "OdometerReading" : odometer as AnyObject,
                            "ResolutionNote" : resnote as AnyObject,
                            "StartTime" : starttime as AnyObject,
                            "ConditionName" : cname as AnyObject,
                            "ConditionDescription" : cdesc as AnyObject
                            ]
                        array.append(parameters as AnyObject)
                     }
            body = [
                "conditionHistory": array
                ]
            print("\nbody ---- > \n \(body)")
                    Alamofire.request(todosEndpoint, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
                        .responseJSON { response in
                            switch response.result {
                            case .success:
                                print("response.request \(response.request)")  // original URL request
                                print("response.response \(response.response)") // HTTP URL response
                                print("response.result.value \(response.result)")     // server data
                                print("response.result \(response.result)")
                                print("\n*******************************************************\n")
                                print("\nresponse.result.value \(response.result.value!) \n\n")
                                if (response.response?.statusCode == 200){
                                    self.updateconditiontable(type: type)
                                    print("\n*** cdone fired ***\n")
//                                    self.push(storybId: "RUNSUMMARY", vcId: "RUNSUMMARYNC", vc: self)
//                                    self.push(storybId: "COMPLIANCE", vcId: "COMPLIANCENC", vc: self)
                                    self.getcondition(type: "2")
                                       UserDefaults.standard.set(self.getdate(format: "yyyy-MM-dd"), forKey: "predate")
                                }else{
                                    self.showToast(message: "Error in API")
                                    self.view.isUserInteractionEnabled = true
                                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                                    self.hideindicator()
                                }
                                
                            case .failure(let error):
                                self.showToast(message: "Server not reachable")
                                self.view.isUserInteractionEnabled = true
                                self.navigationItem.rightBarButtonItem?.isEnabled = true
                                self.hideindicator()
                            print("error \(error)")
                    }
                }
        }
    
    
}
