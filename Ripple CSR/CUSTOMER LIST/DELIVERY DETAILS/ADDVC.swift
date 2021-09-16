//
//  ADDVC.swift
//  Ripple CSR
//
//  Created by hannan parvez on 26/02/20.
//  Copyright © 2020 hannan parvez. All rights reserved.
//

import UIKit
import SwipeCellKit
import ChameleonFramework
import FloatingSearchTextLabelField
class ADDVC: BASEACTIVITY,UITableViewDelegate,UITableViewDataSource,quantiychangedelegate,SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
         guard orientation == .right else { return nil }
                              let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                                  // handle action by updating model with deletion
                                 print("delete")
                                  
                                self.dataset.remove(at: indexPath.row)
                                self.table.reloadData()
                                self.setsubmit()
                                  
                              }
      deleteAction.backgroundColor = HexColor(hexString:"#ffffff")
      deleteAction.textColor = FlatRed()
                 deleteAction.image=UIImage(named: "trash-order")
       deleteAction.font=UIFont(name: "Gill Sans Bold", size: 15.0)
                 return [deleteAction]
    }
    
    
    func didedittextfield(_ tag: Int) {
        let passedCell =  table.cellForRow(at: IndexPath(row: tag, section: 0))! as! addcell
        if let qty = Int(passedCell.quantity.text!)
        {
            if let price = Int(dataset[tag].itemprice!){
                dataset[tag].total = String(price * qty)
                dataset[tag].qty = String(qty)
                

            }

        }
        
    }
    
    func setsubmit(){
        var qty=0
        var total=0
        for item in dataset{
            qty = qty + Int(item.qty!)!
            total = total + Int(item.total!)!
            
        }
        totalquantity.text=String(qty)
        totalprice.text="$"+String(total)
        
    }
    var dataset=[additem]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataset.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "addcell") as! addcell
        cell.quantitydelegate=self
        cell.delegate=self
        cell.quantity.tag=indexPath.row
        cell.name.text=dataset[indexPath.row].itemname!
        cell.price.text="$"+dataset[indexPath.row].total!
        cell.quantity.text=dataset[indexPath.row].qty
        cell.quantity.inputAccessoryView=DoneToolBar
        
        
        return cell
        
    }
    
override func keyboarddone(){
            if self.view.frame.origin.y != 0 {
        self.view.frame.origin.y = 0
                }
            view.endEditing(true)
            table.reloadData()
    setsubmit()
}
    @IBOutlet var submitview: UIView!
    @IBOutlet var totalprice: UILabel!
    @IBOutlet var totalquantity: UILabel!
    @IBOutlet var table: UITableView!
    @IBOutlet var category: FloatingSearchTextField!
    @IBOutlet var transactiontype: FloatingSearchTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapsubmitview=UITapGestureRecognizer(target: self, action: #selector(summitproduct))
        submitview.addGestureRecognizer(tapsubmitview)
        table.delegate=self
        table.dataSource=self
        transactiontype.filterItems([SearchTextFieldItem(title: "Sales"),SearchTextFieldItem(title: "Free offer"),SearchTextFieldItem(title: "Return for Credit")])
        category.filterItems([SearchTextFieldItem(title: "Bulk Water"),SearchTextFieldItem(title: "Cups"),SearchTextFieldItem(title: "Retail"),SearchTextFieldItem(title: "Promotional"),SearchTextFieldItem(title: "Coffee"),SearchTextFieldItem(title: "Filters"),SearchTextFieldItem(title: "Truck Racks"),SearchTextFieldItem(title: "Specialty Code")])
        customizesearchfields(withname: transactiontype)
        customizesearchfields(withname: category)
        category.itemSelectionHandler={ item,itemPosition in
            self.dataset.append(additem(itemprice: "200", itemname: "600ml Crt", qty: "1", total: "200"))
            self.table.reloadData()
           
            
        }
            
    }
    @objc func summitproduct(){
        self.showToast(message: "Added Sucessfully")
         let duration: Double = 1

                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
        //            alert.dismiss(animated: true)
                    self.dismiss(animated: true, completion: nil)
                }
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
