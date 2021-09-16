//
//  DELIVERYVC.swift
//  Ripple CSR
//
//  Created by hannan parvez on 23/02/20.
//  Copyright © 2020 hannan parvez. All rights reserved.
//

import UIKit
import ChameleonFramework
class DELIVERYVC:BASEACTIVITY,UITableViewDelegate,UITableViewDataSource {
    static var deliveryname=""
    var Colors=[FlatBlack(),FlatRed(),FlatBlack(),FlatBlue(),FlatRed(),FlatBlack(),FlatBlue(),FlatBlack()]
       var sequence=["15l Bottle","5l Bottle","3","4","5","6","7","8"]
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 8
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell=tableView.dequeueReusableCell(withIdentifier: "sequencecell") as! sequencecell
           cell.name.text=sequence[indexPath.row]
           cell.statusbar.backgroundColor=Colors[indexPath.row]
           return cell
       }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DELIVERYVC.deliveryname=sequence[indexPath.row]
        performSegue(withIdentifier: "gotodeliverydetails", sender: self)
    }
   
       
       @IBOutlet var customerlist: UITableView!
       override func viewDidLoad() {
           super.viewDidLoad()
           customerlist.dataSource=self
           customerlist.delegate=self
    
           // Do any additional setup after loading the view.
       }
       

       @IBAction func Done(_ sender: Any) {
           
           let alertController = UIAlertController(title: "Alert", message: "Do You Want To Save The Changes", preferredStyle: .alert)

           // Create the actions
           let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
               UIAlertAction in
               NSLog("OK Pressed")
               self.showToast(message: "Changes Saved")
           }
           let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive) {
               UIAlertAction in
               NSLog("Cancel Pressed")
           }

           // Add the actions
           alertController.addAction(okAction)
           alertController.addAction(cancelAction)

           // Present the controller
           self.present(alertController, animated: true, completion: nil)
       }
      

        @IBAction func back(_ sender: Any) {
            // Code to push/present new view controller
             let storyboard = UIStoryboard(name: "HOME", bundle: nil)

             //Get the VC you want to push onto the stack
             //You can use storyboard.instantiateViewController(withIdentifier: "yourStoryboardId")
             guard let vc = storyboard.instantiateInitialViewController() else { return }

             //Get the current app delegate
             guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return }

             //Set the current root controller and add the animation with a
             //UIView transition
              UIApplication.shared.windows.first?.rootViewController = vc
              UIApplication.shared.windows.first?.makeKeyAndVisible()

             UIView.transition(with: UIApplication.shared.windows.first!,
                           duration: 1.0,
                            options: .transitionCrossDissolve,
                         animations: {
                             UIApplication.shared.windows.first?.rootViewController = vc
             },
                         completion: nil)
        
       
       /*
          // MARK: - Navigation
        // In a storyboard-based application, you will often want to do a little preparation before navigation
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           // Get the new view controller using segue.destination.
           // Pass the selected object to the new view controller.
       }
       */
}
}

