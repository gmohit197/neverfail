//
//  TRANSFERREQVC.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 23/01/21.
//  Copyright © 2021 aayush shukla. All rights reserved.
//

import UIKit
import SQLite3

class TRANSFERREQVC: BASEACTIVITY,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reqadapter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reqcell") as! REQUESTCELL
        
        let list: REQADAPTER
        
        list = reqadapter[indexPath.row]

        cell.trucktransferid.text = list.trucktransferid!
        cell.fromtruck.text = list.fromtruck!
        cell.totruck.text = list.totruck!
        cell.driverid.text = list.driverid!
        cell.status.text = list.status!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let list : REQADAPTER
        list = reqadapter[indexPath.row]
        
        let sb = UIStoryboard.init(name: "LOADING", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "LOADINGVC") as! LOADINGVC
        vc.navigationItem.title = "Stock Transfer"
        TRANSFERREQVC.transferid = list.trucktransferid!
        TRANSFERREQVC.status = list.status!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBOutlet var reqtable: UITableView!
    static var transferid : String?
    static var status : String?
    var reqadapter = [REQADAPTER]()
    
    override func viewWillAppear(_ animated: Bool) {
        self.setnav(title: self.navigationItem.title!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reqtable.delegate = self
        self.reqtable.dataSource = self
        self.setlist()
    }
    
    func setlist(){
        self.reqadapter.removeAll()
        var stmt1:OpaquePointer?
        let query = "select a.trucktransferid,a.fromtruck,a.totruck,b.driverid,case when a.status = '0' then 'Open' when a.status = '1' then 'Accepted' when a.status = '2' then 'Rejected' end as status from TransferDetails a inner join TruckMaster b on a.totruck = b.code"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let trucktransferid = String(cString: sqlite3_column_text(stmt1, 0))
            let fromtruck = String(cString: sqlite3_column_text(stmt1, 1))
            let totruck = String(cString: sqlite3_column_text(stmt1, 2))
            let driver = String(cString: sqlite3_column_text(stmt1, 3))
            let status = String(cString: sqlite3_column_text(stmt1, 4))
            
            self.reqadapter.append(REQADAPTER(trucktransferid: trucktransferid, fromtruck: fromtruck, totruck: totruck, driverid: driver, status: status))
        }
        if (self.reqadapter.count == 0){
            self.showToast(message: "No pending Transfer requests found.")
        }
        self.reqtable.reloadData()
    }
    
}
