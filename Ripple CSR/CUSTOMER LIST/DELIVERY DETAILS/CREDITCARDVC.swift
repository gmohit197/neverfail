//
//  CREDITCARDVC.swift
//  Ripple CSR
//
//  Created by hannan parvez on 09/03/20.
//  Copyright © 2020 hannan parvez. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class CREDITCARDVC: BASEACTIVITY,UITextFieldDelegate {
//    let cctdropdown=DropDown()
    
    @IBOutlet var totalamount: SkyFloatingLabelTextField!
    
    @IBOutlet var expiryyear: SkyFloatingLabelTextField!
    @IBOutlet var expirymonth: SkyFloatingLabelTextField!
    @IBOutlet var creditcardnumber: SkyFloatingLabelTextField!
    @IBOutlet var signpad: YPDrawSignatureView!
    @IBOutlet var creditcardtypelabel: UILabel!
//    @IBOutlet var creditcardtype: DropDown!
    override func viewDidLoad() {
        super.viewDidLoad()
        creditcardnumber.inputAccessoryView=DoneToolBar
        expiryyear.inputAccessoryView=DoneToolBar
        expiryyear.delegate=self
        expirymonth.delegate=self
        expirymonth.inputAccessoryView=DoneToolBar
        totalamount.inputAccessoryView=DoneToolBar
//        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow),name:UIResponder.keyboardWillShowNotification, object: nil)
        let borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        signpad.layer.borderColor = borderColor.cgColor;
        signpad.layer.borderWidth = 1.0;
        signpad.layer.cornerRadius = 5.0;
        let tap = UITapGestureRecognizer(target: self, action: #selector(showcctdropdown))
//        self.creditcardtype.addGestureRecognizer(tap)
//        cctdropdown.anchorView = creditcardtype
//        cctdropdown.width=300
        if #available(iOS 11.0, *) {
            let frame = self.view.safeAreaLayoutGuide.layoutFrame
        } else {
            let frame = self.view
        }
        
//        print(cctdropdown.anchorView?.plainView.bounds.width)
//        cctdropdown.bottomOffset = CGPoint(x: 0, y:(cctdropdown.anchorView?.plainView.bounds.height)!)
//        cctdropdown.dataSource = ["VISA","MASTERCARD"]
//        cctdropdown.selectionAction = { [unowned self] (index: Int, item: String) in
//            self.creditcardtypelabel.text=item
//            print("Selected item: \(item) at index: \(index)")
//        }
        // Do any additional setup after loading the view.
    }
    override  func keyboardWillShow(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                   if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= 90
                    
            }
               }
        
    }
      override  func  keyboarddone(){
        if self.parent!.view.frame.origin.y != 0 {
            self.parent!.view.frame.origin.y = 0
        }
        view.endEditing(true)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
           if textField.tag==1{
               if newString != "" && Int(newString)!>12{
                   return false
               }
           }
        if textField.tag==2{
            if newString.count > 4  { //restrict input upto 32 characters
                          return false
                      }
        }
          
           return true
       }
    
    @IBAction func clearsign(_ sender: Any) {
        
        signpad.clear()
    }
    @objc func showcctdropdown(){
//        cctdropdown.show()
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
