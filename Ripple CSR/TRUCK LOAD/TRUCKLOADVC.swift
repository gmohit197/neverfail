//
//  TRUCKLOADVC.swift
//  Ripple CSR
//
//  Created by Acxiom Consulting on 10/06/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import Alamofire

class TRUCKLOADVC: BASEACTIVITY {

    @IBOutlet var checkincard: CardView!
    @IBOutlet var checkoutcard: CardView!
    var flag : Bool = false
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let checkintap=UITapGestureRecognizer(target: self, action: #selector(gotocheckin))
        checkincard.addGestureRecognizer(checkintap)
        let checkouttap=UITapGestureRecognizer(target: self, action: #selector(gotocheckout))
        checkoutcard.addGestureRecognizer(checkouttap)
    }
    @objc func gotocheckin(){

        let storyboard = UIStoryboard(name: "UNLOADING", bundle: nil)
        let registrationVC = storyboard.instantiateViewController(withIdentifier: "UNLOADPVC") as! UNLOADINGPRODUCTTABVC
        registrationVC.navigationItem.title = "Unload"
        AppDelegate.origin = "Checkinitems"
        AppDelegate.setscanresult = false
        navigationController?.pushViewController(registrationVC, animated: true)

    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.setbg()
        self.setnav(title: self.navigationItem.title!)
    } 
    
    @objc func gotocheckout(){
        if (AppDelegate.ntwrk > 0){
            self.showIndicator("Loading...", vc: self)
            self.gettoken()
            
        }else{
            self.showToast(message: "Internet connection required")
        }
        
    }
    
    override func callback() {
        self.getloaddetails()
    }
    
    override func failcall() {
        self.hideindicator()
        self.showToast(message: "F&O Authentication Error!!!")
    }
    
    //    MARK:- LOAD DETAILS
    public func getloaddetails(){
            
            let url = CONSTANT.BASE_URL + "acxdriverapp/acxdriverappservice/getLoadDetails"
            
            let headers = [
                "Authorization"                :   "Bearer \(self.accessToken)"
            ]
            var parameters: [String: AnyObject] = [:]
            var array: [AnyObject] = []
            var body: [String: [AnyObject]] = [:]

            parameters = [
                "Driver id" : UserDefaults.standard.string(forKey: "userid") as AnyObject
            ]
            array.append(parameters as AnyObject)
            body = [
                "getLoadDetails" : array
            ]
   
            print("body ---->\n \(body)\n")
            Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        // server data
                        print("response.statuscode \(response.response!.statusCode)")
                        print("\n*******************************************************\n")
                        print("\nresponse.result.value \(response.result.value!) \n\n")
                        if  (response.response!.statusCode == 200){ // 200
                            if let json = response.result.value as? [[String:Any]]{
                                self.deletetable(tbl: "Loading")
                                self.deletesbatchtbl(type: "loading")
                                let result = json[0]
                                let ln = result["Load Number"] as! String
                                UserDefaults.standard.setValue(ln, forKey: "loadnum")
                                let rl = result["Remote Location"] as! Int
                                let posted = result["Posted"] as! Int
                                if (rl == 0){
                                    if let sku = result["SKU Details"] as? [[String:Any]]{
                                        
                                        for load in sku {
                                            let id = load["$id"] as! String
                                            let itemname = load["Item Name"] as! String
                                            let itemid = load["Item Id"] as! String
                                            let qty = load["Quantity"] as! Int
                                            let batch = load["Batch Number"] as! String
                                            let serial = load["Serial Number"] as! String
                                            
                                            self.insertload(id: id, itemname: itemname, itemid: itemid, qty: "\(qty)", batch: batch, serial: serial)
                                        }
                                        self.hideindicator()
                                        if (posted == 1){
                                            self.loadposted()
                                        }else{
                                          self.push(storybId: "LOADING", vcId: "LOADINGNC", vc: self)
                                        }
                                    }
                                }else if(rl == 1){
                                    self.hideindicator()
                                    if (posted == 1){
                                        self.loadposted()
                                    }else{
                                        let storyboard = UIStoryboard(name: "UNLOADING", bundle: nil)
                                        let registrationVC = storyboard.instantiateViewController(withIdentifier: "UNLOADPVC") as! UNLOADINGPRODUCTTABVC
                                        registrationVC.navigationItem.title = "Load"
                                        AppDelegate.origin = "loading"
                                        AppDelegate.setscanresult = false
                                        self.navigationController?.pushViewController(registrationVC, animated: true)
                                    }
                                }
                            }
                        }else{
                            if (response.response?.statusCode == 500){
                                if let json = response.result.value as? [String:Any]{
                                    if let msg = json["Message"] as? String {
                                        if (msg.contains("An exception occured when invoking the operation -")){
                                            self.hideindicator()
                                            let err = msg.replacingOccurrences(of: "An exception occured when invoking the operation - ", with: "")
                                            self.showToast(message: err)
                                        }else{
                                            self.hideindicator()
                                            self.showToast(message: "Unable to Load details due to API error")
                                        }
                                    }
                                    else{
                                        self.hideindicator()
                                        self.showToast(message: "Unable to Load details due to API error")
                                    }
                                }else{
                                        self.hideindicator()
                                        self.showToast(message: "Unable to Load details due to API error")
                                    }
                            }else{
                                self.hideindicator()
                                self.showToast(message: "Unable to Load details due to API error")
                            }
                        
                        }
                        
                    case .failure(let error):
                        self.hideindicator()
                        self.showToast(message: "Unable to Load details due to Server error")
                        print("error \(error)")
                    }
                }
        }
    
    func loadposted(){
        self.showToast(message: "Load is already posted.")
    }
    
    
    @IBAction func donebtn(_ sender: Any) {
        UserDefaults.standard.set(self.getdate(format: "yyyy-MM-dd"), forKey: "trkdate")
        let rootVC = UIStoryboard(name: "RESQUENCING", bundle: nil).instantiateInitialViewController()
        UIApplication.shared.windows.first?.rootViewController = rootVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
}
