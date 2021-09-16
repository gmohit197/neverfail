//
//  addcell.swift
//  Ripple CSR
//
//  Created by hannan parvez on 25/02/20.
//  Copyright © 2020 hannan parvez. All rights reserved.
//

import UIKit
import SwipeCellKit
protocol quantiychangedelegate : class {
    func didedittextfield(_ tag: Int)
}
class addcell: SwipeTableViewCell {

    @IBAction func quantitychanged(_ sender: UITextField) {
        quantitydelegate?.didedittextfield(sender.tag)
        
        
    }
    
     var quantitydelegate: quantiychangedelegate?
    
    @IBOutlet var price: UILabel!
    @IBOutlet var quantity: UITextField!
    @IBOutlet var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
