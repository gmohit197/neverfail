//
//  COMPLETEVC.swift
//  Ripple CSR
//
//  Created by hannan parvez on 23/02/20.
//  Copyright © 2020 hannan parvez. All rights reserved.
//

import UIKit
import  ChameleonFramework
class COMPLETEVC: BASEACTIVITY,UITableViewDelegate,UITableViewDataSource{
    var Colors=[FlatBlack(),FlatRed(),FlatBlack(),FlatBlue(),FlatRed(),FlatBlack(),FlatBlue(),FlatBlack()]
    var sequence=["15l Bottle","5l Bottle","3","4","5","6","7","8"]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sequence.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
             let cell=tableView.dequeueReusableCell(withIdentifier: "sequencecell") as! sequencecell
              cell.name.text=sequence[indexPath.row]
              cell.statusbar.backgroundColor=Colors[indexPath.row]
              return cell
    }
    

    @IBOutlet var completedtable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        completedtable.delegate=self
        completedtable.dataSource=self

        // Do any additional setup after loading the view.
    }
    @IBAction func goback(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
