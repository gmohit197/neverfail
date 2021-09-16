//
//  LOADIGCELL.swift
//  Ripple CSR
//
//  Created by Acxiom Consulting on 06/06/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit

class LOADIGCELL: UITableViewCell {

    
    @IBOutlet var productlbl: UILabel!
    @IBOutlet var qtylbl: UILabel!
    @IBOutlet var qtystk: UIStackView!
    var delegate : TapQty!
    var index : IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tapqty = UITapGestureRecognizer(target: self, action: #selector(self.tapqty))
        self.qtystk.addGestureRecognizer(tapqty)
               
           }

           @objc func tapqty(){
               self.delegate.updateqty(at: index)
           }    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
