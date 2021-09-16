//
//  COMPLIANCESECONDVC.swift
//  Ripple CSR
//
//  Created by Acxiom Consulting on 11/06/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import SQLite3

class COMPLIANCESECONDVC: BASEACTIVITY ,UITableViewDelegate,UITableViewDataSource {

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return comsecondadapter.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "comseocondcell", for: indexPath) as! COMPLIANCEsecond_cell
    
    let list: PRESECONDADAPTER
    list = comsecondadapter[indexPath.row]
    
    cell.desclbl.text = list.desclabel

    tableView.backgroundColor = UIColor.clear
    cell.backgroundColor = UIColor.clear
    
    return cell
}
    override func viewWillAppear(_ animated: Bool) {
        self.setbg()
    }
    
    
    @IBOutlet var datelbl: UILabel!
    
    @IBOutlet var userlbl: UILabel!
    @IBOutlet var secondtable: UITableView!
    var comsecondadapter = [PRESECONDADAPTER]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = getbarbutton()
        self.userlbl.text = UserDefaults.standard.string(forKey: "userid")
        self.datelbl.text = self.getdate(format: "dd/MM/yy")
        self.secondtable.delegate = self
        self.secondtable.dataSource = self
        setlist()
    }
    
    func setlist(){
        
         var stmt1:OpaquePointer?
        
        let query = "select * from Compliance where toogle = 'false'"
        
        comsecondadapter.removeAll()
        
        if sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let description = String(cString: sqlite3_column_text(stmt1, 2))
            comsecondadapter.append(PRESECONDADAPTER(description: description))
        }
        self.secondtable.reloadData()
    }
    
    override func buttonPressed() {
        self.push(storybId: "COMPLIANCE", vcId: "COMPLIANCEthirdNC", vc: self)
    }
}
