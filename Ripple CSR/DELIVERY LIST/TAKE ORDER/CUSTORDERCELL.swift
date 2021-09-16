//
//  CUSTORDERCELL.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 25/06/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit

protocol TapQty {
    func updateqty(at index: IndexPath)
}

class CUSTORDERCELL: UITableViewCell {

    var delegate : TapQty!
    var index : IndexPath!

    @IBOutlet weak var proddesc: UILabel!
    
    @IBOutlet weak var qty: UILabel!
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet var qtystk: UIStackView!
    
    @IBOutlet var itchlbl: UILabel!
    
    @IBOutlet var itdislbl: UILabel!
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
