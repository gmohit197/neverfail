//
//  RAISECASEVC.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 13/08/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import SQLite3
import SwiftEventBus

class RAISECASEVC: BASEACTIVITY,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count : Int
        if (tableView.tag == 1){
            count = self.fadapter.count
        }else {
            count = self.sadapter.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let list : RAISECASEADAPTER
              
        if (tableView.tag == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "opencell") as! RAISECASECELL
            list = fadapter[indexPath.row]
            cell.ftext.text = list.id
            cell.fdate.text = list.text
            cell.ftype.text = list.type
            
            switch (list.status){
            
            case "5" : cell.desc = "Problem Solved"
                cell.infobtn.setBackgroundImage(UIImage(named: "taskdone"), for: .normal)
                cell.infobtn.setBackgroundImage(UIImage(named: "taskdone"), for: .selected)
                break
                
            case "1000" : cell.desc = "Information Provided"
                cell.infobtn.setBackgroundImage(UIImage(named: "infoneed"), for: .normal)
                break
                
            case "6" : cell.desc = "Cancelled"
                cell.infobtn.setBackgroundImage(UIImage(named: "cancelled"), for: .normal)
                break
                
            case "2000" : cell.desc = "Merged"
                cell.infobtn.setBackgroundImage(UIImage(named: "merged"), for: .normal)
                break
                
            case "1" : cell.desc = "In Progress"
                cell.infobtn.setBackgroundImage(UIImage(named: "wip"), for: .normal)
                cell.infobtn.setBackgroundImage(UIImage(named: "wip"), for: .selected)
                break
                
            case "2" : cell.desc = "On Hold"
                cell.infobtn.setBackgroundImage(UIImage(named: "hold"), for: .normal)
                break
                
            case "3" : cell.desc = "Waiting for Details"
                cell.infobtn.setBackgroundImage(UIImage(named: "waiting"), for: .normal)
                break
                
            case "4" : cell.desc = "Researching"
                cell.infobtn.setBackgroundImage(UIImage(named: "researching"), for: .normal)
                break
                
            default : break
            
            }
            
            return cell
            
        }else {
         let cell = tableView.dequeueReusableCell(withIdentifier: "historycell") as! RAISECASECELL
            list = sadapter[indexPath.row]
            cell.stext.text = list.id
            cell.sdate.text = list.text
            cell.stype.text = list.type
            
            switch (list.status){
            
            case "5" : cell.desc = "Problem Solved"
                cell.infobtn.setBackgroundImage(UIImage(named: "taskdone"), for: .normal)
                cell.infobtn.setBackgroundImage(UIImage(named: "taskdone"), for: .selected)
                break
                
            case "1000" : cell.desc = "Information Provided"
                cell.infobtn.setBackgroundImage(UIImage(named: "infoneed"), for: .normal)
                break
                
            case "6" : cell.desc = "Cancelled"
                cell.infobtn.setBackgroundImage(UIImage(named: "cancelled"), for: .normal)
                break
                
            case "2000" : cell.desc = "Merged"
                cell.infobtn.setBackgroundImage(UIImage(named: "merged"), for: .normal)
                break
                
            case "1" : cell.desc = "In Progress"
                cell.infobtn.setBackgroundImage(UIImage(named: "wip"), for: .normal)
                break
                
            case "2" : cell.desc = "On Hold"
                cell.infobtn.setBackgroundImage(UIImage(named: "hold"), for: .normal)
                break
                
            case "3" : cell.desc = "Waiting for Details"
                cell.infobtn.setBackgroundImage(UIImage(named: "waiting"), for: .normal)
                break
                
            case "4" : cell.desc = "Researching"
                cell.infobtn.setBackgroundImage(UIImage(named: "researching"), for: .normal)
                break
                
            default : break
            
            }
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list : RAISECASEADAPTER
              
        if (tableView.tag == 1){
    
            list = fadapter[indexPath.row]
            self.setcard(title: list.text!, info: list.info!)
                        
        }else {
            list = sadapter[indexPath.row]
            self.setcard(title: list.text!, info: list.info!)
        }
    }
    
    
    @IBOutlet var firstview: UIView!
    //MARK:- first view objects
    @IBOutlet var addresslbll: UILabel!
    @IBOutlet var numberlbl: UILabel!
    @IBOutlet var namelbl: UILabel!
    @IBOutlet var casetype: UITextField!
    @IBOutlet var opencasetbl: UITableView!
    @IBOutlet var casehistorytbl: UITableView!
    //MARK:- detail view init
    @IBOutlet var mainview: UIView!
    @IBOutlet var titletxt: UITextView!
    @IBOutlet var infotxt: UITextView!
    
    
    //MARK:- initialise variables
    var fadapter = [RAISECASEADAPTER](),sadapter = [RAISECASEADAPTER]()
    var uid: String!
    var apiflag = 0
    var idarr = [String]()
    var typeid = ""
    
    override func viewWillAppear(_ animated: Bool) {
        self.updatecases(today: self.getdate(format: "dd-MMM-yy"))
        self.setnav(title: self.navigationItem.title!)
            //MARK:- init open case table
            inittable(status: "0")
            //MARK:- init case history table
            inittable(status: "1")
            //MARK:- init detail card
            mainview.isHidden = true
        let tapcard = UITapGestureRecognizer(target: self, action: #selector(self.maintapped))
        self.mainview.addGestureRecognizer(tapcard)
        if (AppDelegate.ntwrk > 0)
        {
            self.showIndicator("Syncing...", vc: self)
            self.apiflag = 1
            self.getcrmtoken()
        }else{
            initdata()
        }
    }
    
    override func crmcallback() {
        if (self.apiflag == 1){
            self.getcasetype()
        }else if(self.apiflag == 2){
//            self.getcases(acid: "0a58c523-d095-ea11-a812-000d3a0a8282")
            self.getcasehistory(id: CUSTORDERVC.contid!)
        }else if (self.apiflag == 3){
            self.getopencase(id: CUSTORDERVC.contid!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.uid = self.getdate(format: "dd-MMM-yy hh:mm:ss.SSS")
//        self.navigationItem.rightBarButtonItem = self.getbarbutton()
        
        self.opencasetbl.delegate = self
        self.opencasetbl.dataSource = self
        
        self.casehistorytbl.delegate = self
        self.casehistorytbl.dataSource = self
        
        self.deletetable(tbl: "caseentry")
        
        setdetail()
        
        SwiftEventBus.onMainThread(self, name: "cterr") { (result) in
            self.view.isUserInteractionEnabled = true
            self.hideindicator()
            self.showToast(message: "Server not reachable.")
        }
        SwiftEventBus.onMainThread(self, name: "ctnot") { (result) in
            self.view.isUserInteractionEnabled = true
            self.apiflag = 2
            self.getcrmtoken()
        }
        SwiftEventBus.onMainThread(self, name: "ctgot") { (result) in
            self.view.isUserInteractionEnabled = true
            self.apiflag = 2
            self.getcrmtoken()
            self.initdata()
        }
        SwiftEventBus.onMainThread(self, name: "chnot") { (result) in
            self.view.isUserInteractionEnabled = true
            self.hideindicator()
            self.showmsg(msg: "Unable to get case history")
        }
        SwiftEventBus.onMainThread(self, name: "chgot") { (result) in
            self.view.isUserInteractionEnabled = true
            self.apiflag = 3
            self.getcrmtoken()
        }
        SwiftEventBus.onMainThread(self, name: "opnot") { (result) in
            self.view.isUserInteractionEnabled = true
            self.hideindicator()
            self.showmsg(msg: "Unable to get open cases")
            self.inittable(status: "0")
            self.inittable(status: "1")
        }
        SwiftEventBus.onMainThread(self, name: "opgot") { (result) in
            self.view.isUserInteractionEnabled = true
            self.hideindicator()
            self.inittable(status: "0")
            self.inittable(status: "1")
        }
        
//        type selection here... & validation on next btn
//        casetype.didSelect { (selection, index, id) in
//            self.typeid = self.idarr[index]
//        }
    }
    
//    override func buttonPressed() {
//        if (self.casetype.selectedIndex != nil && self.casetype.text!.count > 0){
////            self.deletetable(tbl: "caseentry")
////            insertcasetable(custid: CUSTORDERVC.custid!,userid : UserDefaults.standard.string(forKey: "userid")! ,caseid : self.uid, type : self.typeid,status : "0",date : self.getdate(format: "yyyy-MM-dd"),contid: CUSTORDERVC.contid!, state: "", post: "0")
////            let nvc = self.storyboard?.instantiateViewController(withIdentifier: "CEVC") as! CASEENTRYVC
////            nvc.uid = self.uid
////            nvc.casetype = self.casetype.text
////            self.navigationController?.pushViewController(nvc, animated: true)
//
//            let nvc = self.storyboard?.instantiateViewController(withIdentifier: "TREEVC") as! TREEVIEW
//            self.navigationController?.pushViewController(nvc, animated: true)
//        }else{
//            self.showToast(message: "Select Case type")
//        }
//    }
    
    func setdetail(){
        var stmt1:OpaquePointer?
        let query = "select custid , name ,ifnull(city,'-') ,ifnull(state,'-') ,ifnull(street,'-') from custsrch where custid = '\(CUSTORDERVC.custid!)'"

        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
        let name = String(cString: sqlite3_column_text(stmt1, 1))
        let state = String(cString: sqlite3_column_text(stmt1, 3))
            let street = String(cString: sqlite3_column_text(stmt1, 4))
            let city = String(cString: sqlite3_column_text(stmt1, 2))
            
            self.namelbl.text = name
            self.addresslbll.text = "\(street), \(city), \(state)"
            self.numberlbl.text = CUSTORDERVC.custid!
        }
    }
    
    func initdata(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.casetapped))
        self.casetype.addGestureRecognizer(tap)
    }

    @objc func casetapped(){
        let nvc = self.storyboard?.instantiateViewController(withIdentifier: "TREEVC") as! TREEVIEW
        self.navigationController?.pushViewController(nvc, animated: true)
    }
    
    func inittable(status: String){
        var stmt1:OpaquePointer?
                if (status == "0"){
                    self.fadapter.removeAll()
                }else{
                    self.sadapter.removeAll()
                }

//        let query = "select * from CaseEntry where custid = '\(CUSTORDERVC.custid!)' and status  = '\(status)'"
        let query = "select a.date,ifnull(b.type,'N/A'),a.title,a.caseid,a.descp,a.state from caseentry a left outer join casetype b on a.type = b.typeid where a.status  = '\(status)'"

                 if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
                     let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                     print("error preparing get: \(errmsg)")
                     return
                 }
                 while(sqlite3_step(stmt1) == SQLITE_ROW){
                    let date = String(cString: sqlite3_column_text(stmt1, 0))
                    let type = String(cString: sqlite3_column_text(stmt1, 1))
                    let title = String(cString: sqlite3_column_text(stmt1, 2))
                    let id = String(cString: sqlite3_column_text(stmt1, 3))
                    let info = String(cString: sqlite3_column_text(stmt1, 4))
                    let state = String(cString: sqlite3_column_text(stmt1, 5 ))
                    
                    let d = self.convertDateFormater(date: date, input: "yyyy-MM-dd", output: "dd-MMM-yy")
                    if (status == "0"){
                        self.fadapter.append(RAISECASEADAPTER(id: id, text: title, date: d, type: type, info: info, status: state))
                    }else{
                        self.sadapter.append(RAISECASEADAPTER(id: id, text: title, date: d, type: type, info: info, status: state))
                    }
                }
        if (status == "0"){
            self.opencasetbl.reloadData()
        }else{
            self.casehistorytbl.reloadData()
        }
    }
    //CaseEntry(custid text,userid text, caseid text, type text, title text, descp text, status text, date text,post text)
    
    func setcard(title: String, info : String){
        self.titletxt.text = title
        self.infotxt.text = info
        self.titletxt.isEditable = false
        self.infotxt.isEditable = false
        self.mainview.isHidden = false
    }
    
    @objc func maintapped(){
        self.mainview.isHidden = true
    }
}
