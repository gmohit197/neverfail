//
//  COMPLIANCETHIRDVC.swift
//  Ripple CSR
//
//  Created by Acxiom Consulting on 11/06/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import SQLite3
import MaterialComponents
import SwiftEventBus
import Alamofire

class COMPLIANCETHIRDVC: BASEACTIVITY,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comadapter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "comthirdcell", for: indexPath) as! COMPLIANCEthird_cell
        
        let list: PRETHIRDADAPTER
        list = comadapter[indexPath.row]
        
//        self.gettextwithimage(image: "delete", mobileLabel: cell.desclbl, text: list.desclbl, textalignment: .left)
        cell.desclbl.text = list.desclbl
        cell.resolutionnote.text = list.edittext
        cell.index = list.uid
        cell.indexpath = indexPath
        
        tableView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        print("cell off display - \(indexPath.row)")
        
       let cell = tableView.dequeueReusableCell(withIdentifier: "comthirdcell", for: indexPath) as! COMPLIANCEthird_cell
        
        let list: PRETHIRDADAPTER
        list = comadapter[indexPath.row]
        if cell.resolutionnote.text!.count > 0 {
        list.edittext = cell.resolutionnote.text!
        }else{
        list.edittext = ""
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("cell will display - \(indexPath.row)")
        
       let cell = tableView.dequeueReusableCell(withIdentifier: "comthirdcell", for: indexPath) as! COMPLIANCEthird_cell
        
        let list: PRETHIRDADAPTER
        list = comadapter[indexPath.row]
        
        cell.resolutionnote.text = list.edittext
    }
    
    
    @IBOutlet var datelbl: UILabel!
   
    @IBOutlet var userlbl: UILabel!
    @IBOutlet var pincodeedt: MDCTextField!
    var pincodecontroller: MDCTextInputControllerOutlined!
    @IBOutlet var thirdtable: UITableView!
    
    var comadapter = [PRETHIRDADAPTER]()
    @IBOutlet var innerview: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.innerview.backgroundColor = UIColor.clear
        self.setbg()
        pincodecontroller = MDCTextInputControllerOutlined(textInput: pincodeedt)
        pincodeedt.sizeToFit()
        self.setnav(title: "Compliance Passport")
        pincodecontroller.setfordark(field: pincodeedt, controller: self)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // Trait collection has already changed
     pincodecontroller.setfordark(field: pincodeedt, controller: self)
    }
    
    @IBAction func donebtn(_ sender: Any) {
    
        var stmt1:OpaquePointer?
                
        let query = "select remarks from Compliance where toogle = 'false' and remarks = ''"
                
        if sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        let pin = UserDefaults.standard.string(forKey: "pincode")!

        if(sqlite3_step(stmt1) == SQLITE_ROW){
            self.showToast(message: "Resolution Note to be Filled for all Entries")
        }else if ((self.pincodeedt.text?.count) == 0){
            self.showToast(message: "Pincode is Mandatory")
        }else if (self.pincodeedt.text! != pin){
            self.showToast(message: "Pincode is Incorrect")
        }else{
            if (AppDelegate.ntwrk > 0){
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                self.showIndicator("Loading...", vc: self)
                self.gettoken()
            }else{
                self.showToast(message: "Internet connection required to continue...")
            }  
        }        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (UserDefaults.standard.string(forKey: "uname") != nil && UserDefaults.standard.string(forKey: "uname")! != ""){
            self.userlbl.text = UserDefaults.standard.string(forKey: "uname")!
        }else{
            self.userlbl.text = UserDefaults.standard.string(forKey: "userid")
        }
        self.datelbl.text = self.getdate(format: "dd/MM/yy")
        self.thirdtable.delegate = self
        self.thirdtable.dataSource = self
        
        setlist()
        
//        SwiftEventBus.onMainThread(self, name: "cdone") { (result) in
//            self.push(storybId: "TRUCKLOAD", vcId: "TRUCKLOADFIRSTNC", vc: self)
//           UserDefaults.standard.set(self.getdate(format: "yyyy-MM-dd"), forKey: "comdate")
//        }
//        SwiftEventBus.onMainThread(self, name: "cnot") { (result) in
//            self.navigationItem.rightBarButtonItem?.isEnabled = true
//            self.showToast(message: "Something went wrong")
//        }
//        SwiftEventBus.onMainThread(self, name: "cerr") { (result) in
//            self.navigationItem.rightBarButtonItem?.isEnabled = true
//            self.showToast(message: "Server not reachable")
//        }
    }
    override func callback() {
        self.postccondition(type: "2")
    }
    override func failcall() {
        self.view.isUserInteractionEnabled = false
        self.showToast(message: "Authentication failed!!!")
        self.hideindicator()
    }
    func setlist(){
        var stmt1:OpaquePointer?
                
        let query = "select uid,description,ifnull(remarks,'') as remarks from Compliance where toogle = 'false'"
                
        comadapter.removeAll()
                
        if sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
        let uid = String(cString: sqlite3_column_text(stmt1, 0))
            let desc = String(cString: sqlite3_column_text(stmt1, 1))
            let edt = String(cString: sqlite3_column_text(stmt1, 2))
            comadapter.append(PRETHIRDADAPTER(uid: uid, description: desc, edttxt: edt))
        }
        self.thirdtable.reloadData()
    }
    //    MARK:- POST CONDITION
        func postccondition(type : String){
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
                                    self.hideindicator()
                                    self.push(storybId: "TRUCKLOAD", vcId: "TRUCKLOADFIRSTNC", vc: self)
                                   UserDefaults.standard.set(self.getdate(format: "yyyy-MM-dd"), forKey: "comdate")
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
