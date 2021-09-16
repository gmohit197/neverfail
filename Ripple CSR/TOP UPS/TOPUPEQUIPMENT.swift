//
//  TOPUPEQUIPMENT.swift
//  Ripple CSR
//
//  Created by aayush shukla on 24/02/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import FloatingSearchTextLabelField
class TOPUPEQUIPMENT: BASEACTIVITY {

    @IBOutlet var serial: FloatingSearchTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        serial.inputAccessoryView=DoneToolBar
        // Do any additional setup after loading the view.
    }
    
    @IBAction func goback(_ sender: Any) {
         dismiss(animated: true, completion: nil)
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
