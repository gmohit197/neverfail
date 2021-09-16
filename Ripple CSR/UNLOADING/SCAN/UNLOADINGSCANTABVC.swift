//
//  UNLOADINGSCANTABVC.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 17/06/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit

class UNLOADINGSCANTABVC: BASEACTIVITY, UITabBarDelegate {

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if (item.tag == 0){
            print("full bottle selected")
        }else if (item.tag == 1){
            print("empty bottle selected")
        }else if (item.tag == 2){
            
        }else if (item.tag == 3){
             let storyboard = UIStoryboard(name: "UNLOADING", bundle: nil)
                 let registrationVC = storyboard.instantiateViewController(withIdentifier: "ADDPRODUCTVC") as! SELECTCATEGORY
                 registrationVC.navigationItem.title = self.navigationItem.title
            registrationVC.origin = self.origin
                 self.navigationController?.pushViewController(registrationVC, animated: true)
             
        }
    }
    
    var sindex : IndexPath!
    
    @IBOutlet weak var scannerView: QRScannerView! {
           didSet {
               scannerView.delegate = self
           }
       }
    var origin = ""
    var lotid = ""
    
    @IBOutlet var bottletabbar: UITabBar!
    
    @IBOutlet var actiontabbar: UITabBar!
    
   var qrData: QRData? = nil {
        didSet {
            if qrData != nil {
                let data = "\((qrData?.codeString)!)"
                print("qr data ====> \((qrData?.codeString)!)")
                if (origin == "LA"){
                    self.push(storybId: "LOCATEASSET", vcId: "LANC", vc: self)
                }else if(origin == "BS"){
                    
                    self.insertbatchserial(lotid: self.lotid, batch: "", serial: data, qty: "1", type: "custorder", post: "0")
                    let sb = UIStoryboard(name: "RESQUENCING", bundle: nil)
                    let vc = sb.instantiateViewController(withIdentifier: "CUSTORDERVC") as! CUSTORDERVC
                    vc.setscanresult = true
                    vc.sindex = self.sindex
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }else if(origin == "loading"){
                    self.insertbatchserial(lotid: self.lotid, batch: "", serial: data, qty: "1", type: self.origin, post: "0")
                    AppDelegate.setscanresult = true
                    AppDelegate.sindex = self.sindex
                    
                    self.navigationController?.popViewController(animated: true)
                }else if (origin == "Checkinitems"){
                    self.insertbatchserial(lotid: self.lotid, batch: "", serial: data, qty: "1", type: self.origin, post: "0")
                    AppDelegate.setscanresult = true
                    AppDelegate.sindex = self.sindex
                    self.navigationController?.popViewController(animated: true)
                }else if (origin == "SO"){
                    self.insertbatchserial(lotid: self.lotid, batch: "", serial: data, qty: "1", type: self.origin, post: "0")
                    AppDelegate.setscanresult = true
                    AppDelegate.sindex = self.sindex
                    AppDelegate.lotid = self.lotid
                    
                    self.navigationController?.popViewController(animated: true)
                }else if (origin == "stocktr"){
                    self.insertbatchserial(lotid: self.lotid, batch: "", serial: data, qty: "1", type: self.origin, post: "0")
                    AppDelegate.setscanresult = true
                    AppDelegate.sindex = self.sindex
                    AppDelegate.lotid = self.lotid
                    
                    self.navigationController?.popViewController(animated: true)
                }
                else{
                    self.showToast(message: "Result - \((qrData?.codeString)!)", seconds: 1.5)
                    DispatchQueue.main.asyncAfter(deadline: .now()+1.55) {
                    if !self.scannerView.isRunning {
                        self.scannerView.startScanning()
                    }
                }
            }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
        if (origin == "LA"){
            self.actiontabbar.isHidden = true
            self.bottletabbar.isHidden = true
            self.navigationItem.title = "Locate Asset"
            var tabFrame = self.actiontabbar.frame
            // - 40 is editable , the default value is 49 px, below lowers the tabbar and above increases the tab bar size
            tabFrame.size.height = 0
            tabFrame.origin.y = 0
            self.actiontabbar.frame = tabFrame
           var tabFrame1 = self.bottletabbar.frame
                   
            tabFrame1.size.height = 0
            tabFrame1.origin.y = 0
            self.actiontabbar.frame = tabFrame1
        }else if (origin == "BS" || origin == "SO" || origin == "Checkinitems" || origin == "loading" || origin == "stocktr") {
            self.navigationItem.title = "Serial Scan"
            self.actiontabbar.isHidden = true
            self.hidetabbar(tabbar: self.actiontabbar)
            self.bottletabbar.isHidden = true
            self.hidetabbar(tabbar: self.bottletabbar)
        }
        if !scannerView.isRunning {
               scannerView.startScanning()
        }
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
//
        self.actiontabbar.selectedItem = self.actiontabbar.items![0]
        self.bottletabbar.selectedItem = self.bottletabbar.items![0]
        self.setnav(title: self.navigationItem.title!)
        self.actiontabbar.isHidden = true
        self.hidetabbar(tabbar: self.actiontabbar)
        self.bottletabbar.isHidden = true
        self.hidetabbar(tabbar: self.bottletabbar)
    }
      
    func hidetabbar(tabbar: UITabBar){
        var tabFrame = tabbar.frame
            // - 40 is editable , the default value is 49 px, below lowers the tabbar and above increases the tab bar size
            tabFrame.size.height = 40
            tabFrame.origin.y = self.view.frame.size.height - 40
            tabbar.frame = tabFrame
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !scannerView.isRunning {
            scannerView.stopScanning()
        }
    }

    @IBAction func donebtn(_ sender: Any) {

        if (origin == "LA"){
            self.push(storybId: "LOCATEASSET", vcId: "LANC", vc: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.actiontabbar.delegate = self
        self.bottletabbar.delegate = self
        if (origin != "LA"){
            self.navigationItem.rightBarButtonItem = nil
        }
    }
}


extension UNLOADINGSCANTABVC: QRScannerViewDelegate {
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
