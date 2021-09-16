//
//  MAINCELL.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 08/01/21.
//  Copyright © 2021 aayush shukla. All rights reserved.
//

import UIKit

class MAINCELL: UITableViewCell {

    @IBOutlet var cardview: CardView!
    @IBOutlet var label: UILabel!
    @IBOutlet var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
