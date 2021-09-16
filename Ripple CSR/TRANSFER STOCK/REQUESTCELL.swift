//
//  REQUESTCELL.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 23/01/21.
//  Copyright © 2021 aayush shukla. All rights reserved.
//

import UIKit

class REQUESTCELL: UITableViewCell {

    @IBOutlet var trucktransferid: UILabel!
    
    @IBOutlet var fromtruck: UILabel!
    
    @IBOutlet var driverid: UILabel!
    @IBOutlet var totruck: UILabel!
    
    @IBOutlet var status: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
