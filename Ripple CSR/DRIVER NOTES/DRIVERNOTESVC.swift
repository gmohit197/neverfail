//
//  DRIVERNOTESVC.swift
//  Ripple CSR
//
//  Created by hannan parvez on 21/02/20.
//  Copyright © 2020 hannan parvez. All rights reserved.
//

import UIKit
class DRIVERNOTESVC: BASEACTIVITY {

    @IBOutlet var actionddlabel: UILabel!
//    @IBOutlet var actionsdropdown: DropDown!
//    var actionsdd=DropDown()
    @IBOutlet var descriptionarea: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        descriptionarea.layer.borderColor = borderColor.cgColor;
        descriptionarea.layer.borderWidth = 1.0;
        descriptionarea.layer.cornerRadius = 5.0;
        
        let tapactionsdropdown = UITapGestureRecognizer(target: self, action: #selector(self.showactionsropdown))
//        actionsdropdown.addGestureRecognizer(tapactionsdropdown)
        
        descriptionarea.inputAccessoryView=DoneToolBar
//        actionsdd.anchorView = actionsdropdown
//        actionsdd.width=actionsdropdown.frame.width
//        actionsdd.bottomOffset = CGPoint(x: 10, y:(actionsdd.anchorView?.plainView.bounds.height)!)
//        actionsdd.dataSource=["Equipment Issue","Internal Distribution Issue","Safety Issue","Special Load Required","Stationary Request","Truck Maint Issue","Uniform Request"]
//        actionsdd.selectionAction = {
//            [unowned self] (index: Int, item: String) in
//            self.actionddlabel.text=item
//
//
            print("Selected item: \(item) at index: \(index)")
//        }
            
        // Do any additional setup after loading the view.
    }
    @IBAction func save(_ sender: Any) {
        let alertController = UIAlertController(title: "Alert", message: "Do You Want To Print", preferredStyle: .alert)

        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            self.showToast(message: "Under Development")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alertController.addAction(okAction)
               alertController.addAction(cancelAction)

               // Present the controller
               self.present(alertController, animated: true, completion: nil)

        
    }
    @objc func showactionsropdown(){
        actionsdd.show()
    }

    @IBAction func goback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
