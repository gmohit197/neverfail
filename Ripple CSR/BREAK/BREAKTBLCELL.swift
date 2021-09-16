//
//  BREAKTBLCELL.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 07/09/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit

class BREAKTBLCELL: UITableViewCell {

    
    @IBOutlet var periodlbl: UILabel!
    @IBOutlet var maxtimelbl: UILabel!
    @IBOutlet var restreqlbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
