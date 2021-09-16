//
//  INVOICETBLCELL.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 09/07/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import SQLite3

protocol InvoiceProt {
    func checktapped()
}

class INVOICETBLCELL: UITableViewCell {

    @IBOutlet var headerlbl: UILabel!
    @IBOutlet var checkbox: UIButton!
    var invid: String?
    var delegate: InvoiceProt!
    @IBOutlet var desclbl: UILabel!
    @IBAction func checkbtn(_ sender: UIButton) {
        animatebtn()
    }
    
    @objc func animatebtn(){
        print("animation started")
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
            self.checkbox.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        }) { (success) in
            UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
                self.checkbox.isSelected = !self.checkbox.isSelected
                self.checkbox.transform = .identity
                self.updatenow()
            }, completion: nil)
        }
    }
    
    @objc func updatenow(){
        let query = "update Invoice set isselected = '\(checkbox.isSelected)' where invoiceid = '\(invid!)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating in Invoice Table")
            return
        }
        self.delegate.checktapped()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkbox.setImage(UIImage(named:"unselected"), for: .normal)
        checkbox.setImage(UIImage(named:"selected"), for: .selected)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
