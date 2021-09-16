//
//  FINALIZEINVOICEVC.swift
//  Ripple CSR
//
//  Created by hannan parvez on 11/03/20.
//  Copyright © 2020 hannan parvez. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import ChameleonFramework
class FINALIZEINVOICEVC: BASEACTIVITY {
    @IBOutlet var purchaseorderno: SkyFloatingLabelTextField!
    @IBOutlet var invoicenumber: SkyFloatingLabelTextField!
    @IBOutlet var signpad: YPDrawSignatureView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let borderColor = HexColor(hexString: "#4E5F6C")
               signpad.layer.borderColor = borderColor.cgColor;
               signpad.layer.borderWidth = 1.0;
               signpad.layer.cornerRadius = 5.0;
        // Do any additional setup after loading the view.
    }
    
    @IBAction func save(_ sender: Any) {
        
        self.showToast(message: "Saved")
                       let duration: Double = 1
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
                           self.performSegue(withIdentifier: "invoicefinalized", sender: self)
                       }
    }
    @IBAction func clearsignpad(_ sender: Any) {
        signpad.clear()
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
