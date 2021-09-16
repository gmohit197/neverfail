//
//  PRESTARTCHECKLISTVC_second.swift
//  Ripple CSR
//
//  Created by Acxiom Consulting on 08/06/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import SQLite3

class PRESTARTCHECKLISTVC_second: BASEACTIVITY,UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presecondadapter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "presecondcell", for: indexPath) as! PreStartCheckList_second
        
        let list: PRESECONDADAPTER
        list = presecondadapter[indexPath.row]
        
        cell.desclbl.text = list.desclabel
        
        tableView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    @IBOutlet var presecondtable: UITableView!
    
    @IBOutlet var userlbl: UILabel!
    @IBOutlet var datelbl: UILabel!
    var presecondadapter = [PRESECONDADAPTER]()
    
    override func viewDidLoad() {
        self.userlbl.text = UserDefaults.standard.string(forKey: "userid")
        datelbl.text = self.getdate(format: "dd/MM/yy")
        self.presecondtable.delegate = self
        self.presecondtable.dataSource = self
        setlist()
        self.navigationItem.rightBarButtonItem = getbarbutton()
    }
    
    override func buttonPressed() {
        self.push(storybId: "PRESTARTCHECKLIST", vcId: "PRE_third", vc: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setbg()
//        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func setlist(){
            
             var stmt1:OpaquePointer?
            
            let query = "select * from PreStartChecklist where toogle = 'false'"
            
            presecondadapter.removeAll()
            
            if sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                print("error preparing get: \(errmsg)")
                return
            }
            while(sqlite3_step(stmt1) == SQLITE_ROW){
                let description = String(cString: sqlite3_column_text(stmt1, 2))
                presecondadapter.append(PRESECONDADAPTER(description: description))
            }
            self.presecondtable.reloadData()
        }
}
