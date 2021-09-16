//
//  STATEMENTVC.swift
//  Ripple CSR
//
//  Created by aayush shukla on 23/02/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import MaterialComponents.MDCBottomNavigationBar
class STATEMENTVC: BASEACTIVITY {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.showToast(message: "Under Development")
                let duration: Double = 1

                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
        //            alert.dismiss(animated: true)
                    
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
