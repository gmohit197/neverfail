//
//  sequencecell.swift
//  Ripple CSR
//
//  Created by aayush shukla on 21/02/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit

protocol EditClicked{
    func Editaction(custid: String,custname: String,custadd: String)
}

class sequencecell: UITableViewCell {

    @IBOutlet var statusbar: UIView!
    @IBOutlet var stateadd: UILabel!
    @IBOutlet var streetadd: UILabel!
    @IBOutlet var name: UILabel!
    var custid: String?
    var custname: String?
    var custadd: String?
    @IBOutlet var editbtn: UIButton!
    var delegate: EditClicked!
    
    @IBOutlet var cityadd: UILabel!
    
    @IBAction func edit(_ sender: Any) {
        print("custname =====> \(custid!)")
        self.delegate.Editaction(custid: custid!, custname: custname!, custadd: custadd!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
