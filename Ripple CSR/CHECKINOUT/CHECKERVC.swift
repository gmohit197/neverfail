//
//  CHECKERVC.swift
//  Ripple CSR
//
//  Created by aayush shukla on 22/02/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit

class CHECKERVC: BASEACTIVITY {

    @IBOutlet var confirmcheckin: CardView!
    @IBOutlet var confirmcheckout: CardView!
    override func viewDidLoad() {
        super.viewDidLoad()
  let confirmcheckouttap=UITapGestureRecognizer(target: self, action: #selector(self.gotoconfirmcheckout))
  confirmcheckout.addGestureRecognizer(confirmcheckouttap)
        let confirmcheckintap=UITapGestureRecognizer(target: self, action: #selector(self.gotoconfirmcheckin))
         confirmcheckin.addGestureRecognizer(confirmcheckintap)
        // Do any additional setup after loading the view.
    }
    @objc func gotoconfirmcheckin(){
        self.performSegue(withIdentifier: "gotocheckercheckout", sender: self)
    }
    @objc func gotoconfirmcheckout(){
        let alert = UIAlertController(title: "Login", message: "Please Log In to proceed.", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = "Checker Code"
            textField.inputAccessoryView=self.DoneToolBar
        }
        alert.addTextField { (textField) in
            textField.text = "Validate"
            textField.inputAccessoryView=self.DoneToolBar
        }
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField!.text)")
            self.performSegue(withIdentifier: "gotocheckercheckout", sender: self)
            
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { [weak alert] (_) in
            
            
            
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
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
