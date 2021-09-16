//
//  DELIVERYDETAILS.swift
//  Ripple CSR
//
//  Created by hannan parvez on 23/02/20.
//  Copyright © 2020 hannan parvez. All rights reserved.
//

import UIKit
import SwipeCellKit
import ChameleonFramework
import BTNavigationDropdownMenu
class DELIVERYDETAILS: BASEACTIVITY,UITableViewDelegate,UITableViewDataSource,SwipeTableViewCellDelegate {
    static var title=""
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .default, title: "Delete") { action, indexPath in
                       // handle action by updating model with deletion
            self.showToast(message: "Under Development")
                   }
        deleteAction.backgroundColor = HexColor(hexString:"#ffffff")
        deleteAction.textColor = FlatRed()
                   deleteAction.image=UIImage(named: "trash-order")
         deleteAction.font=UIFont(name: "Gill Sans Bold", size: 15.0)
                   return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "cell") as!
        productdetailscell
        cell.qty.inputAccessoryView=DoneToolBar
        cell.delegate=self
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DELIVERYDETAILS.title="Full 15 L Botl"
    }
    
    
let items = ["Water", "Add", "Equipment", "Note", "History","Info","Balance"]
    @IBOutlet var productstable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.navigationItem.title=DELIVERYVC.deliveryname
        productstable.delegate=self
       
        payment.inputAccessoryView=DoneToolBar
        overdue.inputAccessoryView=DoneToolBar
        total.inputAccessoryView=DoneToolBar
        gst.inputAccessoryView=DoneToolBar
        invtotal.inputAccessoryView=DoneToolBar
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        productstable.dataSource=self
        // Do any additional setup after loading the view.
    }
    override  func keyboardWillShow(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                   if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= 10
                    
            }
               }
        
    }
    override func viewWillAppear(_ animated: Bool) {
          let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: BTTitle.title("Options"), items: items)
                     self.navigationItem.titleView = menuView
              menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
                         if indexPath==0{
                             self!.performSegue(withIdentifier: "gotowater", sender: self)
                         }
                else if indexPath==1{
                    self!.performSegue(withIdentifier: "gotoadd", sender: self)
                }
                                 
                     }
        menuView.cellSelectionColor=HexColor(hexString: "#ffffff")
        menuView.cellBackgroundColor=HexColor(hexString: "#4E5F6C")
    }
    @IBOutlet var overdue: UITextField!
    @IBOutlet var payment: UITextField!
    @IBOutlet var total: UITextField!
    @IBOutlet var gst: UITextField!
    @IBOutlet var invtotal: UITextField!
    @IBAction func goback(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func add(_ sender: Any) {
        
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
