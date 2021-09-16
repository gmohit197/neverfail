//
//  ExecuteApi.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 21/10/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftEventBus
import SQLite3

public class ExecuteApi : Databaseconnection {
    
    var accessToken : String = ""
    
    //    MARK:- Token api
    func gettoken(){
        
        if CONSTANT.IS_TOKEN_REQ {
            let parameters = [
                "resource"         : CONSTANT.LOGIN_RESOURCE,
                "client_id"         :  CONSTANT.CL_ID,
                "client_secret" : CONSTANT.CL_SC,
                "grant_type"     : "client_credentials"
            ]
            
            Alamofire.request(CONSTANT.URL, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
                switch response.result {
                case .success:
                    
                    if let json = response.result.value as? [String:Any]{
                        print("\(json["access_token"] as! String)")
                        print("\n\n ====================>> \n\n")
                        print("\(response.result.value!)")
                        let at = json["access_token"] as! String
                        if (self.accessToken == at){
                            print("\n\n******** token is same *******\n\n")
                        }else{
                            print("\n\n******** token is changed *******\n\n")
                        }
                        self.accessToken = json["access_token"] as! String
                        self.set_header()
                        self.callback()
                    }
                    
                case .failure(let error):
                    self.failcall()
                    self.accessToken = ""
                    print(error)
                }}
        }else{
            self.set_header()
            self.callback()
        }
    }
    
    static var header : HTTPHeaders?
    
    func set_header(){
        if (CONSTANT.IS_TOKEN_REQ){
            ExecuteApi.header = [
                "Authorization": "Bearer \(self.accessToken)",
                "Prefer"                                : "return=representation"
            ]
            CONSTANT.BASE_URL = CONSTANT.BASE_URL_FnO
        }else{
            if (CONSTANT.RESOURCE.contains("https://apimtst.ccamatil.com/p/neverfail") == true){
                ExecuteApi.header = [
                    "Ocp-Apim-Subscription-Key" : "2393180e646f46d2b2178c840a88d001",
                    "Ocp-Apim-Trace" : "true",
                    "Prefer"                                : "return=representation"
                ]
            }else{
                ExecuteApi.header = [
                    "Ocp-Apim-Subscription-Key" : "ea9d9ed679c648ad886323b75c58bdbd",
                    "Ocp-Apim-Trace" : "true",
                    "Prefer"                                : "return=representation"
                ]
            }
            CONSTANT.BASE_URL = CONSTANT.BASE_URL_FnO
        }
    }
    
    func callback(){}
    func crmcallback(){}
    func failcall(){}
    
    //    MARK:- ADDRESS TOKEN
    func getaddrtoken(){
        
        let parameters = [
            "resource"         : CONSTANT.CL_ID,
            "client_id"         :  CONSTANT.CL_ID,
            "client_secret" : CONSTANT.CL_SC,
            "grant_type"     : "client_credentials",
        ] 
        
        Alamofire.request(CONSTANT.URL, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                
                if let json = response.result.value as? [String:Any]{
                    print("\(json["access_token"] as! String)")
                    print("\n\n ====================>> \n\n")
                    print("\(response.result.value!)")
                    self.accessToken = json["access_token"] as! String
                    self.addrcallback()
                }
                
            case .failure(let error):
                self.failcall()
                self.accessToken = ""
                print(error)
            }}
    }
    public func addrcallback(){
    }
