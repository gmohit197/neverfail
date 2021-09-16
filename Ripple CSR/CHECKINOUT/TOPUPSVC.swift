//
//  TOPUPSVC.swift
//  Ripple CSR
//
//  Created by aayush shukla on 23/02/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit

class TOPUPSVC: BASEACTIVITY {

    @IBOutlet var recievestock: CardView!
    @IBOutlet var tranferstock: CardView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let taptransferstock=UITapGestureRecognizer(target: self, action: #selector(gototranferstock))
        tranferstock.addGestureRecognizer(taptransferstock)
        let taptrecievestock=UITapGestureRecognizer(target: self, action: #selector(gotorecievestock))
        recievestock.addGestureRecognizer(taptrecievestock)
        // Do any additional setup after loading the view.
    }
    
    @objc func gototranferstock(){
        
        performSegue(withIdentifier: "gototransferstock", sender: self)
    }
    @objc func gotorecievestock(){
         performSegue(withIdentifier: "gototransferstock", sender: self)
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
