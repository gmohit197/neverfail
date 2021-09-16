//
//  EQUIPMENTSVC.swift
//  Ripple CSR
//
//  Created by aayush shukla on 22/02/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import SwipeCellKit
import ChameleonFramework
import SkyFloatingLabelTextField
class EQUIPMENTSVC: BASEACTIVITY,UITableViewDataSource,UITableViewDelegate ,SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .default, title: "Delete") { action, indexPath in
                       // handle action by updating model with deletion
                    self.dataset.remove(at: indexPath.row)
                    self.showToast(message: "Deleted successfully")
                    self.equipmenttable.reloadData()
                   }
      deleteAction.backgroundColor = HexColor(hexString:"#ffffff")
          deleteAction.textColor = FlatRed()
                     deleteAction.image=UIImage(named: "trash-order")
           deleteAction.font=UIFont(name: "Gill Sans Bold", size: 15.0)
                     return [deleteAction]
       
    }
    
    
    var dataset=[String]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataset.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "equipmentcell") as! equipmentcell
        cell.name.text=dataset[indexPath.row]
        cell.delegate=self
        return cell
    }
    

    @IBOutlet var equipmenttable: UITableView!
    @IBOutlet var equipment: SkyFloatingLabelTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        equipment.inputAccessoryView=DoneToolBar
        equipmenttable.delegate=self
        equipmenttable.dataSource=self
        // Do any additional setup after loading the view.
    }
    

    @IBAction func goback(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override  func keyboarddone(){
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
        if equipment.text != ""{
             self.dataset.append(equipment.text!)
         equipmenttable.reloadData()
        }
       
        
        view.endEditing(true)
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
