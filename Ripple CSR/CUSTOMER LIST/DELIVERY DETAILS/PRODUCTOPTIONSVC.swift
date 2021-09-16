//
//  PRODUCTOPTIONSVC.swift
//  Ripple CSR
//
//  Created by hannan parvez on 23/02/20.
//  Copyright © 2020 hannan parvez. All rights reserved.
//

import UIKit

class PRODUCTOPTIONSVC: UIViewController {

    @IBOutlet var balancecard: CardView!
    @IBOutlet var informationcard: CardView!
    @IBOutlet var historycard: CardView!
    @IBOutlet var equipmentcard: CardView!
    @IBOutlet var notecard: CardView!
    @IBOutlet var changecard: CardView!
    @IBOutlet var addcard: CardView!
    @IBOutlet var watercard: CardView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title=DELIVERYDETAILS.title
        
        let  watercardtap=UITapGestureRecognizer(target: self, action: #selector(gotowater))
        watercard.addGestureRecognizer(watercardtap)
        let  addtap=UITapGestureRecognizer(target: self, action: #selector(gotoadd))
        addcard.addGestureRecognizer(addtap)
        // Do any additional setup after loading the view.
    }
    @objc func gotowater(){
        performSegue(withIdentifier: "gotowater", sender: self)
    }
     @objc func gotoadd(){
            performSegue(withIdentifier: "gotoadd", sender: self)
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