//    MARK:- SUMMARY TOKEN
    func getsumtoken(){
        
        let parameters = [
            "resource"         : CONSTANT.CL_ID,
            "client_id"         :  CONSTANT.CL_ID,
            "client_secret" : CONSTANT.CL_SC,
            "grant_type"     : "client_credentials"
        ]
        
        Alamofire.request(CONSTANT.URL, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                
                if let json = response.result.value as? [String:Any]{
                    print("\(json["access_token"] as! String)")
                    print("\n\n ====================>> \n\n")
                    print("\(response.result.value!)")
                    self.accessToken = json["access_token"] as! String
                    self.sumcallback()
                }
                
            case .failure(let error):
                self.failcall()
                self.accessToken = ""
                print(error)
            }}
    }
    public func sumcallback(){
    }
    
    
    //    MARK:- version api
    func getversion(){
        let todosEndpoint: String = "https://neverfailaed85ff70560dec7devaos.cloudax.dynamics.com/AcxDriverApp/AcxDriverAppService/getVersionDetails"
        
        let headers = [
            "Authorization": "Bearer \(self.accessToken)",
        ]
        
        var body: [String: [AnyObject]] = [:]
        
        Alamofire.request(todosEndpoint, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ExecuteApi.header)
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("response.request \(response.request)")  // original URL request
                    print("response.response \(response.response)") // HTTP URL response
                    print("response.result.value \(response.result)")     // server data
                    print("response.result \(response.result)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    if let json = response.result.value as? [[String:Any]] { // <- Swift Array
                        let result = json[0]
                        print("\n==>version - \(result["versionCode"]!)")
                        UserDefaults.standard.set("\(result["versionCode"]!)", forKey: "version")
                        SwiftEventBus.post("gotversion")
                    }
                    
                case .failure(let error):
                    SwiftEventBus.post("gotversion")
                    print("error \(error) - url \(todosEndpoint)")
                }
            }
    }
    //    MARK:- GET USERINFO
    func getuserdetail(userid: String){
        let todosEndpoint: String = CONSTANT.BASE_URL + "AcxDriverApp/AcxDriverAppService/getUserDetails"
        
        var body: [String: [AnyObject]] = [:]
        var parameter: [String: AnyObject] = [:]
        var array: [AnyObject] = []
        
        parameter = [
            "Email Address": userid as AnyObject
        ]
        array.append(parameter as AnyObject)
        
        body = [
            "email" : array
        ]
        
        print("\n\n body --> \n\(body)")
        Alamofire.request(todosEndpoint, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ExecuteApi.header)
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
                        if let json = response.result.value as? [[String:Any]] { // <- Swift Array
                            let result = json[0]
                            print("\n==>Name - \(result["Name"]!)")
                            let name = "\(result["Name"]!)"
                            let driverid = "\(result["User id"]!)"
                            
                            if (name != ""){
                                UserDefaults.standard.set(name, forKey: "uname")
                                UserDefaults.standard.set(driverid, forKey: "did")
                                self.gotname()
                            }else{
                                self.notname()
                            }
                        }else{
                            UserDefaults.standard.set("", forKey: "uname")
                            self.notname()
                        }
                    }else{
                        UserDefaults.standard.set("", forKey: "uname")
                        self.nameerr()
                    }
                    
                    
                case .failure(let error):
                    UserDefaults.standard.set("", forKey: "uname")
                    self.nameerr()
                    print("error \(error) - url \(todosEndpoint)")
                }
            }
    }
    
    public func gotname(){
    }
    public func notname(){
    }
    public func nameerr(){}
    
    //    MARK:- condition api
    func getcondition(type : String ){
        
        let todosEndpoint: String = CONSTANT.BASE_URL  + "AcxDriverApp/AcxDriverAppService/getConditionDetails"
        
        let headers = [
            "Authorization": "Bearer \(self.accessToken)",
        ]
        
        var parameters: [String: AnyObject] = [:]
        var array: [AnyObject] = []
        var body: [String: [AnyObject]] = [:]
        parameters = [
            "conditionType" : type as AnyObject,
            "UserID" : UserDefaults.standard.string(forKey: "userid") as AnyObject
        ]
        array.append(parameters as AnyObject)
        body = [
            "conditionType": array
            
        ]
        print("body ---->\n \(body)\n")
        Alamofire.request(todosEndpoint, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ExecuteApi.header)
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(todosEndpoint)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    var status = "0"
                    if (type == "1"){
                        self.deletetable(tbl: "PreStartChecklist")
                    }else if(type == "2"){
                        self.deletetable(tbl: "Compliance")
                    }
                    var odometer = ""
                    var starttime = ""
                    if let json = response.result.value as? [[String:Any]] { // <- Swift Array
                        for result in json{
                            
                            let uid = result["ConditionId"]!
                            let desc = result["ConditionName"]!
                            let info  = result["ConditionDescription"]!
                            status = "\(result["Status"]!)"
                            odometer = result["Odometer"]! as! String
                            starttime = result["StartTime"]! as! String
                            
                            let userid = UserDefaults.standard.string(forKey: "userid")
                            
                            if (type == "1"){
                                self.insertprechecktable(uid: uid as! String, userid: userid!, description: desc as! String, information: info as! String, toogle: "false")
                            }else if (type == "2"){
                                self.insertcompliancetable(uid: uid as! String, userid: userid!, description: desc as! String, information: info as! String, toogle: "false")
                            }
                            print("\n==>type - \(type) - \(result["ConditionName"]!)")
                        }
                        print("\n status == > \(status)")
                        if (type == "1"){
                            if (status == "1"){
                                SwiftEventBus.post("pskip")
                                self.pskip()
                                self.saveodometer(odometer: odometer)
                            }else{
                                SwiftEventBus.post("gotpre")
                                self.gotpre()
                                print("\n*** prestart event fired ***\n")
                            }
                        }else if(type == "2"){
                            if (status == "1"){
                                SwiftEventBus.post("cskip")
                                self.cskip()
                                self.savestarttime(starttime: starttime)
                            }else{
                                print("\n*** compliance event fired ***\n")
                                SwiftEventBus.post("gotcom")
                                self.gotcom()
                            }
                        }
                    }else{
                        if (type == "1"){
                            SwiftEventBus.post("notpre")
                            self.notpre()
                        }else if(type == "2"){
                            SwiftEventBus.post("notcom")
                            self.notcom()
                        }
                    }
                    
                case .failure(let error):
                    if (type == "1"){
                        SwiftEventBus.post("errpre")
                        self.errpre()
                    }else if(type == "2"){
                        SwiftEventBus.post("errcom")
                        self.errcom()
                    }
                    
                    print("error \(error) - url \(todosEndpoint)")
                }
            }
    }
    
    public func pskip(){}
    public func errpre(){}
    public func errcom(){}
    public func notcom(){}
    public func notpre(){}
    public func gotcom(){}
    public func cskip(){}
    public func gotpre(){}
    
    //    MARK:- validate user api
    func validateuser(username: String, password: String){
        
        let parameters = [
            "resource"         : CONSTANT.LOGIN_RESOURCE,
            "client_id"         :  CONSTANT.CL_ID,
            "client_secret" : CONSTANT.CL_SC,
            "grant_type" : "password",
            "username" :  username,
            "password" : password
        ]
        Alamofire.request(CONSTANT.URL, method: .post, parameters: parameters, encoding: URLEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("body --->\n \(parameters)\n")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    //                            self.showToast(message: "Status : \(response.response!.statusCode)")
                    if  (response.response!.statusCode == 200){
                        if let json = response.result.value as? [String:Any]{
                            print("\(json["access_token"] as! String)")
                            print("\n\n ====================>> \n\n")
                            //                                    self.accessToken = json["access_token"] as! String
                            //                                    SwiftEventBus.post("VD")
                            self.VD()
                        }
                    }
                    else{
                        //                            SwiftEventBus.post("INVD")
                        self.INVD()
                    }
                    
                case .failure(let error):
                    //                        SwiftEventBus.post("ERR")
                    self.ERR()
                    print("error \(error)")
                    
                }
            }
    }
    
    public func VD(){}
    public func INVD(){}
    public func ERR(){}
    
    //    MARK:- POST LEAD
    var leadindex = -1
    var noteindex = -1
    var leadadapter = [LEADMODEL]()
    var noteadapter = [NOTEMODEL]()
    
    func postlead(token: String){
        
        self.leadadapter.removeAll()
        var stmt1:OpaquePointer?
        self.leadindex = 0
        
        let query = "select uid ,subject ,firstname ,lastname , mobilephone ,telephone1 ,emailaddress1 ,companyname ,address1_line1 ,address1_city ,address1_stateorprovince , address1_postalcode ,ifnull(revenue,'0') ,ifnull(numberofemployees,'0') ,Jobtitle , ABN ,sourceinfo , contactmethod, topic from lead where post = '0'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW ){
            let uid = String(cString: sqlite3_column_text(stmt1, 0))
            let firstname = String(cString: sqlite3_column_text(stmt1, 2))
            let lastname = String(cString: sqlite3_column_text(stmt1, 3))
            let mobilephone = String(cString: sqlite3_column_text(stmt1, 4))
            let telephone1 = String(cString: sqlite3_column_text(stmt1, 5))
            let emailaddress1 = String(cString: sqlite3_column_text(stmt1, 6))
            let companyname = String(cString: sqlite3_column_text(stmt1, 7))
            let address1_line1 = String(cString: sqlite3_column_text(stmt1, 8))
            let address1_city = String(cString: sqlite3_column_text(stmt1, 9))
            let address1_stateorprovince = String(cString: sqlite3_column_text(stmt1, 10))
            let address1_postalcode = String(cString: sqlite3_column_text(stmt1, 11))
            let revenue = sqlite3_column_int(stmt1, 12)
            let numberofemployees = sqlite3_column_int(stmt1, 13)
            let topic = String(cString: sqlite3_column_text(stmt1, 18))
            
            self.leadadapter.append(LEADMODEL(uid: uid, firstname: firstname, lastname: lastname, mobilephone: mobilephone, telephone1: telephone1, emailaddress1: emailaddress1, companyname: companyname, address1_line1: address1_line1, address1_city: address1_city, address1_stateorprovince: address1_stateorprovince, address1_postalcode: address1_postalcode, revenue: Int(revenue), numberofemployees: Int(numberofemployees), Jobtitle: "", ABN: "", sourceinfo: "", contactmethod: "", topic: topic))
            
        }
        if (self.leadadapter.count > 0){
            self.sendlead()
        }else{
            SwiftEventBus.post("note")
            self.note()
        }
    }
    func sendlead(){
        var todosEndpoint: String = CONSTANT.RESOURCE_CRM + "/api/data/v9.1/leads"
        
        var headers = [
            "Authorization"                :   "\(self.accessToken)",
            "Content-Type"                : "application/json",
            "OData-MaxVersion"      : "4.0",
            "OData-Version"               : "4.0",
            "Accept"                            : "application/json",
            "Prefer"                                : "return=representation"
        ]
        if CONSTANT.IS_TOKEN_REQ {
            headers = ExecuteApi.header!
            todosEndpoint = CONSTANT.BASE_URL_CRM + "leads"
        }
        var body: [String: AnyObject] = [:]
        
        let list : LEADMODEL
        list = self.leadadapter[leadindex]
        
        body = [
            "subject" : list.topic as AnyObject,
            "firstname" : list.firstname as AnyObject,
            "lastname" : list.lastname as AnyObject,
            "mobilephone" : list.mobilephone as AnyObject,
            "telephone1" : list.telephone1 as AnyObject,
            "emailaddress1" : list.emailaddress1 as AnyObject,
            "companyname" : list.companyname as AnyObject,
            "address1_line1" : list.address1_line1 as AnyObject,
            "address1_city" : list.address1_city as AnyObject,
            "address1_stateorprovince" : list.address1_stateorprovince as AnyObject,
            "address1_postalcode" : list.address1_postalcode as AnyObject,
            "revenue" : list.revenue as AnyObject,
            "numberofemployees" : list.numberofemployees as AnyObject,
            "new_recordid" : list.uid as AnyObject
        ]
        print("body ---->\n \(body)\n")
        Alamofire.request(todosEndpoint, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(todosEndpoint)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    if  (self.isResponseOK(code: response.response!.statusCode)){ // 201 - created ocde
                        if let json = response.result.value as? [String:Any]{
                            print("\(json["leadid"] as! String)")
                            print("\n\n ====================>> \n\n")
                            let lead_id = json["leadid"] as! String
                            let uid = json["new_recordid"] as! String
                            self.updatelead(oldid: uid, newid: lead_id)
                        }}
                    else{
                        CONSTANT.leadname.append("\(list.firstname!) \(list.lastname!)")
                    }
                    self.leadindex += 1
                    if (self.leadindex < self.leadadapter.count){
                        self.sendlead()
                    }else{
                        SwiftEventBus.post("lead")
                        self.lead()
                    }
                    
                case .failure(let error):
                    CONSTANT.leadname.append("\(list.firstname!) \(list.lastname!)")
                    self.leadindex += 1
                    if (self.leadindex < self.leadadapter.count){
                        self.sendlead()
                    }else{
                        SwiftEventBus.post("lead")
                        self.lead()
                    }
                    print("error \(error) - url \(todosEndpoint)")
                }
            }
    }
    
    public func lead(){}
    
    func isResponseOK(code: Int) -> Bool {
          return (200...299).contains(code)
         }
    
    func postleadnote(){
        
        var stmt1:OpaquePointer?
        self.noteindex = 0
        CONSTANT.notename.removeAll()
        
        var query = "select leadid ,subject, note,firstname ,lastname from lead where subject <> '' and note <> '' and post = '1'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let id = String(cString: sqlite3_column_text(stmt1, 0))
            let subject = String(cString: sqlite3_column_text(stmt1, 1))
            let note = String(cString: sqlite3_column_text(stmt1, 2))
            let fname = String(cString: sqlite3_column_text(stmt1, 3))
            let lname = String(cString: sqlite3_column_text(stmt1, 4))
            
            self.noteadapter.append(NOTEMODEL(leadid: id, subject: subject, note: note, fname: fname, lname: lname))
            
        }
        if (self.noteadapter.count > 0){
            self.sendnote()
        }else{
            SwiftEventBus.post("note")
            self.note()
        }
    }
    
    func sendnote(){
        var todosEndpoint: String = CONSTANT.RESOURCE_CRM + "/api/data/v9.1/annotations"
        
        var headers = [
            "Authorization"                :   "\(self.accessToken)",
            "Content-Type"                : "application/json",
            "OData-MaxVersion"      : "4.0",
            "OData-Version"               : "4.0",
            "Accept"                            : "application/json"
        ]
        if CONSTANT.IS_TOKEN_REQ {
            headers = ExecuteApi.header!
            todosEndpoint = CONSTANT.BASE_URL_CRM + "annotations"
        }
        
        var body: [String: AnyObject] = [:]
        let list : NOTEMODEL
        list = self.noteadapter[noteindex]
        
        body = [
            "notetext" : list.note as AnyObject,
            "subject" : list.subject as AnyObject,
            "objectid_lead@odata.bind" : "/leads(\(list.leadid!))" as AnyObject
        ]
        print("body ---->\n \(body)\n")
        Alamofire.request(todosEndpoint, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(todosEndpoint)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    if  (self.isResponseOK(code: response.response!.statusCode)){ // 204 - no content but success
                        self.updateleadnote(id: list.leadid)
                    }else{
                        CONSTANT.notename.append("\(list.fname!) \(list.lname!)")
                    }
                    self.noteindex += 1
                    if (self.noteindex < self.noteadapter.count){
                        self.sendnote()
                    }else{
                        SwiftEventBus.post("note")
                        self.note()
                    }
                    
                case .failure(let error):
                    self.noteindex += 1
                    if (self.noteindex < self.noteadapter.count){
                        self.sendnote()
                    }else{
                        SwiftEventBus.post("note")
                        self.note()
                    }
                    print("error \(error) - url \(todosEndpoint)")
                }
            }
    }
    
    public func note(){}
    
    //    MARK:- CRM CLIENT
    func getcrmtoken(username: String = UserDefaults.standard.string(forKey: "userid")!,password : String = UserDefaults.standard.string(forKey: "pwd")!){
        
        if CONSTANT.IS_TOKEN_REQ {
            let todosEndpoint: String = "https://login.microsoftonline.com/31f6eb2e-90b9-4668-9645-fec7390e62c6/oauth2/token"
            
            let parameters = [
                "resource"         : CONSTANT.RESOURCE_CRM,
                "client_id"         :  "e75ddb21-e309-4e39-b974-fdb912de4643",
                "client_secret" : "a61K2ue~p.zTFaV4Y___h7FsDb1Gp84ob2",
                "grant_type"     : "client_credentials",
//                "username" :  username,
//                "password" : password
            ]
            Alamofire.request(todosEndpoint, method: .post, parameters: parameters, encoding: URLEncoding.default)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        print("body --->\n \(parameters)\n")
                        print("\n*******************************************************\n")
                        print("\nresponse.result.value \(response.result.value!) \n\n")
                        //                            self.showToast(message: "Status : \(response.response!.statusCode)")
                        if  (response.response!.statusCode == 200){
                            if let json = response.result.value as? [String:Any]{
                                print("\(json["access_token"] as! String)")
                                print("\n\n ====================>> \n\n")
                                self.accessToken = json["access_token"] as! String
                                //                                    SwiftEventBus.post("VD")
                                self.crmcallback()
                                self.set_header()
                            }
                        }
                        else{
                            SwiftEventBus.post("not")
                            self.failcall()
                        }
                        
                    case .failure(let error):
                        self.failcall()
                        print("error \(error) - url \(todosEndpoint)")
                        
                    }
                }
        }else{
            self.crmcallback()
            self.set_header()
        }
    }
    
    //    MARK:- POST CONDITION
    func postcondition(type : String){
        let todosEndpoint: String = CONSTANT.BASE_URL+"AcxDriverApp/AcxDriverAppService/postConditionHistory"
        
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
        print("\n condition url --> \(todosEndpoint)")
        Alamofire.request(todosEndpoint, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ExecuteApi.header)
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
                        SwiftEventBus.post("cdone")
                    }else{
                        SwiftEventBus.post("cnot")
                    }
                    
                case .failure(let error):
                    SwiftEventBus.post("cerr")
                    print("error \(error) - url \(todosEndpoint)")
                }
            }
    }
    //    MARK:- POST NEW CUST
    var cusadapter = [NEWCUSTMODEL]()
    var custindex = -1
    
    func postnewcust(){
        self.cusadapter.removeAll()
        CONSTANT.custname.removeAll()
        var stmt1:OpaquePointer?
        
        let query = "select post,uid , salutation ,custtype ,fname ,lname ,deladdr ,delsuburb , delstate ,delpostcode ,mailaddr ,mailsuburb , mailstate ,mailpostcode ,abn ,segment ,confname ,conlname ,conphone ,conemail ,acfname ,aclname ,acemail ,acphone,tname,temail,sign, del_country, del_lat, del_long,mail_country, mail_lat , mail_long, subsegment ,lob ,notes from NewCust where post = '0'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        self.custindex = 0
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            //                    array.removeAll()
            let uid = String(cString: sqlite3_column_text(stmt1, 1))
            let salutation = String(cString: sqlite3_column_text(stmt1, 2))
            let custtype = sqlite3_column_int(stmt1, 3)
            let fname = String(cString: sqlite3_column_text(stmt1, 4))
            let lname = String(cString: sqlite3_column_text(stmt1, 5))
            let deladdr = String(cString: sqlite3_column_text(stmt1, 6))
            let delsuburb = String(cString: sqlite3_column_text(stmt1, 7))
            let delstate = String(cString: sqlite3_column_text(stmt1, 8))
            let delpostcode = String(cString: sqlite3_column_text(stmt1, 9))
            let mailaddr = String(cString: sqlite3_column_text(stmt1, 10))
            let mailsuburb = String(cString: sqlite3_column_text(stmt1, 11))
            let mailstate = String(cString: sqlite3_column_text(stmt1, 12))
            let mailpostcode = sqlite3_column_int(stmt1, 13)
            let abn = String(cString: sqlite3_column_text(stmt1, 14))
            let segment = String(cString: sqlite3_column_text(stmt1, 15))
            let confname = String(cString: sqlite3_column_text(stmt1, 16))
            let conlname = String(cString: sqlite3_column_text(stmt1, 17))
            let conphone = String(cString: sqlite3_column_text(stmt1, 18))
            let conemail = String(cString: sqlite3_column_text(stmt1, 19))
            let acfname = String(cString: sqlite3_column_text(stmt1, 20))
            let aclname = String(cString: sqlite3_column_text(stmt1, 21))
            let acemail = String(cString: sqlite3_column_text(stmt1, 22))
            let acphone = String(cString: sqlite3_column_text(stmt1, 23))
            let tname = String(cString: sqlite3_column_text(stmt1, 24))
            let temail = String(cString: sqlite3_column_text(stmt1, 25))
            let sign = String(cString: sqlite3_column_text(stmt1, 26))
            
            let delcountry = String(cString: sqlite3_column_text(stmt1, 27))
            let dellat = sqlite3_column_double(stmt1, 28)
            let dellongi = sqlite3_column_double(stmt1, 29)
            let mailcountry = String(cString: sqlite3_column_text(stmt1, 30))
            let maillati = sqlite3_column_double(stmt1, 31)
            let maillongi = sqlite3_column_double(stmt1, 32)
            let subseg = String(cString: sqlite3_column_text(stmt1, 33))
            let lob = String(cString: sqlite3_column_text(stmt1, 34))
            let notes = String(cString: sqlite3_column_text(stmt1, 35))
            
            self.cusadapter.append(NEWCUSTMODEL(salutation: salutation, custtype: Int(custtype), fname: fname, lname: lname, deladdr: deladdr, delsuburb: delsuburb, delstate: delstate, delpostcode: delpostcode, mailaddr: mailaddr, mailsuburb: mailsuburb, mailstate: mailstate, mailpostcode: Int(mailpostcode), abn: abn, segment: segment, confname: confname, conlname: conlname, conphone: conphone, conemail: conemail, acfname: acfname, aclname: aclname, acemail: acemail, acphone: acphone, tname: tname, temail: temail, sign: sign, uid: uid,country: delcountry, lati: dellat, longi: dellongi, mailcountry: mailcountry, maillati: maillati, maillongi: maillongi, subsegment: subseg, lob: lob, notes: notes))
        }
        if (self.cusadapter.count > 0){
            self.postcust()
        }else{
            SwiftEventBus.post("cust")
            self.cust()
        }
    }
    
    public func cust(){}
    
    func postcust(){
        let todosEndpoint: String = CONSTANT.BASE_URL +  "AcxDriverApp/AcxDriverAppService/createCustomer"
        
//        let todosEndpoint: String = "https://testazureapimanagement.azure-api.net/D365FNO/createCustomer"
        
        let header = [
            "Ocp-Apim-Subscription-Key" : "6aa8953b3b8c49b6ab803c2a212fae91",
            "Ocp-Apim-Trace" : "true",
            "Prefer"                                : "return=representation"
        ]
        
        var body: [String: [AnyObject]] = [:]
        var parameter: [String: AnyObject] = [:]
        var array: [AnyObject] = []
        
        let list : NEWCUSTMODEL
        list = self.cusadapter[custindex]
        
        parameter = [
            "Driver Email" : UserDefaults.standard.string(forKey: "userid")! as AnyObject,
            "Customer Type" : list.custtype as AnyObject,
            "salutation" : list.salutation as AnyObject,
            "First Name" : list.fname as AnyObject,
            "Last Name" : list.lname as AnyObject,
            "Delivery Addrees" : list.deladdr as AnyObject,
            "Delivery Subrub" : list.delsuburb as AnyObject,
            "Delivery State" : list.delstate as AnyObject,
            "Delivery Postcode" : list.delpostcode as AnyObject,
            "Delivery Country" : list.country as AnyObject,
            "Delivery Longitude" : list.longi as AnyObject,
            "Delivery Latitude" : list.lati as AnyObject,
            "Mailing Address" : list.mailaddr as AnyObject,
            "Mailing Subrub" : list.mailsuburb as AnyObject,
            "Mailing State" : list.mailstate as AnyObject,
            "Mailing Postcode" : list.mailpostcode as AnyObject,
            "Mailing Country" : list.mailcountry as AnyObject,
            "Mailing Longitude" : list.maillongi as AnyObject,
            "Mailing Latitude" : list.maillati as AnyObject,
            "ABN" : list.abn as AnyObject,
            "Segment" : list.segment as AnyObject,
            "Contact First Name1" : list.confname as AnyObject,
            "Contact Last Name1" : list.conlname as AnyObject,
            "Contact Email1" : list.conemail as AnyObject,
            "Contact Phone1" : list.conphone as AnyObject,
            "Contact First Name2" : list.acfname as AnyObject,
            "Contact Last Name2" : list.aclname as AnyObject,
            "Contact Email2" : list.acemail as AnyObject,
            "Contact Phone2" : list.acphone as AnyObject,
            "Customer Email" : list.temail as AnyObject,
            "Email Name" : list.tname as AnyObject,
            "Signature" : list.sign as AnyObject,
            "Sub segment": list.subsegment as AnyObject,
            "Line of business id": list.lob as AnyObject,
            "Notes": list.notes  as AnyObject
        ]
       
        array.append(parameter as AnyObject)
        
        body = [
            "custAccount" : array
        ]
        let base = BASEACTIVITY()
        print("body ---->\(base.getdate(format: "HH:mm:ss.SSS"))\n - \(self.arrayToJSON(array: body))\n")
        Alamofire.request(todosEndpoint, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ExecuteApi.header) 
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(response.request?.debugDescription)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    CONSTANT.msg = "Request timed out(1001)"
                    if  (response.response!.statusCode == 200){ // 200 - created ocde
                        print("\n\n ====================>> \n\n")
                        //                                        SwiftEventBus.post("cusdone")
                        self.updatenewcustpost(uid : list.uid)
                    }else{
                        //                                    SwiftEventBus.post("cusnot")
                        if let json = response.result.value as? [String:Any]{
                           if let msg = json["Message"] as? String {
                            if (msg.contains("An exception occured when invoking the operation -")){
                                
                                let err = msg.replacingOccurrences(of: "An exception occured when invoking the operation - ", with: "")
                                CONSTANT.msg = err
                            }}
                        }
                        
                        CONSTANT.custname.append("\(list.fname!) \(list.lname!)")
                    }
                    self.custindex += 1
                    if (self.custindex < self.cusadapter.count){
                        self.postcust()
                    }else{
//                        SwiftEventBus.post("cust")
                        self.cust()
                    }
                    
                case .failure(let error):
                    CONSTANT.custname.append("\(list.fname!) \(list.lname!)")
                    self.custindex += 1
                    if (self.custindex < self.cusadapter.count){
                        self.postcust()
                    }else{
//                        SwiftEventBus.post("cust")
                        self.cust()
                    }
                    //                                SwiftEventBus.post("cerr")
                    print("error \(error) - url \(todosEndpoint)")
                }
            }
    }
    
    
    
    //      MARK:- GET BREAKS
    public func getbreaks(){
        let url = CONSTANT.BASE_URL + "acxdriverapp/acxdriverappservice/getbreaks"
        
        //                {
        //                    "getBreaks":[
        //                        {
        //                            "Driver id":"aubedika@ccamatil.com"
        //                        }
        //                    ]
        //                }
        var body: [String: [AnyObject]] = [:]
        var parameters: [String: AnyObject] = [:]
        var array: [AnyObject] = []
        parameters = [
            "Driver id" : UserDefaults.standard.string(forKey: "userid")! as AnyObject
        ]
        array.append(parameters as AnyObject)
        body =  [
            "getBreaks" : array
        ]
        print("body ---> \(body)")
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ExecuteApi.header)
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(response.request?.debugDescription)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value\n \(response.result.value!) \n")
                    if  (response.response!.statusCode == 200){ // 200 - created ocde
                        
                        if let json = response.result.value as? [[String:Any]] {
                            self.deletetable(tbl: "GetBreak")
                            for result in json{
                                print("\(result["$id"]! as! String)")
                                let uid = result["$id"]! as! String
                                let period = result["Period"]! as! String
                                let maxtime = result["MaxTime"]! as! String
                                let rest = result["Rest Required"]! as! String
                                
                                self.getbreak(uid: uid, period: period, maxtime: maxtime, restreq: rest)
                            }
                            SwiftEventBus.post("gotbreak")
                            print("\n\n ====================>> \n\n")
                        }else{
                            SwiftEventBus.post("notbreak")
                        }
                    }else{
                        SwiftEventBus.post("notbreak")
                    }
                    
                case .failure(let error):
                    SwiftEventBus.post("cerr")
                    print("error \(error) - url \(url)")
                }
            }
    }
    public func getbreakhistory(date: String){
        var parameters: [String: AnyObject] = [:]
        var array: [AnyObject] = []
        var body: [String: [AnyObject]] = [:]
        let todosEndpoint: String = CONSTANT.BASE_URL +  "acxdriverapp/acxdriverappservice/getbreakhistory"
        
        let headers = [
            "Authorization": "Bearer \(self.accessToken)"
        ]
        parameters = [
            "Submit Date" : date as AnyObject,
            "User Id" : UserDefaults.standard.string(forKey: "userid")! as AnyObject
        ]
        array = [
            parameters as AnyObject
        ]
        body = [
            "getBreakHistory" : array
        ]
        //        {
        //        "getBreakHistory":[
        //           {
        //              "Submit Date":"19/11/2020",
        //              "User Id":22
        //           }
        //        ]
        //     }
        print("body ---->\n \(body)\n")
        Alamofire.request(todosEndpoint, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ExecuteApi.header)
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(response.request?.debugDescription)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    if  (response.response!.statusCode == 200){ // 200 - created ocde
                        
                        if let json = response.result.value as? [[String:Any]]{
                            self.clearbrhhistory()
                            if (json.count > 0){
                                var uid : String,starttime : String,endtime : String,duration : String,date : String,brid : String,brtime : String, state: String, post: String
                                for result in json {
                                    uid = result["User Id"] as! String
                                    starttime = result["Break Start Time"] as! String
                                    endtime = result["Break End Time"] as! String
                                    duration = "\(result["Duration"]!)"
                                    date = result["Submit Date"] as! String
                                    brid = result["$id"] as! String
                                    
                                    if (duration == "0" && endtime == "12:00:00 am"){
                                        endtime = ""
                                        state = "0"
                                        post = "1"
                                        brtime = "0"
                                    }else{
                                        state = "1"
                                        post = "2"
                                        let base = BASEACTIVITY()
                                        brtime = base.findDateDiff(time1Str:  starttime, time2Str: endtime)
                                    }
                                    
                                    self.insertinbreak(drid: uid, date: date, brid: brid, starttime: starttime, endtime: endtime, breaktime: brtime, state: state, Duration: duration, Post: post)
                                    //                                                        {
                                    //                                                        "$id" = 1;
                                    //                                                        "Break End Time" = "12:00:00 am";
                                    //                                                        "Break Start Time" = "04:31:00 pm";
                                    //                                                        Duration = 0;
                                    //                                                        "Submit Date" = "21/11/2020";
                                    //                                                        "User Id" = "aubedika@ccamatil.com";
                                    //                                                    }
                                }
                                SwiftEventBus.post("gotbh")
                            }else{
                                SwiftEventBus.post("gotbh")
                            }
                            print("\n\n ====================>> \n\n")
                        }
                    }else{
                        SwiftEventBus.post("notbh")
                    }
                    
                case .failure(let error):
                    SwiftEventBus.post("cerr")
                    print("error \(error) - url \(todosEndpoint)")
                }
            }
    }
    //      MARK:- POST BREAK
    public func poststartbreak(){
        var parameters: [String: AnyObject] = [:]
        var array: [AnyObject] = []
        var body: [String: [AnyObject]] = [:]
        let todosEndpoint: String = CONSTANT.BASE_URL +  "acxdriverapp/acxdriverappservice/postBreakStart"
        
        let headers = [
            "Authorization": "Bearer \(self.accessToken)"
        ]
        
        //        {
        //           "postBreakStart":[
        //              {
        //                 "User Id":22,
        //                 "Break Start Time":"4:00:00 AM",
        //                 "Submit Date":"19/11/2020"
        //              },
        //            {
        //              "User Id":22,
        //              "Break Start Time":"4:00:00 AM",
        //              "Submit Date":"19/11/2020"
        //             }
        //          ]
        //        }
        var stmt1:OpaquePointer?
        
        var query = "select drid,starttime,date,brid from Break where post = '0'"
        var brid : String = ""
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let userid = String(cString: sqlite3_column_text(stmt1, 0))
            let starttime = String(cString: sqlite3_column_text(stmt1, 1))
            let date = String(cString: sqlite3_column_text(stmt1, 2))
            brid = String(cString: sqlite3_column_text(stmt1, 3))
            
            parameters = [
                "User Id" : userid as AnyObject,
                "Break Start Time" : starttime as AnyObject,
                "Submit Date" : date as AnyObject
            ]
            array.append(parameters as AnyObject)
        }
        body = [
            "postBreakStart" : array
        ]
        print("body ---->\n \(body)\n")
        
        if (array.count > 0){
            Alamofire.request(todosEndpoint, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ExecuteApi.header)
                .responseJSON { response in
                    switch response.result { 
                    case .success:
                        // server data
                        print("url \(response.request?.debugDescription)")
                        print("\n*******************************************************\n")
                        print("\nresponse.result.value \(response.result.value!) \n\n")
                        if  (response.response!.statusCode == 200){ // 200 - created ocde
                            if (response.result.value as! Int == 1){
                                self.updatestartbreak()
                                SwiftEventBus.post("sbgot")
                                self.sbgot()
                            }
                            else{
                                SwiftEventBus.post("sbnot")
                                self.sbnot()
                            }
                        }
                        
                    case .failure(let error):
                        SwiftEventBus.post("cerr")
                        self.sbnot()
                        print("error \(error) - url \(todosEndpoint)")
                    }
                }
        }else{
            self.sbgot()
        }
    }
    
    public func sbgot(){}
    public func sbnot(){}
    
    public func postendbreak(){
        var parameters: [String: AnyObject] = [:]
        var array: [AnyObject] = []
        var body: [String: [AnyObject]] = [:]
        let todosEndpoint: String = CONSTANT.BASE_URL +  "acxdriverapp/acxdriverappservice/postBreakEnd"
        
        let headers = [
            "Authorization": "Bearer \(self.accessToken)"
        ]
        
        //        {
        //           "postBreakEnd":[
        //              {
        //                 "Duration":14,
        //                 "Break End Time":"8:00:00 PM",
        //                 "Submit Date":"19/11/2020",
        //                 "User Id":22,
        //        "Break Start Time"
        //              }
        //           ]
        //        }
        var stmt1:OpaquePointer?
        
        var query = "select drid,endtime,date,brid,duration,starttime from Break where state = '1' and post = '1'"
        
        var brid : String = ""
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let userid = String(cString: sqlite3_column_text(stmt1, 0))
            let starttime = String(cString: sqlite3_column_text(stmt1, 1))
            let date = String(cString: sqlite3_column_text(stmt1, 2))
            brid = String(cString: sqlite3_column_text(stmt1, 3))
            let brtime = String(cString: sqlite3_column_text(stmt1, 4))
            let strt = String(cString: sqlite3_column_text(stmt1, 5))
            
            parameters = [
                "User Id" : userid as AnyObject,
                "Break End Time" : starttime as AnyObject,
                "Submit Date" : date as AnyObject,
                "Duration": brtime as AnyObject,
                "Break Start Time" : strt as AnyObject
            ]
            array.append(parameters as AnyObject)
        }
        body = [
            "postBreakEnd" : array
        ]
        print("body ---->\n \(body)\n")
        if (array.count > 0){
            Alamofire.request(todosEndpoint, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ExecuteApi.header)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        // server data
                        print("url \(response.request?.debugDescription)")
                        print("\n*******************************************************\n")
                        print("\nresponse.result.value \(response.result.value!) \n\n")
                        if  (response.response!.statusCode == 200){ // 200 - created ocde
                            if (response.result.value as! Int == 1){
                                self.updateendbreak()
                                SwiftEventBus.post("ebgot")
                                self.ebgot()
                            }
                            else{
                                SwiftEventBus.post("ebnot")
                                self.ebnot()
                            }
                        }
                        
                    case .failure(let error):
                        SwiftEventBus.post("cerr")
                        self.ebnot()
                        print("error \(error) - url \(todosEndpoint)")
                    }
                }
        }else{
            self.ebgot()
        }
    }
    
    public func ebgot(){}
    public func ebnot(){}
    
    //    MARK:- GET CASE TYPE
    public func getcasetype(){
        var url = CONSTANT.RESOURCE_CRM + "/api/data/v9.1/subjects?$select=title,description,subjectid,_parentsubject_value"
        
        var headers = [
            "Authorization"                :   "Bearer \(self.accessToken)",
            "Content-Type"                : "application/json",
            "OData-MaxVersion"      : "4.0",
            "OData-Version"               : "4.0",
            "Accept"                            : "application/json",
            "Prefer"                                : "return=representation"
            
        ]
        
        if CONSTANT.IS_TOKEN_REQ {
            headers = ExecuteApi.header!
            url = CONSTANT.BASE_URL_CRM + "subjects?$select=title,description,subjectid,_parentsubject_value"
        }
        
        var body: [String: AnyObject] = [:]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(url)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    if  (response.response!.statusCode == 200){ // 200
                        self.deletetable(tbl: "CaseType")
                        if let json = response.result.value as? [String:Any],
                           let results = json["value"] as? [[String:Any]]{
                            for result in results{
                                if (result["title"].debugDescription != "Optional(<null>)"){
                                    print("\n -> \(result["title"] as! String)")
                                    var parentid = ""
                                    let type = result["title"] as! String
                                    let id = result["subjectid"] as! String
                                    if (result["_parentsubject_value"].debugDescription != "Optional(<null>)"){
                                        parentid = result["_parentsubject_value"] as! String
                                    }
                                    
                                    self.insertcasetype(title: type, id: id, parentid : parentid)
                                }
                            }
                            SwiftEventBus.post("ctgot")
                            print("\n\n ====================>> \n\n")
                        }
                    }else{
                        SwiftEventBus.post("ctnot")
                    }
                    
                case .failure(let error):
                    SwiftEventBus.post("cterr")
                    print("error \(error) - url \(url)")
                }
            }
    }
    //    MARK:- CASE HISTORY
    public func getcasehistory(id: String){
        var url = CONSTANT.RESOURCE_CRM + "/api/data/v9.1/incidents?$select=title,ticketnumber,createdon,_ownerid_value,modifiedon,resolvebyslastatus,statuscode,statecode,_customerid_value,description,_subjectid_value&$filter=_customerid_value%20eq%20%27\(id)%27%20and%20(statecode%20eq%201%20or%20statecode%20eq%202)"
        
        var headers = [
            "Authorization"                :   "Bearer \(self.accessToken)",
            "Content-Type"                : "application/json",
            "OData-MaxVersion"      : "4.0",
            "OData-Version"               : "4.0",
            "Accept"                            : "application/json",
            "Prefer"                                : "return=representation"
            
        ]
        if CONSTANT.IS_TOKEN_REQ {
            headers = ExecuteApi.header!
            url = CONSTANT.BASE_URL_CRM + "incidents?$select=title,ticketnumber,createdon,_ownerid_value,modifiedon,resolvebyslastatus,statuscode,statecode,_customerid_value,description,_subjectid_value&$filter=_customerid_value%20eq%20%27\(id)%27%20and%20(statecode%20eq%201%20or%20statecode%20eq%202)"
        }
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(url)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    if  (response.response!.statusCode == 200){ // 200
                        let base = BASEACTIVITY()
                        if let json = response.result.value as? [String:Any],
                           let results = json["value"] as? [[String:Any]]{
                            self.clearcase(status: "1")
                            var desc = ""
                            for result in results{
                                
                                print("\n -> \(result["title"] as! String)")
                                
                                let custid = result["_customerid_value"] as! String
                                let caseid = result["ticketnumber"] as! String
                                let type = result["_subjectid_value"] as! String
                                let title = result["title"] as! String
                                if (result["description"].debugDescription != "Optional(<null>)"){
                                    desc = result["description"] as! String
                                }else{
                                    desc = ""
                                }
                                
                                let status = result["statecode"] as! Int
                                let state = result["statuscode"] as! Int
                                
                                self.insertcasetable(custid: custid, userid: UserDefaults.standard.string(forKey: "userid")!, caseid: caseid, type: type, status: "\(status)", date: base.getdate(format: "yyyy-MM-dd"), contid: custid, state: "\(state)", post: "2")
                                self.updatecasetable(caseid : caseid, title : title, descp : desc)
                                
                            }
                            SwiftEventBus.post("chgot")
                            print("\n\n ====================>> \n\n")
                        }
                    }else{
                        SwiftEventBus.post("chnot")
                    }
                    
                case .failure(let error):
                    SwiftEventBus.post("cterr")
                    print("error \(error) - url \(url)")
                }
            }
    }
    public func getopencase(id : String){
        
        var url = CONSTANT.RESOURCE_CRM + "/api/data/v9.1/incidents?$select=title,ticketnumber,createdon,_ownerid_value,modifiedon,resolvebyslastatus,statuscode,statecode,_customerid_value,description%20,_subjectid_value%20&$filter=_customerid_value%20eq%20%27\(id)%27%20and%20statecode%20eq%200"
        
        var headers = [
            "Authorization"                :   "Bearer \(self.accessToken)",
            "Content-Type"                : "application/json",
            "OData-MaxVersion"      : "4.0",
            "OData-Version"               : "4.0",
            "Accept"                            : "application/json",
            "Prefer"                                : "return=representation"
            
        ]
        if CONSTANT.IS_TOKEN_REQ {
            headers = ExecuteApi.header!
            url = CONSTANT.BASE_URL_CRM + "incidents?$select=title,ticketnumber,createdon,_ownerid_value,modifiedon,resolvebyslastatus,statuscode,statecode,_customerid_value,description%20,_subjectid_value%20&$filter=_customerid_value%20eq%20%27\(id)%27%20and%20statecode%20eq%200"
        }
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(url)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    if  (response.response!.statusCode == 200){ // 200
                        let base = BASEACTIVITY()
                        if let json = response.result.value as? [String:Any],
                           let results = json["value"] as? [[String:Any]]{
                            self.clearcase(status: "0")
                            var desc = ""
                            for result in results{
                                
                                print("\n -> \(result["title"] as! String)")
                                
                                let custid = result["_customerid_value"] as! String
                                let caseid = result["ticketnumber"] as! String
                                let type = result["_subjectid_value"] as! String
                                //                                let date = result["_subjectid_value"] as! String
                                let title = result["title"] as! String
                                if (result["description"].debugDescription != "Optional(<null>)"){
                                    desc = result["description"] as! String
                                }else{
                                    desc = ""
                                }
                                let status = result["statecode"] as! Int
                                let state = result["statuscode"] as! Int
                                
                                self.insertcasetable(custid: custid, userid: UserDefaults.standard.string(forKey: "userid")!, caseid: caseid, type: type, status: "\(status)", date: base.getdate(format: "yyyy-MM-dd"), contid: custid, state: "\(state)", post: "2")
                                self.updatecasetable(caseid : caseid, title : title, descp : desc)
                                //                           {
                                //                                "@odata.etag" = "W/\"7882648\"";
                                //                                "_customerid_value" = "5427455c-b801-eb11-a813-000d3a6aa0b3";
                                //                                "_ownerid_value" = "fe8487cb-eccb-ea11-a812-000d3a6aac8e";
                                //                                "_subjectid_value" = "e291f6aa-0bf5-ea11-a815-000d3a6aa0b3";
                                //                                createdon = "2020-11-11T05:16:20Z";
                                //                                description = "The INvoice NUmber IN0001 has an issue of defected goods.";
                                //                                incidentid = "3c3fca52-55ac-478a-8e72-e854bfca4501";
                                //                                modifiedon = "2020-11-11T05:16:20Z";
                                //                                resolvebyslastatus = 1;
                                //                                statecode = 0;
                                //                                statuscode = 1;
                                //                                ticketnumber = "CAS-01014-P6J7W7";
                                //                                title = Test;
                                //                            }
                                
                            }
                            SwiftEventBus.post("opgot")
                            print("\n\n ====================>> \n\n")
                        }
                    }else{
                        SwiftEventBus.post("opnot")
                    }
                    
                case .failure(let error):
                    SwiftEventBus.post("cterr")
                    print("error \(error) - url \(url)")
                }
            }
    }
    //    MARK:- Account ID
    public func getaccountid(acountno: String){
        
        var url = CONSTANT.RESOURCE_CRM + "/api/data/v9.1/accounts?$select=name,accountnumber,emailaddress1&$filter=accountnumber%20eq%20%27\(acountno)%27"
        
        var headers = [
            "Authorization"                :   "Bearer \(self.accessToken)",
            "Content-Type"                : "application/json",
            "OData-MaxVersion"      : "4.0",
            "OData-Version"               : "4.0",
            "Accept"                            : "application/json",
            "Prefer"                                : "return=representation"
            
        ]
        if CONSTANT.IS_TOKEN_REQ {
            headers = ExecuteApi.header!
            url = CONSTANT.BASE_URL_CRM + "accounts?$select=name,accountnumber,emailaddress1&$filter=accountnumber%20eq%20%27\(acountno)%27"
        }
        print("\n url -> \(url)")
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(url)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    if  (response.response!.statusCode == 200){ // 200
                        if let json = response.result.value as? [String:Any],
                           let results = json["value"] as? [[String:Any]]{
                            if (results.count > 0){
                                let result = results[0]
                                print("\n -> \(result["accountid"] as! String)")
                                let custid = result["accountid"] as! String
                                CUSTORDERVC.contid = custid
                                self.acgot()
                                print("\n\n ====================>> \n\n")
                            }else{
                                self.crmerr()
                            }
                        }
                    }else{
                        self.acnot()
                    }
                    
                case .failure(let error):
                    self.acerr()
                    print("error \(error) - url \(url)")
                }
            }
    }
    
    public func acgot(){
    }
    public func acnot(){
    }
    public func acerr(){
    }
    
    //    MARK:- POST CASE
    public func postcase(){
        var url = CONSTANT.RESOURCE_CRM + "/api/data/v9.1/incidents"
        
        var headers = [
            "Authorization"                :   "Bearer \(self.accessToken)",
            "Content-Type"                : "application/json",
            "OData-MaxVersion"      : "4.0",
            "OData-Version"               : "4.0",
            "Accept"                            : "application/json",
            "Prefer"                                : "return=representation"
        ]
        if CONSTANT.IS_TOKEN_REQ {
            headers = ExecuteApi.header!
            url = CONSTANT.BASE_URL_CRM + "incidents"
        }
        var body: [String: AnyObject] = [:]
        var id = ""
        var stmt1:OpaquePointer?
        let query = "select type,title,contid,descp,caseid from caseentry"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            let typeid = String(cString: sqlite3_column_text(stmt1, 0))
            let title = String(cString: sqlite3_column_text(stmt1, 1))
            let custid = String(cString: sqlite3_column_text(stmt1, 2))
            let description = String(cString: sqlite3_column_text(stmt1, 3))
            let caseid = String(cString: sqlite3_column_text(stmt1, 4))
            id = caseid
            
            body = [
                "subjectid@odata.bind" : "/subjects(\(typeid))" as AnyObject,
                "title" : title as AnyObject,
                "customerid_account@odata.bind" : "/accounts(\(custid))" as AnyObject,
                "description" : description as AnyObject
            ]
            
            //        {
            //        "subjectid@odata.bind":"/subjects(subjectid)",
            //        "title" :"Sample Case by API with Subject",
            //        "customerid_account@odata.bind":"/accounts(accountid)",
            //        "description" :"case created by satyam"
            //        }
            print("\nbody ---> \n\(body)")
            Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        // server data
                        print("url \(url)")
                        print("\n*******************************************************\n")
                        print("\nresponse.result.value \(response.result.value!) \n\n")
                        if  (self.isResponseOK(code: response.response!.statusCode)){ // 200
                            SwiftEventBus.post("cdone")
                            print("\n\n ====================>> \n\n")
                            //                        self.updatecase()
                        }else{
                            SwiftEventBus.post("cnot")
                        }
                        
                    case .failure(let error):
                        SwiftEventBus.post("cperr")
                        print("error \(error) - url \(url)")
                    }
                }
        }
    }
    //MARK:- POST END MY DAY
    public func postendmyday(odometer: String){
        let url = CONSTANT.BASE_URL + "acxdriverapp/acxdriverappservice/postEndMyDay"
        
        let headers = [
            "Authorization"                :   "Bearer \(self.accessToken)",
        ]
        
        var parameters: [String: AnyObject] = [:]
        var array: [AnyObject] = []
        var body: [String: [AnyObject]] = [:]
        var stmt1:OpaquePointer?
        let query = " select DISTINCT(select DISTINCT odometer from PreStartChecklist) as odometerread,  starttime from Compliance"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            let odo = String(cString: sqlite3_column_text(stmt1, 0))
            let starttime = String(cString: sqlite3_column_text(stmt1, 1))
            
            let base = BASEACTIVITY()
            
            parameters = [
                "EndTime" : base.getdate(format: "hh:mm:ss a") as AnyObject ,
                "OdometerEndReading" : Int64(odometer) as AnyObject ,
                "UserID" : UserDefaults.standard.string(forKey: "userid") as AnyObject ,
                "SubmittedDateTime" : base.getdate(format: "yyyy-MM-dd hh:mm:ss a") as AnyObject ,
                "OdometerReading" : odo as AnyObject ,
                "StartTime" : starttime as AnyObject
            ]
            array.append(parameters as AnyObject)
            body = [
                "postEndMyDay" : array
            ]
            //                    {
            //                       "postEndMyDay":[
            //                          {
            //                             "EndTime":"2:00:00 PM",
            //                             "OdometerEndReading":98769,
            //                             "UserID":"Abc@gmail.com",
            //                             "SubmittedDateTime":"2020-12-05 10:00:00 AM",
            //                             "OdometerReading":12543,
            //                             "StartTime":"10:00:00 AM"
            //                          }
            //                       ]
            //                    }
            
            //                    ["postEndMyDay": [{
            //                       EndTime = "03:15:02 PM";
            //                       OdometerEndReading = 22222;
            //                       OdometerReading = 888;
            //                       StartTime = "11:01:32 am";
            //                       SubmittedDateTime = "2020-12-07 03:15:02 PM";
            //                       UserID = "aubedika@ccamatil.com";
            //                   }]]
            print("body ---->\n \(body)\n")
            Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ExecuteApi.header)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        // server data
                        print("url \(url)")
                        print("\n*******************************************************\n")
                        print("\nresponse.result.value \(response.result.value!) \n\n")
                        let res = "\(response.result.value!)"
                        if  (response.response!.statusCode == 200 && res == "1"){ // 200
                            self.edone()
                            SwiftEventBus.post("edone")
                            print("\n\n ====================>> \n\n")
                            
                        }else{
                            self.enot()
                            SwiftEventBus.post("enot")
                        }
                        
                    case .failure(let error):
                        SwiftEventBus.post("err")
                        self.err()
                        print("error \(error) - url \(url)")
                    }
                }
        }
    }
    
    public func edone(){}
    public func enot(){}
    public func err(){}
    //    MARK:- POST CUST SRCH
    public func postcustsrch(srchstr: String, criteria: Int){
        
        let url = CONSTANT.BASE_URL + "acxdriverapp/acxdriverappservice/postSelectedCustomer"
        
        let headers = [
            "Authorization"                :   "Bearer \(self.accessToken)"
        ]
        var parameters: [String: AnyObject] = [:]
        var array: [AnyObject] = [] 
        var body: [String: [AnyObject]] = [:]
        
        parameters = [
            "Search String" : srchstr as AnyObject ,
            "Criteria" : criteria as AnyObject
        ]
        array.append(parameters as AnyObject)
        body = [
            "postSelectedCustomer" : array
        ]
        
        print("body ---->\n \(body)\n")
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ExecuteApi.header)
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(url)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    if  (response.response!.statusCode == 200){ // 200
                        if let json = response.result.value as? [[String:Any]]{
                            self.deletetable(tbl: "custsrch")
                            for result in json {
                                print("\(result["Name"] as! String)")
                                let custid = "\(result["Customer Account"]!)"
                                let name = result["Name"] as! String
                                let city = result["City"] as! String
                                let state = result["State"] as! String
                                let street = result["Street"] as! String
                                let id = result["$id"] as! String
                                let email = result["Customer Email"] as! String
                                let phone = result["Customer Phone"] as! String
                                let lati = result["Customer Latitude"] as! Double
                                let longi = result["Customer longitude"] as! Double
                                let delnote = result["Customer Delivery Note"] as! String
                                let pono = result["PoNo"] as! String
                                let taxgrp = result["Customer Tax Group"] as! String
                                let chgrp = result["Customer Charge Group"] as! String
                                let modofdel = result["Customer Mode of Delivery"] as! String
                                let modofdelgrp = result["Customer Mode of Delivery Group"] as! String
                                let pricegrp = result["Customer Price Group"] as! String
                                let disgrp = result["Customer Discount Group"] as! String
                                let pomandate = result["PO Mandatory"] as! Bool
                                
                                self.insertcustsrch(id: id, custid: custid, name: name, city: city, state: state, street: street, email : email,phone : phone, lati : "\(lati)", longi : "\(longi)", delnote : delnote, pono : pono, custtaxgrp : taxgrp, custchgrp : chgrp, modeofdel : modofdel, custpricegrp : pricegrp, custdisgrp : disgrp,custmodgrp: modofdelgrp,pomandate: "\(pomandate)")
                            }
                            print("\n\n ====================>> \n\n")
                            self.gotsrch()
                        }
                    }else{
                        self.notsrch()
                    }
                    
                case .failure(let error):
                    self.srcherr()
                    print("error \(error) - url \(url)")
                }
            }
    }
    public func gotsrch(){
    }
    public func notsrch(){}
    
    public func srcherr(){}
    
    public func crmerr(){}
    
    //    MARK:- GET CUSTOMER DETAILS
    public func getcustdetails(){
        CONSTANT.apicall += 1
        let url = CONSTANT.BASE_URL + "acxdriverapp/acxdriverappservice/getOrderDetails"
        
        let headers = [
            "Authorization"                :   "Bearer \(self.accessToken)"
        ]
        var body: [String: [AnyObject]] = [:]
        var parameters: [String : AnyObject] = [:]
        var array: [AnyObject] = []
        
        let loadnum = UserDefaults.standard.string(forKey: "loadnum")!
        
        if (loadnum != "" && loadnum.count > 0){
        }else{
            print("URL ---> \(url) \n no load-num\n")
        }
        
        parameters = [
            "Load Number" : loadnum as AnyObject
        ]
        
        array.append(parameters as AnyObject)
        body = [
            "getOrderDetails" : array
        ]
        
        print("body ---->\n \(url)\n")
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ExecuteApi.header)
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(url)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    if  (response.response!.statusCode == 200){ // 200
                        if let json = response.result.value as? [[String:Any]]{
                     
                            if (json.count > 0){
                                var index = 1
                                for result in json {
                                    print("\(result["Customer Name"] as! String)")
                                    let custid = result["Customer Account"] as! String
                                    let userid = UserDefaults.standard.string(forKey: "userid")!
                                    let name = result["Customer Name"] as! String
                                    let street = result["Customer Street"] as! String
                                    let city = result["Customer City"] as! String
                                    let state = result["Customer State"] as! String
                                    let email = result["Customer Email"] as! String
                                    let phone = result["Customer Phone"] as! String
                                    let lat = result["Customer Latitude"] as! Double
                                    let long = result["Customer longitude"] as! Double
                                    let delnote = result["Delivery Note"] as! String
                                    let ctg = result["Customer Tax Group"] as! String
                                    let ccg = result["Customer Charge Group"] as! String
                                    let cmod = result["Customer Mode of Delivery"] as! String
                                    let cpg = result["Customer Price Group"] as! String
                                    let cdg = result["Customer Discount Group"] as! String
                                    let con = result["Customer Order Number"] as! String
                                    let callday3 = result["CallDay3"] as! Int
                                    //                                    do here
                                    if (self.checkorder(ordernum: con)){
                                        let cocc = result["Customer order charge code"] as! String
                                        let cocv = result["Customer order charges"] as! Double
                                        let coct = result["Customer order charges Tax"] as! Double
                                        let custmodofgrp = result["Customer Discount Group"] as! String
                                        let nextdeldate = result["Next Delivery Date"] as! String
                                        let pono = result["PO Number"] as! String
                                        
                                        print("coct --> \(coct)")
                                        let ordernote = result["Order Note"] as! String
                                        let orderdate = result["Sales Order Date"] as! String
                                        let activity = result["deliveryStatus"] as! Int
                                        let pomandate = result["PO Mandatory"] as! Bool
                                        
                                        var status = ""
                                        if (phone == ""){
                                            status = "b"
                                        }else if(email == ""){
                                            status = "o"
                                        }else{
                                            status = "g"
                                        }
                                        
                                        var date = ""
                                        if (orderdate.contains("T")){
                                            date = orderdate.replacingOccurrences(of: "T", with: " ")
                                        }else{
                                            date = orderdate
                                        }
                                        self.insertorderheader(custid: "\(custid)", userid: userid, custname: name, custcity: city, custstreet: street, custstate: state, custemail: email, custphone: phone, lati: "\(lat)", longi: "\(long)", delnote: delnote, ordernote: ordernote, custtaxgrp: ctg, custchgrp: ccg, custmod: cmod, custmodgrp: custmodofgrp, custpricegrp: cpg, custdisgrp: cdg, custordernum: con, custordrchcode: cocc, custorderchval: "\(cocv)", custorderchtax: "\(coct)", date: date, nextdeldate: nextdeldate, status: status, lastactivityid: "\(activity)", pono: pono, shipdate : "", pomandate: "\(pomandate)",post: "2", callday3: "\(callday3)")
                                        
                                        if let orders = result["SKU Details"] as? [[String:Any]]{
                                            if (json.count > 0){
                                                for order in orders {
                                                    
                                                    let itemno = order["ItemNo."] as! String
                                                    let itemname = order["Item name"] as! String
                                                    //                                                "Item name" = "White Cook & Cold (Freestanding)"
                                                    let qty = order["Item QTY"] as! Double
                                                    let ip = order["Item Price"] as! Double
                                                    let idp = order["Item discount percentage"] as! Double
                                                    let itemdisamt = order["Item discount Amount"] as! Double
                                                    let id = order["Item discount"] as! Double
                                                    let itg = order["Item tax group"] as! String
                                                    let ib = order["Item batch"] as! String
                                                    let lotid = order["Lot id"] as! String
                                                    let itemlineamt = order["Item line amount"] as! Double
                                                    let priceunit = order["Price Unit"] as! Int
                                                    let revsch = order["Revenue schedule"] as! String
                                                    let cathitem = order["Cartridge Item"] as! String
                                                    
                                                    if let itemtaxar = order["Item Taxes"] as? [[String:Any]]{
                                                        if itemtaxar.count > 0 {
                                                            for itemtax in itemtaxar {
                                                                let itemtaxgrp = itemtax["Item Tax Group"] as! String
                                                                let percent = itemtax["Percent"] as! Double
                                                                let taxamt = itemtax["Tax Amount"] as! Double
                                                                let taxcode = itemtax["Tax Code"] as! String
                                                                self.insertorderitemtax(lotid: lotid, itemtaxgrp: itemtaxgrp, percent: "\(percent)", taxamt: "\(taxamt)", taxcode: taxcode, post: "2")
                                                            }
                                                        }
                                                    }
                                                    if let itemchar = order["Item Charges"] as? [[String:Any]]{
                                                        if itemchar.count > 0 {
                                                            for itch in itemchar {
                                                                let chamt = itch["Charge Amount"] as! Double
                                                                let chcode = itch["Charge Code"] as! String
                                                                let chtype = itch["Charge Type"] as! Int
                                                                let chval = itch["Charge Value"] as! Double
                                                                self.insertorderitemch(lotid: lotid, chamt: "\(chamt)", chcode: chcode, chtype: "\(chtype)", chval: "\(chval)", post: "2")
                                                            }
                                                        }
                                                    }
                                                    if ("\(activity)" == NoDelReason.delivered.rawValue){
                                                        if let itemchar = order["Dim Details"] as? [[String:Any]]{
                                                            if itemchar.count > 0 {
                                                                for itch in itemchar {
                                                                    let batch = itch["Batch Number"] as! String
                                                                    let serial = itch["Serial Number"] as! String
                                                                    let qty = itch["Quantity"] as! Double
                                                                    self.insertdimdetails(orderid: con, itemid: itemno, batch: batch, serial: serial, qty: "\(qty)", post: "2", lotid: lotid)
                                                                    self.insertbatchserial(lotid: lotid, batch: batch, serial: serial, qty: "\(qty)", type: "custorder", post: "2")
                                                                }
                                                            }else{
                                                                self.insertdimdetails(orderid: con, itemid: itemno, batch: "", serial: "", qty: "\(qty)", post: "2", lotid: lotid)
                                                            }
                                                        }
                                                    }
                                                    
                                                    self.insertorderline(lotid: lotid, custordernum: con, itemnum: itemno, itemname: itemname, qty: "\(qty)", price: "\(ip)", priceunit: "\(priceunit)", itemdisper: "\(idp)",itemdisamt: "\(itemdisamt)", itemdis: "\(id)", itemtaxgrp: itg, itembatch: ib, totval: "\(itemlineamt)", cathitem: cathitem,revsch : revsch, post: "2")
                                                }
                                            }
                                        }
                                    }
                                    index = index + 1
                                }
                                self.apicall()
                            }else{
                                CONSTANT.failapi += 1
                                self.apicall()
                            }
                            print("\n\n ====================>> \n\n")
                        }else{
                            CONSTANT.failapi += 1
                            self.apicall()
                        }                        
                    }else{
                        if (response.response?.statusCode == 500){
                            if let json = response.result.value as? [String:Any]{
                               if let msg = json["Message"] as? String {
                                if (msg.contains("An exception occured when invoking the operation -")){
                                    
                                    let err = msg.replacingOccurrences(of: "An exception occured when invoking the operation - ", with: "")
                                    AppDelegate.ordererr = err
                                    let base = BASEACTIVITY()
                                    base.clearsequence()
                                }
                               }
                            }
                        }
                        CONSTANT.failapi += 1
                        self.apicall()
                    }
                    
                case .failure(let error):
                    print("error \(error) - url \(url)")
                    CONSTANT.failapi += 1
                    self.apicall()
                }
            }
        
    }
    //    MARK:- check order
    func checkorder(ordernum: String) -> Bool{
        var flag = true
        
        var stmt1:OpaquePointer?
        
        let query = "select * from CustorderHeader where custordernum = '\(ordernum)'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return false
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            flag = false
        }
        return flag
    }
    
    //    MARK:- POST DELNOTE
    public func postdelnote(orderid: String){
        
        let url = CONSTANT.BASE_URL + "acxdriverapp/acxdriverappservice/postCustomerInfo"
        
        let headers = [
            "Authorization"                :   "Bearer \(self.accessToken)"
        ]
        var parameters: [String: AnyObject] = [:]
        var array: [AnyObject] = []
        var body: [String: [AnyObject]] = [:]
        
        var stmt1:OpaquePointer?
        
        let query = "select a.custid,a.delnote,ifnull(b.reasoncode,''),ifnull(b.description,''),ifnull(b.date,''),ifnull(b.skipcancelname,'') from CustorderHeader a left outer join NoDelReason b on b.ordernum = a.custordernum and b.type = '4' and b.post = '0' where a.custordernum  = '\(orderid)' "
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            let accountnum = String(cString: sqlite3_column_text(stmt1, 0))
            let note = String(cString: sqlite3_column_text(stmt1, 1))
            let reasoncode = String(cString: sqlite3_column_text(stmt1, 2))
            let desc = String(cString: sqlite3_column_text(stmt1, 3))
            let date = String(cString: sqlite3_column_text(stmt1, 4))
            let name = String(cString: sqlite3_column_text(stmt1, 5))
            
            parameters = [
                "Customer Account" : accountnum as AnyObject ,
                "Delivery Note" : note as AnyObject,
                "Cancel to date": date as AnyObject,
                "Driver Code": UserDefaults.standard.string(forKey: "did")! as AnyObject,
                "Customer Name": name as AnyObject,
                "Cancel reason": reasoncode as AnyObject
            ]
            //            "Customer Account":"INMF-000003",
            //            "Delivery Note": "asdfghj]tyresadfxbnhjuytresdfgbnmjhuytrdfvbnhyt",
            //            "Cancel to date":"2021-10-10",
            //            "Driver Code":"D-001",
            //            "Customer Name":"Sangam",
            //            "Cancel reason":"Cancel reasonCancel reasonCancel reason"
            array.append(parameters as AnyObject)
            body = [
                "postCustomerInfo" : array
            ]
            print("body ---->\n \(body)\n")
            Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ExecuteApi.header)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        // server data
                        print("url \(url)")
                        print("\n*******************************************************\n")
                        print("\nresponse.result.value \(response.result.value!) \n\n")
                        if  (response.response!.statusCode == 200){ // 200
                            if ("\(response.result.value!)" == "1"){
                                self.gotdel()
                            }else{
                                self.notdel()
                            }
                            print("\n\n ====================>> \n\n")
                        }else{
                            self.notdel()
                        }
                        
                    case .failure(let error):
                        self.delerr()
                        print("error \(error) - url \(url)")
                    }
                }
        }
    }
    public func gotdel(){}
    public func notdel(){}
    public func delerr(){}
    
    public func getcases(acid: String){
        
        let url = "https://testfunctionapp20201211075637.azurewebsites.net/api/Democrmapi?accountid='\(acid)'"
        
        //        let headers = [
        //            "Authorization"                :   "Bearer \(self.accessToken)",
        //            "Content-Type"                : "application/json",
        //            "OData-MaxVersion"      : "4.0",
        //            "OData-Version"               : "4.0",
        //            "Accept"                            : "application/json",
        //            "Prefer"                                : "return=representation"
        //
        //        ]
        print("\n url -> \(url)")
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(url)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    if  (response.response!.statusCode == 200){ // 200
                        if let json = response.result.value as? [String:Any],
                           let results = json["value"] as? [[String:Any]]{
                            if (results.count > 0){
                                for result in results{
                                    print("\n -> \(result["ticketnumber"] as! String)")
                                }
                                //                                    let custid = result["accountid"] as! String
                                //                                CUSTORDERVC.contid = custid
                                self.acgot()
                                print("\n\n ====================>> \n\n")
                            }else{
                                self.crmerr()
                            }
                        }
                    }else{
                        self.acnot()
                    }
                    
                case .failure(let error):
                    self.acerr()
                    print("error \(error) - url \(url)")
                }
            }
    }
    //    MARK:- PIN CODE generation
    public func getpincode(){
        
        let url = CONSTANT.BASE_URL + "acxdriverapp/acxdriverappservice/postPinCode"
        
        let headers = [
            "Authorization"                :   "Bearer \(self.accessToken)"
        ]
        var parameters: [String: AnyObject] = [:]
        var array: [AnyObject] = []
        var body: [String: [AnyObject]] = [:]
        
        parameters = [
            "Driver id" : UserDefaults.standard.string(forKey: "userid") as AnyObject
        ]
        array.append(parameters as AnyObject)
        body = [
            "postPinCode" : array
        ]
        //            api/services/acxdriverapp/acxdriverappservice/postPinCode
        //            JSON:
        //            {
        //               "postPinCode":[
        //                  {
        //                "Driver id" : "D00001"
        //                  }
        //               ]
        //            }
        //            Response:
        //            [
        //                {
        //                    "$id": "1",
        //                    "Driver id": "D00001",
        //                    "Pin code": 914488
        //                }
        //            ]
        print("body ---->\n \(body)\n")
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ExecuteApi.header)
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(url)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    if  (response.response!.statusCode == 200){ // 200
                        if let json = response.result.value as? [[String:Any]]{
                            let result = json[0]
                            let pincode = "\(result["Pin code"]!)"
                            UserDefaults.standard.setValue(pincode, forKey: "pincode")
                            self.pingot()
                        }
                    }else{
                        self.pinnot()
                    }
                    
                case .failure(let error):
                    self.pinerr()
                    print("error \(error) - url \(url)")
                }
            }
    }
    public func pinerr(){}
    public func pingot(){}
    public func pinnot(){}
    
    //    MARK:- POST LOAD
    public func postload(acceptreject: Int){
        
        let url = CONSTANT.BASE_URL + "acxdriverapp/acxdriverappservice/postRemotLoad"
        
        let headers = [
            "Authorization"                :   "Bearer \(self.accessToken)"
        ]
        //                var parameters: [String: AnyObject] = [:]
        var array: [AnyObject] = []
        var skuparameters: [String: AnyObject] = [:]
        var skuarray: [AnyObject] = []
        var body: [String: [AnyObject]] = [:]
        
        var stmt1:OpaquePointer?
        var query = ""
        if (acceptreject == -1){
            query = "select a.itemid, case when c.isserial = '0' and c.isbatch = '0' then a.qty else b.qty end as qty, ifnull(b.batch,''),ifnull(b.serial,'') from loading a left outer join batchserial b on a.itemid = b.lotid and b.type = 'loading' inner join itemmaster c on a.itemid = c.itemcode"
        }else{
            query = "select itemid,qty,ifnull(batch,''),ifnull(serial,'') from loading"
        }
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        skuarray.removeAll()
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let itemid = String(cString: sqlite3_column_text(stmt1, 0))
            let qty = sqlite3_column_int(stmt1, 1)
            let batch = String(cString: sqlite3_column_text(stmt1, 2))
            let serial = String(cString: sqlite3_column_text(stmt1, 3))
            
            skuparameters = [
                "Item Id" : itemid as AnyObject,
                "Quantity": qty as AnyObject,
                "Batch Number": batch as AnyObject,
                "Serial Number": serial as AnyObject
            ]
            skuarray.append(skuparameters as AnyObject)
        }
        let parameters = [
            "Load Number" : UserDefaults.standard.string(forKey: "loadnum") as AnyObject,
            "Accept/Reject" : acceptreject as AnyObject,
            "SKUDetails" : skuarray
        ] as [String : Any]
        array.append(parameters as AnyObject)
        body = [
            "postRemotLoad" : array
        ]
        //            {
        //               "postRemotLoad":[
        //                  {
        //                "Load Number":"Load-001",
        //            "Accept/Reject" :1,
        //                "SKUDetails":[
        //                    {
        //                        "Item Id" : "1003",
        //                        "Quantity": 2,
        //                        "Batch Number":"",
        //                        "Serial Number":""
        //                    }
        //                ]
        //                  }
        //               ]
        //            }
        //            Response--
        //            [
        //                {
        //                    "$id": "1",
        //                    "Transfer Id": "TID-000020"
        //                }
        //            ]
        print("body ---->\n \(body)\n")
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ExecuteApi.header)
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(url)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    if  (response.response!.statusCode == 200){ // 200
                        if let json = response.result.value as? [[String:Any]]{
                            if (json.count > 0){
                                let result = json[0]
                                let tid = result["Transfer Id"] as! String
                                self.rlgot(tid: tid)
                            }else{
                                self.rlnot()
                            }
                        }
                    }else if (response.response!.statusCode == 500){
                        if let result = response.result.value as? [String:Any]{
                            if let msg = result["Message"] as? String {
                            if (msg == "An exception occured when invoking the operation - Loadsheet is already posted."){
                                self.rlnodta(msg: "Loadsheet is already posted.")
                            }else{
                                self.rlnot()
                            }
                            }
                            else {
                                self.rlnot()
                            }
                        }else{
                            self.rlnot()
                        }
                    }else{
                        self.rlnot()
                    }
                    
                case .failure(let error):
                    self.rlerr()
                    print("error \(error) - url \(url)")
                }
            }
    }
    public func rlerr(){}
    public func rlgot(tid: String){}
    public func rlnot(){}
    public func rlnodta(msg: String){}
    
    func arrayToJSON(array: Any) -> AnyObject {
        let jsonData = try! JSONSerialization.data(withJSONObject: array, options: .prettyPrinted)
        let decoded = try! JSONSerialization.jsonObject(with: jsonData, options: [])
        return decoded as AnyObject
    }
    
    //    MARK:- TAX MASTER API
    public func gettaxmaster(){
        CONSTANT.apicall += 1
        let url = CONSTANT.BASE_URL + "acxdriverapp/acxdriverappservice/getTaxMaster"
        
        let headers = [
            "Authorization"                :   "Bearer \(self.accessToken)"
        ]
        //
        //        Response--
        //        [
        //            {
        //                "$id": "1",
        //                "GST Value": 10.0,
        //                "GST Code": "Excise"
        //            },
        var body: [String: AnyObject] = [:]
        print("body ---->\n \(url)\n")
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ExecuteApi.header)
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(url)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    if  (response.response!.statusCode == 200){ // 200
                        if let json = response.result.value as? [[String:Any]]{
                            if (json.count > 0){
                                self.deletetable(tbl: "TaxMaster")
                                for result in json {
                                    let id = result["$id"] as! String
                                    let gstval = result["GST Value"] as! Int
                                    let gstcode = result["GST Code"] as! String
                                    
                                    self.inserttaxmaster(id: id, gstval: "\(gstval)", gstcode: gstcode)
                                }
                                self.apicall()
                            }else{
                                CONSTANT.failapi += 1
                                self.apicall()
                                CONSTANT.mastername.append("Tax Master")
                            }
                        }else{
                            CONSTANT.failapi += 1
                            self.apicall()
                            CONSTANT.mastername.append("Tax Master")
                        }
                    }else{
                        CONSTANT.failapi += 1
                        self.apicall()
                        CONSTANT.mastername.append("Tax Master")
                    }
                    
                case .failure(let error):
                    CONSTANT.failapi += 1
                    self.apicall()
                    CONSTANT.mastername.append("Tax Master")
                    print("error \(error) - url \(url)")
                }
            }
    }
    //    MARK:- TAX GROUP API
    public func gettaxgroup(){
        CONSTANT.apicall += 1
        let url = CONSTANT.BASE_URL + "acxdriverapp/acxdriverappservice/getTaxGroup"
        
        let headers = [
            "Authorization"                :   "Bearer \(self.accessToken)"
        ]
        var body: [String: AnyObject] = [:]
        //
        //        Response--
        //        [
        //            {
        //            "$id": "1",
        //            "Tax group code": "Excise",
        //            "GST code": "Excise",
        //            "Tax Type": "Customer"
        //        },
        
        //            "$id": "1",
        //                    "Sales Tax Group": "Excise",
        //                    "GST code": "Excise",
        //                    "Item Sales Tax Group": "Excise"
        
        print("body ---->\n \(url)\n")
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ExecuteApi.header)
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(url)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    if  (response.response!.statusCode == 200){ // 200
                        if let json = response.result.value as? [[String:Any]]{
                            if (json.count > 0){
                                self.deletetable(tbl: "TaxGroup")
                                for result in json {
                                    let id = result["$id"] as! String
                                    let tgc = result["Sales Tax Group"] as! String
                                    let tt = result["Item Sales Tax Group"] as! String
                                    let gc = result["GST code"] as! String
                                    
                                    self.inserttaxgroup(id: id, taxgrpcode: tgc, gstcode: gc, taxtype: tt)
                                }
                                self.apicall()
                            }else{
                                CONSTANT.failapi += 1
                                CONSTANT.mastername.append("Tax Group")
                                self.apicall()
                            }
                        }else{
                            CONSTANT.failapi += 1
                            CONSTANT.mastername.append("Tax Group")
                            self.apicall()
                        }
                    }else{
                        CONSTANT.failapi += 1
                        CONSTANT.mastername.append("Tax Group")
                        self.apicall()
                    }
                    
                case .failure(let error):
                    CONSTANT.failapi += 1
                    CONSTANT.mastername.append("Tax Group")
                    self.apicall()
                    print("error \(error) - url \(url)")
                }
            }
    }
    //    MARK:- AUTO-CHARGE API
    public func getautocharge(){
        CONSTANT.apicall += 1
        let url = CONSTANT.BASE_URL + "AcxDriverApp/AcxDriverAppService/getAutoCharge"
        
        let headers = [
            "Authorization"                :   "Bearer \(self.accessToken)"
        ]
        var body: [String: AnyObject] = [:]
        
        print("body ---->\n \(url)\n")
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ExecuteApi.header)
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(url)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    if  (response.response!.statusCode == 200){ // 200
                        self.deletetable(tbl: "AutoCharge")
                        if let json = response.result.value as? [[String:Any]]{
                            if (json.count > 0){
                                for result in json {
                                    let id = result["$id"] as! String
                                    let ac = result["Account Code"] as! Int
                                    let cr = result["Customer Relation"] as! String
                                    let ic = result["Item Code"] as! Int
                                    let ir = result["Item relation"] as! String
                                    let modc = result["Mode of delivery code"] as! Int
                                    let modr = result["mode of delivery Relation"] as! String
                                    let cat = result["Charge Value Type"] as! Int
                                    let chcode = result["Charges Code"] as! String
                                    let chval = result["Charges Value"] as! Double
                                    let stg = result["sales tax group"] as! String
                                    let itemtaxgrp = result["Item sales tax group"] as! String
                                    let lline = result["Level Line"] as! String
                                    
                                    self.insertautocharge(id: id, accode: "\(ac)", custrelation: cr, itemcode: "\(ic)", itemrelation: ir, modc: "\(modc)", modr: modr, cat: "\(cat)", chcode: chcode, chval: "\(chval)", saletaxgrp: stg,itemtaxgrp : itemtaxgrp, levelline : lline)
                                }
                                self.apicall()
                            }else{
                                CONSTANT.failapi += 1
                                CONSTANT.mastername.append("Auto Charge")
                                self.apicall()
                            }
                        }else{
                            CONSTANT.failapi += 1
                            CONSTANT.mastername.append("Auto Charge")
                            self.apicall()
                        }
                    }else{
                        CONSTANT.failapi += 1
                        CONSTANT.mastername.append("Auto Charge")
                        self.apicall()
                    }
                    
                case .failure(let error):
                    CONSTANT.failapi += 1
                    CONSTANT.mastername.append("Auto Charge")
                    self.apicall()
                    print("error \(error) - url \(url)")
                }
            }
    }
    
    public func apicall(){}
    
    //    MARK:- ITEM-MASTER API
    public func getitemmaster(){
        CONSTANT.apicall += 1
        let url = CONSTANT.BASE_URL + "acxdriverapp/acxdriverappservice/getItemMaster"
        
        let headers = [
            "Authorization"                :   "Bearer \(self.accessToken)"
        ]
        var body: [String: AnyObject] = [:]
        
        print("body ---->\n \(url)\n")
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ExecuteApi.header)
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(url)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    if  (response.response!.statusCode == 200){ // 200
                        if let json = response.result.value as? [[String:Any]]{
                            if (json.count > 0){
                                self.deletetable(tbl: "ItemMaster")
                                for result in json {
                                    let itemcode = result["Item Code"] as! String
                                    let itemname = result["Item Name"] as! String
                                    let itemgstgrp = result["Item Gst Group"] as! String
                                    let linedesgrp = result["Line Discount Group"] as! String
                                    let itemchgrp = result["item charge group"] as! String
                                    let articletyp = result["Article Type"] as! String
                                    let isbatch = result["Is Batch Active"] as! Int
                                    let isserial = result["Is Serial Active"] as! Int
                                    let weight = result["Gross Weight"] as! Double
                                    let itemtype = result["Item type"] as! Int
                                    let isservice = result["Is service"] as! Bool
                                    let img = result["Product Image"] as! String
                                    
                                    self.insertitemmaster(itemid: itemcode, Itemname: itemname, itemgstgrp: itemgstgrp, articletyp: articletyp,linedisgrp: linedesgrp, itemchgrp: itemchgrp, isbatch: "\(isbatch)", isserial: "\(isserial)", imgurl: img,itemtype : "\(itemtype)",weight : "\(weight)",isservice: isservice)
                                }
                                self.apicall()
                            }else{
                                CONSTANT.failapi += 1
                                CONSTANT.mastername.append("Item Master")
                                self.apicall()
                            }
                        }else{
                            CONSTANT.failapi += 1
                            CONSTANT.mastername.append("Item Master")
                            self.apicall()
                        }
                    }else{
                        CONSTANT.failapi += 1
                        CONSTANT.mastername.append("Item Master")
                        self.apicall()
                    }
                    
                case .failure(let error):
                    CONSTANT.failapi += 1
                    CONSTANT.mastername.append("Item Master")
                    self.apicall()
                    print("error \(error) - url \(url)")
                }
            }
    }
    //    MARK:- SERIAL-MASTER API
    public func getserialmaster(){
//        CONSTANT.apicall += 1
        let url = CONSTANT.BASE_URL + "acxdriverapp/acxdriverappservice/getSerialMaster"
        
        let headers = [
            "Authorization"                :   "Bearer \(self.accessToken)"
        ]
        var body: [String: AnyObject] = [:]
        
        //    Response--
        //            "$id": "1",
        //                    "Invent Serial Id": "A001",
        //                    "ItemId": "AYU-001"
        print("body ---->\n \(url)\n")
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ExecuteApi.header)
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(url)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    if  (response.response!.statusCode == 200){ // 200
                        if let json = response.result.value as? [[String:Any]]{
                            if (json.count > 0){
                                self.deletetable(tbl: "SerialMaster")
                                for result in json {
                                    let id = result["$id"] as! String
                                    let invtserialid = result["Invent Serial Id"] as! String
                                    let itemid = result["ItemId"] as! String
                                    
                                    self.insertserialmaster(id: id, invtserial: invtserialid, itemid: itemid)
                                }
                                self.apicall()
                            }else{
                                CONSTANT.failapi += 1
                                CONSTANT.mastername.append("Serial Master")
                                self.apicall()
                            }
                        }else{
                            CONSTANT.failapi += 1
                            CONSTANT.mastername.append("Serial Master")
                            self.apicall()
                        }
                    }else{
                        CONSTANT.failapi += 1
                        CONSTANT.mastername.append("Serial Master")
                        self.apicall()
                    }
                    
                case .failure(let error):
                    CONSTANT.failapi += 1
                    CONSTANT.mastername.append("Serial Master")
                    self.apicall()
                    print("error \(error) - url \(url)")
                }
            }
    }
    //    MARK:- BATCH-MASTER API
    public func getbatchmaster(){
//        CONSTANT.apicall += 1
        let url = CONSTANT.BASE_URL + "acxdriverapp/acxdriverappservice/getBatchMaster"
        
        let headers = [
            "Authorization"                :   "Bearer \(self.accessToken)"
        ]
        var body: [String: AnyObject] = [:]
        
        print("body ---->\n \(url)\n")
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ExecuteApi.header)
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(url)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    if  (response.response!.statusCode == 200){ // 200
                        if let json = response.result.value as? [[String:Any]]{
                            self.deletetable(tbl: "BatchMaster")
                            if (json.count > 0){
                                for result in json {
                                    let id = result["$id"] as! String
                                    let invtbatchid = result["Invent Batch Id"] as! String
                                    let itemid = result["Item Id"] as! String
                                    
                                    self.insertbatchmaster(id : id,invtbatch : invtbatchid, itemid : itemid)
                                }
                                self.apicall()
                            }else{
                                CONSTANT.failapi += 1
                                CONSTANT.mastername.append("Batch Master")
                                self.apicall()
                            }
                        }else{
                            CONSTANT.failapi += 1
                            CONSTANT.mastername.append("Batch Master")
                            self.apicall()
                        }
                    }else{
                        CONSTANT.failapi += 1
                        CONSTANT.mastername.append("Batch Master")
                        self.apicall()
                    }
                    
                case .failure(let error):
                    CONSTANT.failapi += 1
                    CONSTANT.mastername.append("Batch Master")
                    self.apicall()
                    print("error \(error) - url \(url)")
                }
            }
    }
    //    MARK:- PRICE MASTER
    
    public func getpricemaster(){
        CONSTANT.apicall += 1
        let url = CONSTANT.BASE_URL + "AcxDriverApp/AcxDriverAppService/getPriceMaster"
        
        let headers = [
            "Authorization"                :   "Bearer \(self.accessToken)"
        ]
        var body: [String: AnyObject] = [:]
        
        print("body ---->\n \(url)\n")
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ExecuteApi.header)
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(url)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    if  (response.response!.statusCode == 200){ // 200
                        if let json = response.result.value as? [[String:Any]]{
                            self.deletetable(tbl: "PriceMaster")
                            if (json.count > 0){
                                for result in json {
                                    let id = result["$id"] as! String
                                    let accode = result["Account Code"] as! Int
                                    let acrelation = result["Account relation"] as! String
                                    let itemrelation = result["Item relation"] as! String
                                    let fromdate = result["From Date"] as! String
                                    let todate = result["To Date"] as! String
                                    let amt = result["Amount"] as! Double
                                    let priceunit = result["PriceUnit"] as! Double
                                    //    Response--
                                    //    [
                                    //        {
                                    //            "$id": "1",
                                    //            "Account Code": 2,
                                    //            "Account relation": "",
                                    //            "Item relation": "1011",
                                    //            "From Date": "2020-01-01T12:00:00",
                                    //            "To Date": "2020-12-31T12:00:00",
                                    //            "Amount": 11.4,
                                    //            "PriceUnit": 1.0
                                    //        },
                                    var fdate = "",tdate = ""
                                    if (fromdate.contains("T")){
                                        fdate = fromdate.replacingOccurrences(of: "T", with: " ")
                                    }else{
                                        fdate = fromdate
                                    }
                                    if (todate.contains("T")){
                                        tdate = todate.replacingOccurrences(of: "T", with: " ")
                                    }else{
                                        tdate = todate
                                    }
                                    
                                    self.insertpricemaster(id: id, accode: "\(accode)", acrelation: acrelation, itemrelation: itemrelation, fromdate: fdate, todate: tdate, amt: "\(amt)", priceunit: "\(priceunit)")
                                }
                                self.apicall()
                            }else{
                                CONSTANT.failapi += 1
                                CONSTANT.mastername.append("Price Master")
                                self.apicall()
                            }
                        }else{
                            CONSTANT.failapi += 1
                            CONSTANT.mastername.append("Price Master")
                            self.apicall()
                        }
                    }else{
                        CONSTANT.failapi += 1
                        CONSTANT.mastername.append("Price Master")
                        self.apicall()
                    }
                    
                case .failure(let error):
                    CONSTANT.failapi += 1
                    CONSTANT.mastername.append("Price Master")
                    self.apicall()
                    print("error \(error) - url \(url)")
                }
            }
    }
    //    MARK:- DISCOUNT MASTER
    
    public func getdiscountmaster(){
        CONSTANT.apicall += 1
        let url = CONSTANT.BASE_URL + "AcxDriverApp/AcxDriverAppService/getDiscountMaster"
        
        let headers = [
            "Authorization"                :   "Bearer \(self.accessToken)"
        ]
        var body: [String: AnyObject] = [:]
        
        print("body ---->\n \(url)\n")
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ExecuteApi.header)
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(url)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    if  (response.response!.statusCode == 200){ // 200
                        if let json = response.result.value as? [[String:Any]]{
                            self.deletetable(tbl: "DiscountMaster")
                            if (json.count > 0){
                                for result in json {
                                    let id = result["$id"] as! String
                                    let accode = result["Account Code"] as! Int
                                    let acrelation = result["Account relation"] as! String
                                    let itemcode = result["Item Code"] as! Int
                                    let itemrelation = result["Item relation"] as! String
                                    let fromdate = result["From Date"] as! String
                                    let todate = result["To Date"] as! String
                                    let fromqty = result["From Quantity"] as! Double
                                    let toqty = result["To Quantity"] as! Double
                                    let discount = result["Discount"] as! Double
                                    let disper = result["Discount Percent"] as! Double
                                    let fixamt = result["Fixed Amount"] as! Double
                                    
                                    //            "$id": "1",
                                    //            "Account Code": 2,
                                    //            "Account relation": "",
                                    //            "Item Code": 0,
                                    //            "Item relation": "1011",
                                    //            "From Date": "01/01/2020",
                                    //            "To Date": "31/12/2020",
                                    //            "From Quantity": 0.0,
                                    //            "To Quantity": 0.0,
                                    //            "Discount": 11.4,
                                    //            "Discount Percent": 0.0,
                                    //            "Fixed Amount": 0.0
                                    //        },
                                    var fdate = "",tdate = ""
                                    if (fromdate.contains("T")){
                                        fdate = fromdate.replacingOccurrences(of: "T", with: " ")
                                    }else{
                                        fdate = fromdate
                                    }
                                    if (todate.contains("T")){
                                        tdate = todate.replacingOccurrences(of: "T", with: " ")
                                    }else{
                                        tdate = todate
                                    }
                                    
                                    self.insertdiscountmaster(id: id, accode: "\(accode)", acrelation: acrelation, itemcode: "\(itemcode)", itemrelation: itemrelation, fromdate: "\(fromdate)", todate: "\(todate)", fromqty: "\(fromqty)", toqty: "\(toqty)", discount: "\(discount)", disper: "\(disper)", fixamt: "\(fixamt)")
                                }
                                self.apicall()
                            }else{
                                CONSTANT.failapi += 1
                                CONSTANT.mastername.append("Discount Master")
                                self.apicall()
                            }
                        }else{
                            CONSTANT.failapi += 1
                            CONSTANT.mastername.append("Discount Master")
                            self.apicall()
                        }
                    }else{
                        CONSTANT.failapi += 1
                        CONSTANT.mastername.append("Discount Master")
                        self.apicall()
                    }
                    
                case .failure(let error):
                    CONSTANT.failapi += 1
                    CONSTANT.mastername.append("Discount Master")
                    self.apicall()
                    print("error \(error) - url \(url)")
                }
            }
    }
    
    //    MARK:- Revenue Schedule
    public func getrevenueschedule(){
        CONSTANT.apicall += 1
        let url = CONSTANT.BASE_URL + "AcxDriverApp/AcxDriverAppService/getRevenueSchedule"
        
        let headers = [
            "Authorization"                :   "Bearer \(self.accessToken)"
        ]
        var body: [String: AnyObject] = [:]
        
        print("body ---->\n \(url)\n")
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ExecuteApi.header)
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(url)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    if  (response.response!.statusCode == 200){ // 200
                        if let json = response.result.value as? [[String:Any]]{
                            self.deletetable(tbl: "RevenueSchedule")
                            if (json.count > 0){
                                for result in json {
                                    let id = result["$id"] as! String
                                    let code = result["Code"] as! String
                                    let description = result["Description"] as! String
                                    
                                    self.insertrevenueschedule(id: id, code: code, description: description)
                                    
                                }
                                self.apicall()
                            }else{
                                CONSTANT.failapi += 1
                                CONSTANT.mastername.append("Revenue Schedule")
                                self.apicall()
                            }
                        }else{
                            CONSTANT.failapi += 1
                            CONSTANT.mastername.append("Revenue Schedule")
                            self.apicall()
                        }
                    }else{
                        CONSTANT.failapi += 1
                        CONSTANT.mastername.append("Revenue Schedule")
                        self.apicall()
                    }
                    
                case .failure(let error):
                    CONSTANT.failapi += 1
                    CONSTANT.mastername.append("Revenue Schedule")
                    self.apicall()
                    print("error \(error) - url \(url)")
                }
            }
    }
    
    //    MARK:- Reason Master
    public func getreasonmaster(){
        CONSTANT.apicall += 1
        let url = CONSTANT.BASE_URL + "AcxDriverApp/AcxDriverAppService/getReason"
        
        let headers = [
            "Authorization"                :   "Bearer \(self.accessToken)"
        ]
        var body: [String: AnyObject] = [:]
        
        print("body ---->\n \(url)\n")
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ExecuteApi.header)
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(url)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    if  (response.response!.statusCode == 200){ // 200
                        if let json = response.result.value as? [[String:Any]]{
                            self.deletetable(tbl: "ReasonMaster")
                            self.deletetable(tbl: "RescheduleReason")
                            if (json.count > 0){
                                for result in json {
                                    let id = result["$id"] as! String
                                    let type = result["Type"] as! Int
                                    let skipcode = result["Skip Code"] as! String
                                    let description = result["Description"] as! String
                                    
                                    if (type == 2){
                                        self.insertreschedulereason(id: id, reasoncode: skipcode, description: description)
                                    }else{
                                        self.insertreasonmaster(id: id,type : type ,skipcode: skipcode, description: description)
                                    }
                                }
                                self.apicall()
                            }else{
                                CONSTANT.failapi += 1
                                CONSTANT.mastername.append("Reason Master")
                                self.apicall()
                            }
                        }else{
                            CONSTANT.failapi += 1
                            CONSTANT.mastername.append("Reason Master")
                            self.apicall()
                        }
                    }else{
                        CONSTANT.failapi += 1
                        CONSTANT.mastername.append("Reason Master")
                        self.apicall()
                    }
                    
                case .failure(let error):
                    CONSTANT.failapi += 1
                    CONSTANT.mastername.append("Reason Master")
                    self.apicall()
                    print("error \(error) - url \(url)")
                }
            }
    }
    
    //    MARK:- RESCHEDULE REASON
    public func getreschedulereason(){
//        CONSTANT.apicall += 1
        let url = CONSTANT.BASE_URL + "AcxDriverApp/AcxDriverAppService/getRescheduleReason"
        
        let headers = [
            "Authorization"                :   "Bearer \(self.accessToken)"
        ]
        var body: [String: AnyObject] = [:]
        
        print("body ---->\n \(url)\n")
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ExecuteApi.header)
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(url)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    if  (response.response!.statusCode == 200){ // 200
                        if let json = response.result.value as? [[String:Any]]{
                            self.deletetable(tbl: "RescheduleReason")
                            if (json.count > 0){
                                for result in json {
                                    let id = result["$id"] as! String
                                    let reasoncode = result["Reason Code"] as! String
                                    let description = result["Description"] as! String
                                    
                                    self.insertreschedulereason(id: id ,reasoncode: reasoncode, description: description)
                                    
                                }
                                self.apicall()
                            }else{
                                CONSTANT.failapi += 1
                                self.apicall()
                            }
                        }else{
                            CONSTANT.failapi += 1
                            self.apicall()
                        }
                    }else{
                        CONSTANT.failapi += 1
                        self.apicall()
                    }
                    
                case .failure(let error):
                    CONSTANT.failapi += 1
                    self.apicall()
                    print("error \(error) - url \(url)")
                }
            }
    }
    //MARK:- POST UNLOAD
    public func postunload(){
        
        let url = CONSTANT.BASE_URL + "acxdriverapp/acxdriverappservice/getCheckinDetails"
        
        let headers = [
            "Authorization"                :   "Bearer \(self.accessToken)"
        ]
        //                var parameters: [String: AnyObject] = [:]
        var array: [AnyObject] = []
        var skuparameters: [String: AnyObject] = [:]
        var skuarray: [AnyObject] = []
        var body: [String: [AnyObject]] = [:]
        
        let base = BASEACTIVITY()
        let date = base.getdate(format: "yyyy-MM-dd")
        var stmt1:OpaquePointer?
        let query = "select a.itemid,case when c.isserial = '0' and c.isbatch = '0' then a.qty else b.qty end as qty,ifnull(b.batch,''),ifnull(b.serial,''),c.itemname from Checkinitems a left outer join batchserial b on a.itemid = b.lotid and b.type = 'Checkinitems' inner join itemmaster c on a.itemid = c.itemcode where a.datetime = '\(date)'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        skuarray.removeAll()
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let itemid = String(cString: sqlite3_column_text(stmt1, 0))
            let qty = sqlite3_column_int(stmt1, 1)
            let batch = String(cString: sqlite3_column_text(stmt1, 2))
            let serial = String(cString: sqlite3_column_text(stmt1, 3))
            let itemname = String(cString: sqlite3_column_text(stmt1, 4))
            
            skuparameters = [
                "Item Id" : itemid as AnyObject,
                "Item Name": itemname as AnyObject,
                "Quantity": qty as AnyObject,
                "Batch Number": batch as AnyObject,
                "Serial Number": serial as AnyObject
            ]
            skuarray.append(skuparameters as AnyObject)
        }
        let parameters = [
            "LoadSheet Number" : UserDefaults.standard.string(forKey: "loadnum") as AnyObject,
            "Driver Code" : UserDefaults.standard.string(forKey: "did") as AnyObject,
            "LoadSheet Date" :"\(date) 00:00:00.000" as AnyObject,
            "Time" : base.getdate(format: "hh:mm:ss a") as AnyObject,
            "lineDetails" : skuarray
        ] as [String : Any]
        array.append(parameters as AnyObject)
        body = [
            "getCheckinDetails" : array
        ]
        //        {
        //           "getCheckinDetails":[
        //              {
        //            "LoadSheet Number":"ALJ-000000335",
        //            "Driver Code" :"D00001",
        //            "LoadSheet Date" :"2021-01-08 00:00:00.000",
        //            "Time" :"10:00:00 AM",
        //            "lineDetails":[
        //                {
        //            "Item Id": "item1",
        //            "Item Name":"item1 test",
        //            "Batch Number":"batch27",
        //            "Serial Number":"serial27",
        //        "Quantity":9
        //                }
        //            ]
        //              }
        //           ]
        //        }
        print("body ---->\n \(body)\n")
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ExecuteApi.header)
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(url)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    if  (response.response!.statusCode == 200){ // 200
                        if ("\(response.result.value!)" == "1") {
                            self.undone()
                        }else{
                            self.unnot()
                        }
                    }else{
                        if (response.response?.statusCode == 500){
                            if let json = response.result.value as? [String:Any]{
                               if let msg = json["Message"] as? String {
                                if (msg.contains("An exception occured when invoking the operation -")){
                                    
                                    let err = msg.replacingOccurrences(of: "An exception occured when invoking the operation - ", with: "")
                                    AppDelegate.loaderr = err
                                }
                               }
                            }
                        }
                        self.unnot()
                    }
                    
                case .failure(let error):
                    self.unerr()
                    print("error \(error) - url \(url)")
                }
            }
    }
    public func undone(){}
    public func unnot(){}
    public func unerr(){}
    
    //MARK:- POST ORDER
    
    func getlinedetails(ordernum : String) -> [AnyObject] {
        var skuarray: [AnyObject] = []
        var skuparameters: [String: AnyObject] = [:]
        
        skuarray.removeAll()
        var stmt1:OpaquePointer?
        let query = "select itemnum,qty,price,itemdisper,itemdis,itemtaxgrp,lotid,totval,priceunit,revsch,cathitem from CustorderLine where custordernum = '\(ordernum)' and cast(qty as int) <> 0"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return skuarray
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let itemid = String(cString: sqlite3_column_text(stmt1, 0))
            let qty = sqlite3_column_double(stmt1, 1)
            let price = sqlite3_column_double(stmt1, 2)
            let disper = sqlite3_column_double(stmt1, 3)
            let dis = sqlite3_column_double(stmt1, 4)
            let taxgrp = String(cString: sqlite3_column_text(stmt1, 5))
            let lotid = String(cString: sqlite3_column_text(stmt1, 6))
            let totval = sqlite3_column_double(stmt1, 7)
            let priceunit = sqlite3_column_double(stmt1, 8)
            
            let revsc = String(cString: sqlite3_column_text(stmt1, 9))
            let cathit = String(cString: sqlite3_column_text(stmt1, 10))
            //                    "ItemNo.": "S1005",
            //                    "Item QTY": 10.0,
            //                    "Item Price": 200.0,
            //                    "Item discount percentage": 0.0,
            //                    "Item discount": 0.0,
            //                    "Item tax group": "S1",
            //                    "Lot id": "000002189",
            //                    "Item line amount": 2.0,
            //                    "Price Unit": 1.0,
            //                    "Catridge Type":"",
            //                    "RevenueScheduleID":"",
            skuparameters = [
                "ItemNo.": itemid as AnyObject,
                "Item QTY": qty as AnyObject,
                "Item Price": price as AnyObject,
                "Item discount percentage": disper as AnyObject,
                "Item discount": dis as AnyObject,
                "Item tax group": taxgrp as AnyObject,
                "Lot id": lotid as AnyObject,
                "Item line amount": totval as AnyObject,
                "Price Unit": priceunit as AnyObject,
                "Catridge Type": cathit as AnyObject,
                "RevenueScheduleID": revsc as AnyObject,
                "DimDetails": self.getitembatchserial(lotid: lotid) as AnyObject,
                "ItemCharges": self.getitemch(lotid: lotid) as AnyObject,
                "ItemTaxes" : self.getitemtax(lotid: lotid) as AnyObject
            ]
            skuarray.append(skuparameters as AnyObject)
        }
        
        return skuarray
    }
    
    func getitembatchserial(lotid : String) -> [AnyObject] {
        var skuarray: [AnyObject] = []
        var skuparameters: [String: AnyObject] = [:]
        
        //        "Batch Number":"C1",
        //        "Serial Number":"0",
        //        "Quantity'":0.4
        
        skuarray.removeAll()
        var stmt1:OpaquePointer?
        let query = "select batch,serial,qty from BatchSerial where lotid = '\(lotid)'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return skuarray
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let batch = String(cString: sqlite3_column_text(stmt1, 0))
            let serial = String(cString: sqlite3_column_text(stmt1, 1))
            let qty = sqlite3_column_double(stmt1, 2)
            
            skuparameters = [
                "Batch Number": batch as AnyObject,
                "Serial Number": serial as AnyObject,
                "Quantity": qty as AnyObject
            ]
            skuarray.append(skuparameters as AnyObject)
            
        }
        
        return skuarray
    }
    
    func getitemch(lotid : String) -> [AnyObject] {
        var skuarray: [AnyObject] = []
        var skuparameters: [String: AnyObject] = [:]
        
        skuarray.removeAll()
        var stmt1:OpaquePointer?
        let query = "select chcode,chtype,chamt,chval from CustItemCharge where lotid = '\(lotid)'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return skuarray
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let chcode = String(cString: sqlite3_column_text(stmt1, 0))
            let chtype = sqlite3_column_int(stmt1, 1)
            let chamt = sqlite3_column_double(stmt1, 2)
            let chval = sqlite3_column_double(stmt1, 3)
            
            skuparameters = [
                "Charge Code": chcode as AnyObject,
                "Charge Type": chtype as AnyObject,
                "Charge Amount": chamt as AnyObject,
                "Charge Value": chval as AnyObject
            ]
            skuarray.append(skuparameters as AnyObject)
        }
        
        return skuarray
    }
    
    func getitemtax(lotid : String)-> [AnyObject] {
        var skuarray: [AnyObject] = []
        var skuparameters: [String: AnyObject] = [:]
        //                                            "Tax Code": "S1",
        //                                    "Item Tax Group": "S1",
        //                                    "Tax Amount": 0.2,
        //                                    "Tax Percent": 0.0
        skuarray.removeAll()
        var stmt1:OpaquePointer?
        let query = "select * from CustItemTax where lotid = '\(lotid)'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return skuarray
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let taxcode = String(cString: sqlite3_column_text(stmt1, 0))
            let itemtaxgrp = String(cString: sqlite3_column_text(stmt1, 0))
            let taxamt = sqlite3_column_double(stmt1, 2)
            let taxper = sqlite3_column_double(stmt1, 3)
            
            skuparameters = [
                "Tax Code": taxcode as AnyObject,
                "Item Tax Group": itemtaxgrp as AnyObject,
                "Tax Amount": taxamt as AnyObject,
                "Tax Percent": taxper as AnyObject
            ]
            skuarray.append(skuparameters as AnyObject)
        }
        
        return skuarray
    }
    
    func getimage(orderid: String, imgtype: String, activity: String)-> String {
        
        var stmt1:OpaquePointer?
        var im = ""
        let query = "select image from images where ordernum = '\(orderid)' and activity= '\(activity)' and type = '\(imgtype)'"
        print("image query -> \(query)")
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return im
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            im = String(cString: sqlite3_column_text(stmt1, 0))
        }
        
        return im
    }
    
    public func postcustorder(){
        let url = CONSTANT.BASE_URL + "acxdriverapp/acxdriverappservice/PostDeliveryDetails"
        
        let headers = [
            "Authorization"                :   "Bearer \(self.accessToken)"
        ]
        //                var parameters: [String: AnyObject] = [:]
        var skuparameters: [String: AnyObject] = [:]
        var skuarray: [AnyObject] = []
        var body: [String: [AnyObject]] = [:]
        var ids = [String]()
        ids.removeAll()
        let base = BASEACTIVITY()
        let date = base.getdate(format: "yyyy-MM-dd")
        var stmt1:OpaquePointer?
        let query = "select b.type,a.custordernum,a.pono,ifnull(a.acceptedby,''),a.shipdate,b.reasoncode,b.description,b.note,b.date as canceltodate,a.date as orderdate,a.custid,a.delnote,a.custtaxgrp,a.custchgrp,a.custmod,a.custpricegrp,a.custdisgrp,a.ordernote,a.custordrchcode,a.custorderchval,a.custorderchtax,b.skipcancelname,a.pomandate from CustorderHeader a inner join NoDelReason b on a.custordernum = b.ordernum and b.type <> '4' and b.post = '0' order by b.s_id"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let type = sqlite3_column_int(stmt1, 0)
            let orderid = String(cString: sqlite3_column_text(stmt1, 1))
            let pono = String(cString: sqlite3_column_text(stmt1, 2))
            let acceptedby = String(cString: sqlite3_column_text(stmt1, 3))
            let shipdate = String(cString: sqlite3_column_text(stmt1, 4))
            
            ids.append(orderid)
            
            let reasoncode = String(cString: sqlite3_column_text(stmt1, 5))
            let desc = String(cString: sqlite3_column_text(stmt1, 6))
            let addnote = String(cString: sqlite3_column_text(stmt1, 7))
            let canceldate = String(cString: sqlite3_column_text(stmt1, 8))
            let orderdate = String(cString: sqlite3_column_text(stmt1, 9))
            
            let custid = String(cString: sqlite3_column_text(stmt1, 10))
            let delnote = String(cString: sqlite3_column_text(stmt1, 11))
            let custtaxgrp = String(cString: sqlite3_column_text(stmt1, 12))
            let custchgrp = String(cString: sqlite3_column_text(stmt1, 13))
            let custmod = String(cString: sqlite3_column_text(stmt1, 14))
            
            let pricegrp = String(cString: sqlite3_column_text(stmt1, 15))
            let disgrp = String(cString: sqlite3_column_text(stmt1, 16))
            let ordernote = String(cString: sqlite3_column_text(stmt1, 17))
            let ordrchcode = String(cString: sqlite3_column_text(stmt1, 18))
            let orderchval = sqlite3_column_double(stmt1, 19)
            
            let orderchtax = sqlite3_column_double(stmt1, 20)
            let skipcancelname = String(cString: sqlite3_column_text(stmt1, 21))
            let pomandate = String(cString: sqlite3_column_text(stmt1, 22)) == "true" ? 1 : 0
            
            skuparameters = [
                "Loadsheet Number": UserDefaults.standard.string(forKey: "loadnum") as AnyObject,
                "Type": type as AnyObject,
                "Customer Order Number": orderid as AnyObject,
                "Po No": pono as AnyObject,
                "Order accepted by": acceptedby as AnyObject,
                "Signature": self.getimage(orderid: orderid, imgtype: "1", activity: "\(type)") as AnyObject,
                "Photo": self.getimage(orderid: orderid, imgtype: "2", activity: "\(type)") as AnyObject,
                "Ship Date": shipdate as AnyObject,
                "Reason Code": reasoncode as AnyObject,
                "Reason Description": desc as AnyObject,
                "NameSkipCancel": skipcancelname as AnyObject,
                "Additional Note": addnote as AnyObject,
                "Reschedule Date": canceldate as AnyObject,
                "Order Date": orderdate as AnyObject,
                "Customer Account No": custid as AnyObject,
                "Delivery Note": delnote as AnyObject,
                "Customer Tax Group": custtaxgrp as AnyObject,
                "Customer Charge Group": custchgrp as AnyObject,
                "Customer Mode of Delivery": custmod as AnyObject,
                "Customer Price Group": pricegrp as AnyObject,
                "Customer Discount Group": disgrp as AnyObject,
                "Order Note": ordernote as AnyObject,
                "Customer order charge code": ordrchcode as AnyObject,
                "Customer order charges": orderchval as AnyObject,
                "Customer order charges Tax": orderchtax as AnyObject,
                "PO Mandatory": pomandate as AnyObject,
                "lineDetails" : self.getlinedetails(ordernum: orderid) as AnyObject
            ]
            if(self.getlinedetails(ordernum: orderid).count > 0){
                skuarray.append(skuparameters as AnyObject)
            }
        }
        
        body = [
            "DeliveryDetails" : skuarray
        ]
        print("body ---->\n \(body)\n")
        if (skuarray.count > 0){
            Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ExecuteApi.header)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        // server data
                        print("url \(url)")
                        print("\n*******************************************************\n")
                        print("\nresponse.result.value \(response.result.value!) \n\n")
                        if  (response.response!.statusCode == 200){ // 200
                            if ("\(response.result.value!)" == "1") {
                                self.updatehistory(ids: ids)
                                self.orderdone()
                                self.apicall()
                            }else{
                                self.ordernot()
                            }
                        }else{
                            self.ordernot()
                        }
                        
                    case .failure(let error):
                        self.ordererr()
                        print("error \(error) - url \(url)")
                    }
                }
        }else{
            self.orderdone()
        }
    }
    
    public func orderdone(){}
    public func ordernot(){}
    public func ordererr(){}
    
    //    MARK:- TRUCK TRANSFER STATUS
    public func getTruckTransferStatus(){
        let url = CONSTANT.BASE_URL+"acxdriverapp/acxdriverappservice/getTruckTransferStatus"
        let headers = [
            "Authorization": "Bearer \(self.accessToken)"
        ]
        //        {
        //            "getTruckTransferStatus":[
        //                {
        //                    "Driver id":"D00001"
        //                }
        //            ]
        //        }
        var body: [String: [AnyObject]] = [:]
        var parameters: [String: AnyObject] = [:]
        var array: [AnyObject] = []
        parameters = [
            "Driver id" : UserDefaults.standard.string(forKey: "did")! as AnyObject
        ]
        array.append(parameters as AnyObject)
        body =  [
            "getTruckTransferStatus" : array
        ]
        print("body ---> \(body)")
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ExecuteApi.header)
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(response.request?.debugDescription)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value\n \(response.result.value!) \n")
                    if  (response.response!.statusCode == 200){ // 200 - created ocde
                        
                        if let json = response.result.value as? [[String:Any]] {
                            self.deletetable(tbl: "TruckTransferStatus")
                            //                                [
                            //                                    {
                            //                                        "$id": "1",
                            //                                        "TruckTransferId": "Veh01",
                            //                                        "Status": 2
                            //
                            //                                    }
                            //                                ]
                            for result in json{
                                let trucktransferid = result["TruckTransferId"] as! String
                                let status = result["Status"] as! Int
                                
                                STOCKTRVC.status = status
                            }
                            self.gottrstatus()
                            print("\n\n ====================>> \n\n")
                        }else{
                            self.nottrstatus()
                        }
                    }else{
                        self.nottrstatus()
                    }
                    
                case .failure(let error):
                    self.cerr()
                    print("error \(error) - url \(url)")
                }
            }
    }
    
    public func gottrstatus(){}
    public func cerr(){}
    public func nottrstatus(){}
    
    //    MARK:- TRUCK MASTER
    public func getTruckMaster(){
        CONSTANT.apicall += 1
        let url = CONSTANT.BASE_URL + "AcxDriverApp/AcxDriverAppService/getTruckMaster"
        
        let headers = [
            "Authorization"                :   "Bearer \(self.accessToken)"
        ]
        var body: [String: AnyObject] = [:]
        
        print("body ---->\n \(url)\n")
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ExecuteApi.header)
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(url)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    if  (response.response!.statusCode == 200){ // 200
                        if let json = response.result.value as? [[String:Any]]{
                            self.deletetable(tbl: "TruckMaster")
                            if (json.count > 0){
                                for result in json {
                                    let id = result["$id"] as! String
                                    let code = result["code"] as! String
                                    let description = result["Description"] as! String
                                    let drvid = result["Driver Id"] as! String
                                    //                                    {
                                    //                                            "$id": "1",
                                    //                                            "code": "10712",
                                    //                                            "Description": "Moorabin Quaratine warehouse",
                                    //                                            "Driver Id": ""
                                    //                                        }
                                    self.insertTruckMaster(id: id ,code: code, description: description,driverid: drvid)
                                    
                                }
                                self.apicall()
                            }else{
                                CONSTANT.failapi += 1
                                CONSTANT.mastername.append("Truck Master")
                                self.apicall()
                            }
                        }else{
                            CONSTANT.failapi += 1
                            CONSTANT.mastername.append("Truck Master")
                            self.apicall()
                        }
                    }else{
                        CONSTANT.failapi += 1
                        CONSTANT.mastername.append("Truck Master")
                        self.apicall()
                    }
                    
                case .failure(let error):
                    CONSTANT.failapi += 1
                    CONSTANT.mastername.append("Truck Master")
                    self.apicall()
                    print("error \(error) - url \(url)")
                }
            }
    }
    //    MARK:- TRANSFER DETAILS
    public func getTransferDeltais(){
        CONSTANT.apicall += 1
        let url = CONSTANT.BASE_URL + "acxdriverapp/acxdriverappservice/getTransferDeltais"
        
        let headers = [
            "Authorization"                :   "Bearer \(self.accessToken)"
        ]
        var body: [String: [AnyObject]] = [:]
        var parameters: [String : AnyObject] = [:]
        var array: [AnyObject] = []
        
        parameters = [
            "Driver id" : UserDefaults.standard.string(forKey: "did")! as AnyObject
        ]
        
        array.append(parameters as AnyObject)
        body = [
            "getTransferDeltais" : array
        ]
        
        print("body ---->\n \(url)\n")
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ExecuteApi.header)
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(url)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    if  (response.response!.statusCode == 200){ // 200
                        if let json = response.result.value as? [[String:Any]]{
                            if (json.count > 0){
                                self.deletetable(tbl: "TransferDetails")
                                self.deletetable(tbl: "TransferDetailsSku")
                                for result in json {
                                    let id = result["$id"] as! String
                                    let trucktransferid = result["TruckTransferId"] as! String
                                    let fromtruck = result["FromTruck"] as! String
                                    let ToTruck = result["ToTruck"] as! String
                                    let status = result["Status"] as! Int
                                    
                                    self.insertTransferDetails(id: id, trucktransferid: trucktransferid, fromtruck: fromtruck,ToTruck : ToTruck, status: status)
                                    if let orders = result["SKU Details"] as? [[String:Any]]{
                                        if (json.count > 0){
                                            for order in orders {
                                                let itemid = order["ItemId"] as! String
                                                let inventbatchid = order["InventBatchId"] as! String
                                                let inventserialid = order["InventSerialId"] as! String
                                                let itemname = order["ItemName"] as! String
                                                let qty = order["Qty"] as! Double
                                                
                                                self.insertTransferDetailsSku(skuid: trucktransferid, itemid: itemid, inventbatchid: inventbatchid, inventserialid:  inventserialid, itemname: itemname, qty: qty)
                                            }
                                        }else{
                                            CONSTANT.failapi += 1
                                            self.apicall()
                                            CONSTANT.mastername.append("Transfer Details")
                                        }
                                    }else{
                                        CONSTANT.failapi += 1
                                        self.apicall()
                                        CONSTANT.mastername.append("Transfer Details")
                                    }
                                }
                                self.apicall()
                            }else{
                                self.apicall()
                            }
                            print("\n\n ====================>> \n\n")
                        }else{
                            self.apicall()
                        }
                    }else{
                        CONSTANT.failapi += 1
                        self.apicall()
                        CONSTANT.mastername.append("Transfer Details")
                    }
                    
                case .failure(let error):
                    print("error \(error) - url \(url)")
                    CONSTANT.failapi += 1
                    self.apicall()
                    CONSTANT.mastername.append("Transfer Details")
                }
            }
        
    }
    
    //    MARK:- POST TRANSFER STATUS
    public func posttransferstatus(acceptreject: Int, transferid: String){
        let url = CONSTANT.BASE_URL + "acxdriverapp/acxdriverappservice/postTransferDetail"
        
        let headers = [
            "Authorization"                :   "Bearer \(self.accessToken)"
        ]
        var array: [AnyObject] = []
        var body: [String: [AnyObject]] = [:]
        
        let parameters = [
            "TruckTransferId" : transferid as AnyObject,
            "AcceptReject" : acceptreject as AnyObject
        ] as [String : Any]
        array.append(parameters as AnyObject)
        body = [
            "postTransferDetail" : array
        ]
        
        print("body ---->\n \(body)\n")
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ExecuteApi.header)
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(url)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    if  (response.response!.statusCode == 200){ // 200
                        if "\(response.result.value!)" == "1" {
                            self.tdgot()
                        }else{
                            self.tdnot()
                        }
                    }else{
                        self.tdnot()
                    }
                    
                case .failure(let error):
                    self.tderr()
                    print("error \(error) - url \(url)")
                }
            }
    }
    public func tdgot(){}
    public func tdnot(){}
    public func tderr(){}
    
    //    URL--https://ccaauauesdevrsg002c64eeededf151cffdevaos.cloudax.dynamics.com/api/services/acxdriverapp/acxdriverappservice/postStockTransfer
    
    //    JSON--
    
    
    //    Response-- 1 if posted otherwise 0
    //    MARK:- POST TRANSFER DETAILS
    public func posttransferdetails(truckid: String){
//        https://apimtst.ccamatil.com/p/neverfail2/acxdriverapp/acxdriverappservice/postStockTransfer
        let url = CONSTANT.BASE_URL + "acxdriverapp/acxdriverappservice/postStockTransfer"
        
        let headers = [
            "Authorization"                :   "Bearer \(self.accessToken)"
        ]
        var array: [AnyObject] = []
        var body: [String: [AnyObject]] = [:]
        var skuparameters: [String: AnyObject] = [:]
        var skuarray: [AnyObject] = []
        
        var stmt1:OpaquePointer?
        let query = "select a.qty,a.itemid,ifnull(b.serial,''),ifnull(b.batch,'') from StockTransfer a left outer join BatchSerial b on a.itemid = b.lotid where a.trkid <> '' and b.type = 'stocktr'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        skuarray.removeAll()
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let qty = sqlite3_column_double(stmt1, 0)
            let itemid = String(cString: sqlite3_column_text(stmt1, 1))
            let serial = String(cString: sqlite3_column_text(stmt1, 2))
            let batch = String(cString: sqlite3_column_text(stmt1, 3))
            
            skuparameters = [
                "ItemId" : itemid as AnyObject,
                "InventBatchId" : batch as AnyObject,
                "InventSerialId" : serial as AnyObject,
                "Qty" : qty as AnyObject,
            ]
            
            skuarray.append(skuparameters as AnyObject)
        }
        let base = BASEACTIVITY()
        let loadnum = UserDefaults.standard.string(forKey: "loadnum")!
        let transferid = loadnum + base.getdate(format: "HH:mm:ss.SSS")
        let parameters = [
            "LoadNo" : loadnum as AnyObject,
            "TruckTransferId" : transferid as AnyObject,
            "DriverId" : UserDefaults.standard.string(forKey: "did")! as AnyObject,
            "ToTruckCode" : truckid as AnyObject,
            "LineDetails" : skuarray as AnyObject
        ] as [String : Any]
        
        array.append(parameters as AnyObject)
        
        body = [
            "postStockTransfer" : array
        ]
