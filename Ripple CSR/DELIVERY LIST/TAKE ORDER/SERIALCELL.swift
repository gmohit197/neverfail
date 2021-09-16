//
//  SERIALCELL.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 07/01/21.
//  Copyright © 2021 aayush shukla. All rights reserved.
//

import UIKit

class SERIALCELL: UITableViewCell {

    @IBOutlet var seriallbl: UILabel!
    
    @IBOutlet var sqtylbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
