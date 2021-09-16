//
//  ADDPRODUCTSCAN.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 29/06/20.
//  Copyright © 2020 hannan parvez. All rights reserved.
//

import UIKit

class ADDPRODUCTSCAN : BASEACTIVITY {

   @IBOutlet weak var scannerView: QRScannerView! {
               didSet {
                   scannerView.delegate = self
               }
           }
        
        
     var qrData: QRData? = nil {
               didSet {
                   if qrData != nil {
                       print("qr data ====> \((qrData?.codeString)!)")
       //                self.showToast(message: "Result - \((qrData?.codeString)!)")
                       self.showToast(message: "Result - \((qrData?.codeString)!)", seconds: 1.5)
                       DispatchQueue.main.asyncAfter(deadline: .now()+1.55) {
                           if !self.scannerView.isRunning {
                               self.scannerView.startScanning()
                           }
                       }
                       
                   }
               }
           }
           
           override func viewWillAppear(_ animated: Bool) {
                  super.viewWillAppear(animated)
               if !scannerView.isRunning {
                      scannerView.startScanning()
               }
               self.navigationController?.setNavigationBarHidden(true, animated: true)
              }
             
           override func viewWillDisappear(_ animated: Bool) {
               super.viewWillDisappear(animated)
               if !scannerView.isRunning {
                   scannerView.stopScanning()
               }
           }

           @IBAction func bacbtn(_ sender: Any) {
               self.navigationController?.setNavigationBarHidden(false, animated: true)
               self.navigationController?.popViewController(animated: true)
           }
           
           override func viewDidLoad() {
               super.viewDidLoad()
               self.navigationController?.setNavigationBarHidden(true, animated: true)
           }
       }


       extension ADDPRODUCTSCAN: QRScannerViewDelegate {
           func qrScanningDidStop() {
       //        let buttonTitle = scannerView.isRunning ? "STOP" : "SCAN"
       //        scanButton.setTitle(buttonTitle, for: .normal)
           }
           
           func qrScanningDidFail() {
               presentAlert(withTitle: "Error", message: "Scanning Failed. Please try again")
           }
           
           func qrScanningSucceededWithCode(_ str: String!) {
               self.qrData = QRData(codeString: str!)
           }
       }