//            {
//            "postStockTransfer":
//            [
//            {
//            "LoadNo": "ALJ-000000325",
//            "TruckTransferId": "Veh01",
//            "DriverId": "D00001",
//            "ToTruckCode": "Veh01",
//            "LineDetails": [
//            {
//            "ItemId": "S1005",
//            "InventBatchId": 1.0,
//            "InventSerialId": 2.0,
//            "Qty": 2.0
//            }
//            ]
//            }
//            ]
//            }
        print("body ---->\n \(body)\n")
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ExecuteApi.header)
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(url)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    if  (response.response!.statusCode == 200){ // 200
                        if "\(response.result.value!)" == "1" {
                            self.sdgot(id: transferid)
                        }else{
                            self.sdnot()
                        }
                    }else{
                        self.sdnot()
                    }
                    
                case .failure(let error):
                    self.sderr()
                    print("error \(error) - url \(url)")
                }
            }
        
    }
    public func sdgot(id : String){}
    public func sdnot(){}
    public func sderr(){}
    
    //    MARK:- LOAD DETAILS
    public func getloaddetails_sync(){
        CONSTANT.apicall += 1
        let url = CONSTANT.BASE_URL + "acxdriverapp/acxdriverappservice/getLoadDetails"
        
        let headers = [
            "Authorization"                :   "Bearer \(self.accessToken)"
        ]
        var parameters: [String: AnyObject] = [:]
        var array: [AnyObject] = []
        var body: [String: [AnyObject]] = [:]
        
        parameters = [
            "Driver id" : UserDefaults.standard.string(forKey: "userid") as AnyObject
        ]
        array.append(parameters as AnyObject)
        body = [
            "getLoadDetails" : array
        ]
        
        print("body ---->\n \(url)\n")
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ExecuteApi.header)
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(url)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    if  (response.response!.statusCode == 200){ // 200
                        if let json = response.result.value as? [[String:Any]]{
                            self.deletetable(tbl: "Loading")
                            self.deletesbatchtbl(type: "loading")
                            let result = json[0]
                            let ln = result["Load Number"] as! String
                            UserDefaults.standard.setValue(ln, forKey: "loadnum")
                            if let sku = result["SKU Details"] as? [[String:Any]]{
                                for load in sku {
                                    let id = load["$id"] as! String
                                    let itemname = load["Item Name"] as! String
                                    let itemid = load["Item Id"] as! String
                                    let qty = load["Quantity"] as! Int
                                    let batch = load["Batch Number"] as! String
                                    let serial = load["Serial Number"] as! String
                                    
                                    self.insertload(id: id, itemname: itemname, itemid: itemid, qty: "\(qty)", batch: batch, serial: serial)
                                }
                                self.getcustdetails()
                                self.apicall()
                            }else{
                                CONSTANT.failapi += 1
                                self.apicall()
                                CONSTANT.mastername.append("Load Details")
                            }
                        }else{
                            CONSTANT.failapi += 1
                            self.apicall()
                            CONSTANT.mastername.append("Load Details")
                        }
                    }else{
                        if (response.response?.statusCode == 500){
                            if let json = response.result.value as? [String:Any]{
                              if let msg = json["Message"] as? String {
                                if (msg.contains("An exception occured when invoking the operation -")){
                                    
                                    let err = msg.replacingOccurrences(of: "An exception occured when invoking the operation - ", with: "")
                                    AppDelegate.loaderr = err
                                }
                            }
                            }
                        }
                        CONSTANT.failapi += 1
                        self.apicall()
                    }
                    
                case .failure(let error):
                    CONSTANT.failapi += 1
                    self.apicall()
                    CONSTANT.mastername.append("Load Details")
                    print("error \(error)")
                }
            }
    }
    //    MARK:- GET UNLOAD DETAILS
    public func getunloaddetails(){
        
        CONSTANT.apicall += 1
        let url = CONSTANT.BASE_URL + "acxdriverapp/acxdriverappservice/GetUnloadDetails"
        
        let headers = [
            "Authorization"                :   "Bearer \(self.accessToken)"
        ]
        var parameters: [String: AnyObject] = [:]
        var array: [AnyObject] = []
        var body: [String: [AnyObject]] = [:]
        
        parameters = [
            "Driver id" : UserDefaults.standard.string(forKey: "did") as AnyObject
        ]
        array.append(parameters as AnyObject)
        body = [
            "GetUnloadDetails" : array
        ]
        
        print("body ---->\n \(url)\n")
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ExecuteApi.header)
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(url)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    if  (response.response!.statusCode == 200){ // 200
                        if let json = response.result.value as? [[String:Any]]{
                            self.deletetable(tbl: "Checkinitems")
                            self.deletetable(tbl: "Unloading")
                            for load in json {
                                let itemid = load["ItemId"] as! String
                                let qty = load["CheckInQuantity"] as! Int
                                let batch = load["InventBatchId"] as! String
                                let serial = load["InventSerialId"] as! String
                                
                                self.insertunload(itemid: itemid, qty: "\(qty)", batch: batch, serial: serial)
                            }
                            self.apicall()
                        }else{
                            self.apicall()
                        }
                    }else{
                        CONSTANT.failapi += 1
                        self.apicall()
                        CONSTANT.mastername.append("Unload Details")
                    }
                    
                case .failure(let error):
                    CONSTANT.failapi += 1
                    self.apicall()
                    CONSTANT.mastername.append("Unload Details")
                    print("error \(error)")
                }
            }
        
    }
    //    MARK:- ADDRESS VALIDATION
    public func srchaddr(str: String){
        var string = ""
        if str.contains(" "){
            string = str.replacingOccurrences(of: " ", with: "%20")
        }else{
            string = str
        }
        
        let url = "https://apimdev.ccamatil.com/p/data-validation/sensis/address?country=AU&formatted_address=\(string)"
        
        let headers = [
//            "Ocp-Apim-Subscription-Key" : "ea9d9ed679c648ad886323b75c58bdbd",
            "Element" : "NVF-Driver",
            "Authorization" : "Bearer \(self.accessToken)"
        ]
        var idarr = [String]()
        var addarr = [String]()
        idarr.removeAll()
        addarr.removeAll()
        print("body ---->\n \(url)\n")
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(url)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    if  (response.response!.statusCode == 200){ // 200
                        if let json = response.result.value as? [String:Any]{
                            
                            if let result = json["results"] as? [[String:Any]]{
                                for ad in result {
                                    let id = ad["search_result_id"] as! String
                                    let name = ad["formatted_address"] as! String
                                    
                                    idarr.append(id)
                                    addarr.append(name)
                                }
                                self.gotaddsrch(id: idarr,add: addarr, text: str)
                            }else{
                                self.notaddsrch()
                            }
                        }else{
                            self.notaddsrch()
                        }
                    }else{
                        self.notaddsrch()
                    }
                    
                case .failure(let error):
                    self.adderr()
                    print("error \(error)")
                }
            }
    }
    public func gotaddsrch(id: [String],add: [String], text: String){}
    public func notaddsrch(){}
    public func adderr(){}
    
    public func getaddr(id: String){
        let url = "https://apimdev.ccamatil.com/p/data-validation/sensis/address/\(id)"
        let headers = [
//            "Ocp-Apim-Subscription-Key" : "ea9d9ed679c648ad886323b75c58bdbd",
            "Element" : "NVF-Driver",
            "Authorization" : "Bearer \(self.accessToken)"
        ]
        
        print("body ---->\n \(url)\n")
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(url)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    if  (response.response!.statusCode == 200){ // 200
                        if let json = response.result.value as? [String:Any]{
                            //                            "postcode": "2151",
                            //                                    "state": "NSW",
                            //                                    "street_address": "27f North Rocks Rd",
                            //                                    "street_number": "27F",
                            //                                    "street_name": "North Rocks",
                            //                                    "street_type": "Rd",
                            //                                    "suburb": "NORTH ROCKS",
                            //                                    "country": "AUSTRALIA",
                            if let result = json["result"] as? [String:Any]{
                                var suburb = "",postcode = "",state = "",country = "",lati = "",longi = "";
                                postcode = result["postcode"] as! String
                                suburb = result["suburb"] as! String
                                state = result["state"] as! String
                                country = result["country"] as! String
                                lati = result["geo_lat"] as! String
                                longi = result["geo_lon"] as! String
                                
                                self.gotaddr(postcode: postcode, suburb: suburb, state: state,country: country, lati: lati, longi: longi)
                            }else{
                                self.notaddsrch()
                            }
                        }else{
                            self.notaddsrch()
                        }
                    }else{
                        self.notaddsrch()
                    }
                    
                case .failure(let error):
                    self.adderr()
                    print("error \(error)")
                }
            }
    }
    
    public func gotaddr(postcode: String, suburb: String,state: String,country: String, lati: String, longi: String){}
    
    //  MARK:- SUB SEGMENT
    public func getsubsegment(){
        CONSTANT.apicall += 1
        let url = CONSTANT.BASE_URL + "acxdriverapp/acxdriverappservice/getSubSegmentMaster"
        
        let headers = [
            "Authorization"                :   "Bearer \(self.accessToken)"
        ]
        var parameters: [String: AnyObject] = [:]
        var array: [AnyObject] = []
        
        print("body ---->\n \(url)\n")
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ExecuteApi.header)
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(url)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    if  (response.response!.statusCode == 200){ // 200
                        if let json = response.result.value as? [[String:Any]]{
                            self.deletetable(tbl: "SubSegment")
                            for load in json {
                                let segmentid = load["Segment id"] as! String
                                let subsegmentid = load["Sub segment id"] as! String
                                let subsegmentdesc = load["Sub segment description"] as! String
                                
                                //                                    {
                                //                                            "$id": "1",
                                //                                            "Segment id": "CG01",
                                //                                            "Sub segment id": "AU01",
                                //                                            "Sub segment description": "Mining"
                                //                                        },
                                self.insertsubsegment(segmentid: segmentid, subsegmentid: subsegmentid, descp: subsegmentdesc)
                            }
                            self.gotsubsegmentmaster()
                            self.apicall()
                            
                        }else{
                            CONSTANT.failapi += 1
                            self.apicall()
                            CONSTANT.mastername.append("Sub-Segment Master")
                        }
                    }else{
                        CONSTANT.failapi += 1
                        self.apicall()
                        CONSTANT.mastername.append("Sub-Segment Master")
                    }
                    
                case .failure(let error):
                    CONSTANT.failapi += 1
                    CONSTANT.mastername.append("Sub-Segment Master")
                    self.apicall()
                    print("error \(error)")
                }
            }
    }
    
    public func gotsubsegmentmaster(){}
    
    //    MARK:- GET LINE OF DUTY
    public func getlineodduty(){
        CONSTANT.apicall += 1
        let url = CONSTANT.BASE_URL + "acxdriverapp/acxdriverappservice/getLineOfBusinessMaster"
        
        let headers = [
            "Authorization"                :   "Bearer \(self.accessToken)"
        ]
        var parameters: [String: AnyObject] = [:]
        var array: [AnyObject] = []
        
        print("body ---->\n \(url)\n")
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ExecuteApi.header)
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(url)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    if  (response.response!.statusCode == 200){ // 200
                        if let json = response.result.value as? [[String:Any]]{
                            self.deletetable(tbl: "LineOfBussiness")
                            var descp = ""
                            for load in json {
                                
                                let lob_id = load["Line Of Business Id"] as! String
                                let desc = load["Description"] as! String
                                descp = desc
                                if (desc.contains("'")){
                                    descp = desc.replacingOccurrences(of: "'", with: "''")
                                }
                                //                                    "Line Of Business Id": "EH",
                                //                                            "Description": "Emergency Hydration"
                                self.insertlineofbussiness(lobid: lob_id, descp: descp)
                            }
                            self.gotLOBmaster()
                            self.apicall()
                            
                        }else{
                            CONSTANT.failapi += 1
                            self.apicall()
                            CONSTANT.mastername.append("L.O.B. Master")
                        }
                    }else{
                        CONSTANT.failapi += 1
                        self.apicall()
                        CONSTANT.mastername.append("L.O.B. Master")
                    }
                    
                case .failure(let error):
                    CONSTANT.failapi += 1
                    self.apicall()
                    CONSTANT.mastername.append("L.O.B. Master")
                    print("error \(error)")
                }
            }
    }
    public func gotLOBmaster(){}
    
