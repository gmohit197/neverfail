//
//  TBREAKCELL.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 07/09/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit

class TBREAKCELL: UITableViewCell {

    
    @IBOutlet var snolbl: UILabel!
    @IBOutlet var maxtimelbl: UILabel!
    @IBOutlet var breaktime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
