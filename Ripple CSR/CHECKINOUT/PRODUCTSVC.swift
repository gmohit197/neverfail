//
//  PRODUCTSVC.swift
//  Ripple CSR
//
//  Created by aayush shukla on 22/02/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import SwipeCellKit
import ChameleonFramework
import FloatingSearchTextLabelField
class PRODUCTSVC: BASEACTIVITY,UITableViewDataSource,UITableViewDelegate ,SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
         guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .default, title: "Delete") { action, indexPath in
                       // handle action by updating model with deletion
                    self.dataset.remove(at: indexPath.row)
                    self.showToast(message: "Deleted successfully")
                self.setsubmitcard()
                    self.producttable.reloadData()
                   }
 deleteAction.backgroundColor = HexColor(hexString:"#ffffff")
  deleteAction.textColor = FlatRed()
             deleteAction.image=UIImage(named: "trash-order")
   deleteAction.font=UIFont(name: "Gill Sans Bold", size: 15.0)
             return [deleteAction]
               
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return  dataset.count
    }
    func setsubmitcard(){
        self.totallines.text=String(dataset.count)
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell =  tableView.dequeueReusableCell(withIdentifier: "productcell") as! productcell
        cell.delegate=self
        cell.qty.inputAccessoryView=DoneToolBar
        cell.productdesc.text=dataset[indexPath.row]
        return cell
        
    }
    var dataset=[String]()
//    var dataset=["Full 15l botl","Full 14l botl",,"Full 13l botl","Full 1l botl","Full 4l botl","l",""]
    @IBOutlet var totallines: UILabel!
    @IBOutlet var totalquantity: UILabel!
    @IBOutlet var producttable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        producttable.dataSource=self
        producttable.delegate=self
        category.filterItems([SearchTextFieldItem(title: "Bulk Water"),SearchTextFieldItem(title:"Bulk Wine"),SearchTextFieldItem(title: "Bulk Soft Drinks") ])
        product.filterItems([SearchTextFieldItem(title: "Full 15l botl"),SearchTextFieldItem(title:"Full 14l botl"),SearchTextFieldItem(title: "Half 15l botl"),SearchTextFieldItem(title:"Half botl") ,SearchTextFieldItem(title:"Super 15l bot") ,SearchTextFieldItem(title:"Full 1l botl") ])
        status.filterItems([SearchTextFieldItem(title: "Stock Item"),SearchTextFieldItem(title:"Oot of Stock item")])
        customizesearchfields(withname: product)
        customizesearchfields(withname: category)
        customizesearchfields(withname: status)
//
//        category.startSuggestingImmediately=true
//        product.startSuggestingImmediately=true
//        status.startSuggestingImmediately=true
       product.itemSelectionHandler={  item,itemPosition in
        self.dataset.append(item[itemPosition].title)
        self.setsubmitcard()
        self.producttable.reloadData()
        }
        
        
        // Do any additional setup after loading the view.
    }
    @IBOutlet var category: FloatingSearchTextField!
    
    @IBOutlet var product: FloatingSearchTextField!
    @IBOutlet var status: FloatingSearchTextField!
    
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
