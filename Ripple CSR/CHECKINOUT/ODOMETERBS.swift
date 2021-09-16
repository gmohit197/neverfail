//
//  ODOMETERBS.swift
//  Ripple CSR
//
//  Created by aayush shukla on 22/02/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import FloatingSearchTextLabelField
class ODOMETERBS: BASEACTIVITY {

    @IBOutlet var reading: SkyFloatingLabelTextField!
    @IBOutlet var truckrego: FloatingSearchTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        reading.inputAccessoryView=DoneToolBar
        truckrego.inputAccessoryView=DoneToolBar
        truckrego.filterItems([SearchTextFieldItem(title: "TAJKS15526"),SearchTextFieldItem(title: "TDDDKS15526"),SearchTextFieldItem(title: "JDOD122"),SearchTextFieldItem(title: "PISJAA123")])
        customizesearchfields(withname: truckrego)
        // Do any additional setup aftedor loading the view.
    }
    
    @IBAction func close(_ sender: Any) {
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
