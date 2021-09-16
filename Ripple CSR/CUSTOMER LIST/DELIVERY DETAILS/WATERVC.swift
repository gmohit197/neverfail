//
//  FREEVC.swift
//  Ripple CSR
//
//  Created by hannan parvez on 23/02/20.
//  Copyright © 2020 hannan parvez. All rights reserved.
//

import UIKit

class WATERVC: BASEACTIVITY,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "watercell")
        as! watercell
        cell.filledbottles.inputAccessoryView=DoneToolBar
        cell.emptybottles.inputAccessoryView=DoneToolBar
        return cell
    }
    

    @IBOutlet var freetable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        freetable.delegate=self
        freetable.dataSource=self
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
