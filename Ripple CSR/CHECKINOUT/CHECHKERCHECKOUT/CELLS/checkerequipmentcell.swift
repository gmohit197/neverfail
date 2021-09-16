//
//  checkerequipmentcell.swift
//  Ripple CSR
//
//  Created by aayush shukla on 22/02/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import SwipeCellKit
class checkerequipmentcell: SwipeTableViewCell {

    @IBOutlet var equipmentdescription: UILabel!
    @IBOutlet var quantity: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
