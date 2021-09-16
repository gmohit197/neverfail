//
//  SIDEMENUVC.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 13/07/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit

class SIDEMENUVC: BASEACTIVITY {

    
    @IBOutlet var newcust_stk: UIStackView!
    @IBOutlet var custreq_stk: UIStackView!
    @IBOutlet var newlead_stk: UIStackView!
    @IBOutlet var loadunload_stk: UIStackView!
    @IBOutlet var transfer_stk: UIStackView!
    @IBOutlet var truck_stk: UIStackView!
    @IBOutlet var locate_stk: UIStackView!
    @IBOutlet var breaks_stk: UIStackView!
    @IBOutlet var endday_stk: UIStackView!
    @IBOutlet var logout_stk: UIStackView!
    @IBOutlet var request_stk: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapnewcust = UITapGestureRecognizer(target: self, action: #selector(newcusttapped))
        newcust_stk.addGestureRecognizer(tapnewcust)
        
        let tapnewlead = UITapGestureRecognizer(target: self, action: #selector(newleadtapped))
        newlead_stk.addGestureRecognizer(tapnewlead)
        
        let taploadun = UITapGestureRecognizer(target: self, action: #selector(loadunrtappeed))
        loadunload_stk.addGestureRecognizer(taploadun)
        
        let taplogout = UITapGestureRecognizer(target: self, action: #selector(logouttappeed))
        logout_stk.addGestureRecognizer(taplogout)
        
        let tapcustreq_stk = UITapGestureRecognizer(target: self, action: #selector(custreq_stktappeed))
        custreq_stk.addGestureRecognizer(tapcustreq_stk)
        
        let tapstock_tr = UITapGestureRecognizer(target: self, action: #selector(stocktr_tappeed))
        transfer_stk.addGestureRecognizer(tapstock_tr)
        
        let taptruck_stock = UITapGestureRecognizer(target: self, action: #selector(truckstock_tappeed))
        truck_stk.addGestureRecognizer(taptruck_stock)
        
//        let locatestk_tap = UITapGestureRecognizer(target: self, action: #selector(locatestk_tapped))
//        locate_stk.addGestureRecognizer(locatestk_tap)
        locate_stk.isHidden = true
        
        let break_tap = UITapGestureRecognizer(target: self, action: #selector(breaktapped))
        breaks_stk.addGestureRecognizer(break_tap)
        
        let end_tap = UITapGestureRecognizer(target: self, action: #selector(endtapped))
        endday_stk.addGestureRecognizer(end_tap)
        
        let reqstk_tap = UITapGestureRecognizer(target: self, action: #selector(reqstktapped))
        request_stk.addGestureRecognizer(reqstk_tap)
        
    }

    @objc func locatestk_tapped(){
        let storyboard = UIStoryboard(name: "UNLOADING", bundle: nil)
        let nvc = storyboard.instantiateViewController(withIdentifier: "UNLOADSCANVC") as! UNLOADINGSCANTABVC
        nvc.origin = "LA"
        self.revealViewController()?.pushViewController(nvc, animated: true)
//       self.pushtovc(storyID: "UNLOADING", vcID: "UNLOADSCANVC")
    }
    
    @objc func newcusttapped(){
       self.pushtovc(storyID: "NEWCUSTOMER", vcID: "NCMAINVC")
    }
    
    @objc func reqstktapped(){
        self.pushtovc(storyID: "TRANSFERSTOCK", vcID: "TRREQVC")
    }
    
    @objc func endtapped(){
       self.pushtovc(storyID: "DAYEND", vcID: "DAYVC")
    }

    @objc func breaktapped(){
       self.pushtovc(storyID: "BREAK", vcID: "BVC")
    }
    
    @objc func newleadtapped(){
        self.pushtovc(storyID: "NEWLEAD", vcID: "NEWLVC")
    }
    
    @objc func loadunrtappeed(){
        self.pushtovc(storyID: "TRUCKLOAD", vcID: "TRUCKVC")
    }
    
    @objc func custreq_stktappeed(){
        self.pushtovc(storyID: "CUSTREQ", vcID: "SELECTCUSTVC")
    }
    
    @objc func stocktr_tappeed(){
        AppDelegate.setscanresult = false
        self.pushtovc(storyID: "TRANSFERSTOCK", vcID: "STOCKVC")
    }
    
    @objc func truckstock_tappeed(){
        self.pushtovc(storyID: "TRUCKSTOCK", vcID: "TRUCKVC")
    }
    
//    MARK:- Alert controller for logout
    @objc func logouttappeed(){
        
        let alert = UIAlertController(title: "Logout", message: "Are you sure to Logout?", preferredStyle: .alert)
        
        let okaction = UIAlertAction(title: "Yes", style: .default) { _ in
            
            self.logout()
            alert.dismiss(animated: true, completion: nil)
        }
        
        let noaction = UIAlertAction(title: "No", style: .destructive, handler: nil)
        alert.addAction(okaction)
        alert.addAction(noaction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func pushtovc(storyID: String,vcID: String){
        let storyboard = UIStoryboard(name: storyID, bundle: nil)
        let nvc = storyboard.instantiateViewController(withIdentifier: vcID)
        self.revealViewController()?.pushViewController(nvc, animated: true)
    }
    
    
   
 
}
