//
//  CHECKEREQUIPMENTVC.swift
//  Ripple CSR
//
//  Created by aayush shukla on 22/02/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import SwipeCellKit
import FloatingSearchTextLabelField
import ChameleonFramework
class CHECKEREQUIPMENTVC: BASEACTIVITY,UITableViewDataSource,UITableViewDelegate ,SwipeTableViewCellDelegate{
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
   let cell =  tableView.dequeueReusableCell(withIdentifier: "checkerequipmentcell") as! checkerequipmentcell
    cell.delegate=self
    cell.equipmentdescription.text=dataset[indexPath.row]
    cell.quantity.inputAccessoryView=DoneToolBar
    return cell
    
}
    @IBAction func goback(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var equipmenttype: FloatingSearchTextField!
    @IBOutlet var equipmenttable: UITableView!
    override func viewDidLoad() {
        equipmenttable.delegate=self
        equipmenttable.dataSource=self
        equipmenttype.inputAccessoryView=DoneToolBar
        customizesearchfields(withname: equipmenttype)
        equipmenttype.filterItems([SearchTextFieldItem(title: "Gk")])
        equipmenttype.itemSelectionHandler={  item,itemPosition in
            self.dataset.append(item[itemPosition].title)
            self.equipmenttable.reloadData()
            }
    }
}
