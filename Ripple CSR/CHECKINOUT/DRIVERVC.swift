//
//  DRIVERVC.swift
//  Ripple CSR
//
//  Created by aayush shukla on 21/02/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialBottomSheet
import MaterialComponents.MaterialBottomSheet_ShapeThemer
class DRIVERVC: BASEACTIVITY {

    @IBOutlet var checkin: CardView!
    @IBOutlet var checkout: CardView!
    @IBOutlet var odometer: CardView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let odometertap=UITapGestureRecognizer(target: self, action: #selector(self.gotoodometer))
        odometer.addGestureRecognizer(odometertap)
        let checkouttap=UITapGestureRecognizer(target: self, action: #selector(self.gotocheckout))
        checkout.addGestureRecognizer(checkouttap)
        let checkintap=UITapGestureRecognizer(target: self, action: #selector(self.gotocheckin))
        checkin.addGestureRecognizer(checkintap)
        
        
        // Do any additional setup after loading the view.
    }
    @objc func gotocheckout(){
       performSegue(withIdentifier: "checkout", sender: self)
    }
     @objc func gotocheckin(){
           performSegue(withIdentifier: "checkout", sender: self)
        }
    @objc func gotoodometer(){
        let graphDetailViewController = UIStoryboard(name: "CHECKINOUT", bundle: nil).instantiateViewController(withIdentifier: "odometerbottomsheet") as! ODOMETERBS
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: graphDetailViewController)
        bottomSheet.preferredContentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height/1.5)
        bottomSheet.dismissOnDraggingDownSheet = true
        let shapeScheme = MDCShapeScheme()
        
        let largeShapeCategory = MDCShapeCategory()
        let rounded10PercentCorner = MDCCornerTreatment.corner(withRadius: 0.1,
                                                               valueType: .percentage)
        largeShapeCategory?.topLeftCorner = rounded10PercentCorner
        largeShapeCategory?.topRightCorner = rounded10PercentCorner
        shapeScheme.largeComponentShape = largeShapeCategory!
        // Step 3: Apply the shape scheme to your component
        MDCBottomSheetControllerShapeThemer.applyShapeScheme(shapeScheme, to: bottomSheet)
        bottomSheet.trackingScrollView?.alwaysBounceVertical=true
        present(bottomSheet, animated: true, completion: nil)
    }
  
     @IBAction func goback(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
//        let storyboard = UIStoryboard(name: "HOME", bundle: nil)
//        let registrationVC = storyboard.instantiateViewController(withIdentifier: "HOMENC") as! UINavigationController
//        self.navigationController?.pushViewController(registrationVC.topViewController!, animated: true)
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
