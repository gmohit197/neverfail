//
//  PRODUCTVC.swift
//  Ripple CSR
//
//  Created by aayush shukla on 22/02/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit

class PRODUCTVC: BASEACTIVITY {

    @IBOutlet var statusview: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
          
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
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
