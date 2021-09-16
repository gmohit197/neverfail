//
//  HOMEVC.swift
//  Ripple CSR
//
//  Created by hannan parvez on 21/02/20.
//  Copyright © 2020 hannan parvez. All rights reserved.
//

import UIKit

class HOMEVC: BASEACTIVITY {

    @IBOutlet var synchronisation: CardView!
    @IBOutlet var resquencing: CardView!
    @IBOutlet var drivernotes: CardView!
    @IBOutlet var checkinout: CardView!
    @IBOutlet var truckinventory: CardView!
    @IBOutlet var customerlist: CardView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let resequencetap=UITapGestureRecognizer(target: self, action: #selector(gotoresquencing))
        resquencing.addGestureRecognizer(resequencetap)
        let drivernotestap=UITapGestureRecognizer(target: self, action: #selector(gotodrivernotes))
               drivernotes.addGestureRecognizer(drivernotestap)
        let checkinouttap=UITapGestureRecognizer(target: self, action: #selector(gotocheckinout))
        checkinout.addGestureRecognizer(checkinouttap)
        let synchronisationtap=UITapGestureRecognizer(target: self, action: #selector(gotosynchronisation))
        synchronisation.addGestureRecognizer(synchronisationtap)
        let customerlisttap=UITapGestureRecognizer(target: self, action: #selector(gotocustomerlist))
               customerlist.addGestureRecognizer(customerlisttap)
        // Do any additional setup after loading the view.
    }
    @objc func gotoresquencing(){
        self.push(storybId: "RESQUENCING", vcId: "RESQUENCINGNC", vc: self)
    }
    @objc func gotodrivernotes(){
        self.push(storybId: "DRIVERNOTES", vcId: "DRIVERNOTESNC", vc: self)
    }
    @objc func gotocheckinout(){
//    self.push(storybId: "CHECKINOUT", vcId: "CHECKINOUTNC", vc: self)
        performSegue(withIdentifier: "chechkinout", sender: self)
    }
    @objc func gotosynchronisation(){
    //    self.push(storybId: "CHECKINOUT", vcId: "CHECKINOUTNC", vc: self)
            performSegue(withIdentifier: "gotosynchronisation", sender: self)
        }
    
    @objc func gotocustomerlist(){
        performSegue(withIdentifier: "gotocustomerlist", sender: self)
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
