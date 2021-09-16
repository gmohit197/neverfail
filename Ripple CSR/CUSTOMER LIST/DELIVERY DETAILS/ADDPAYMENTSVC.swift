//
//  ADDPAYMENTSVC.swift
//  Ripple CSR
//
//  Created by hannan parvez on 09/03/20.
//  Copyright © 2020 hannan parvez. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
class ADDPAYMENTSVC: BASEACTIVITY {

    
    @IBOutlet var totalamount: SkyFloatingLabelTextField!
    @IBOutlet var creditcardview: UIView!
    @IBOutlet var chequeview: UIView!
    let tdropDown = DropDown()
    @IBOutlet var totaldropdownlabel: UILabel!
//    @IBOutlet var totaldropdown: DropDown!
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.creditcardview.alpha = 0
//        self.chequeview.alpha = 0
//        let tap2 = UITapGestureRecognizer(target: self, action: #selector(showtdropdown))
////        self.totaldropdown.addGestureRecognizer(tap2)
////        tdropDown.anchorView = totaldropdown
//        totalamount.inputAccessoryView=DoneToolBar
////        tdropDown.width=300
//        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow),name:UIResponder.keyboardWillShowNotification, object: nil)
//        if #available(iOS 11.0, *) {
//            let frame = self.view.safeAreaLayoutGuide.layoutFrame
//        } else {
//            let frame = self.view
//        }
//
//        print(tdropDown.anchorView?.plainView.bounds.width)
//        tdropDown.bottomOffset = CGPoint(x: 0, y:(tdropDown.anchorView?.plainView.bounds.height)!)
//        tdropDown.dataSource = ["CASH","CHEQUE","CREDIT CARD"]
//        tdropDown.selectionAction = { [unowned self] (index: Int, item: String) in
////            self.totaldropdownlabel.text=item
//                        if item=="CHEQUE"{
//                            self.creditcardview.alpha = 0
//                            self.chequeview.alpha = 1
//                        }else if item=="CREDIT CARD" {
//                            self.creditcardview.alpha = 1
//                            self.chequeview.alpha = 0
//                        }
//                        else{
//                            self.creditcardview.alpha = 0
//                            self.chequeview.alpha = 0
//                            }
//            print("Selected item: \(item) at index: \(index)")
//        }
        // Do any additional setup after loading the view.
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
