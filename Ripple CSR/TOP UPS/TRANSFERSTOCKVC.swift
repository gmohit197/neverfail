//
//  TRANSFERSTOCKVC.swift
//  Ripple CSR
//
//  Created by aayush shukla on 23/02/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit

class TRANSFERSTOCKVC: UIViewController {

    @IBOutlet var goback: UIBarButtonItem!
    @IBOutlet var gotoback: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

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
