//
//  CHECKERCONFIRMVC.swift
//  Ripple CSR
//
//  Created by aayush shukla on 22/02/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit

class CHECKERCONFIRMVC: BASEACTIVITY {

    @IBOutlet var signpad: YPDrawSignatureView!
    override func viewDidLoad() {
        super.viewDidLoad()
       let borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
       signpad.layer.borderColor = borderColor.cgColor;
       signpad.layer.borderWidth = 1.0;
       signpad.layer.cornerRadius = 5.0;
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.showToast(message: "Sign on the area above.")
    }
    
    @IBAction func goback(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clear(_ sender: Any) {
        signpad.clear()
    }
    @IBAction func confirm(_ sender: Any) {
        self.showToast(message: "Confirmed")
        let duration: Double = 1

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
//            alert.dismiss(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
        
        
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