//    MARK:- SUMMARY REPORT
    func getsummaryreport(drid: String,date: String){
        let url = CONSTANT.BASE_URL + "summary-reports"
        
        let headers = [
            "Authorization"                :   "Bearer \(self.accessToken)"
        ]
        var parameters: [String: AnyObject] = [:]
//        POST: https://apimdev.ccamatil.com/p/neverfail/summary-reports  (DEV)
//        Body:
//        {
//            "Driverid": "100000020",
//            "Summarydate": "YYYY-MM-DD"
//        }
        parameters = [
            "Driverid" : drid as AnyObject,
            "Summarydate" : date as AnyObject
        ]
        print("body ---->\n \(parameters)\n")
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    // server data
                    print("url \(url)")
                    print("\n*******************************************************\n")
                    print("\nresponse.result.value \(response.result.value!) \n\n")
                    if  (response.response!.statusCode == 200){ // 200
                        if let json = response.result.value as? [String:Any]{
//                            {"status":"Success"}
                            let status = json["status"] as! String
                            if (status == "Success"){
                                self.sumdone()
                            }else{
                                self.sumerr()
                            }
                        }else{
                            self.sumerr()
                        }                        
                    }else{
                        self.sumerr()
                    }
                    
                case .failure(let error):
                    self.sumerr()
                    print("error \(error)")
                }
            }
    }

    public func sumdone(){}
    public func sumerr(){}
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }

    
}
