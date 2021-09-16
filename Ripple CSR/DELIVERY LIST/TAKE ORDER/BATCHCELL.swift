//
//  BATCHSERIALCELL.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 06/01/21.
//  Copyright © 2021 aayush shukla. All rights reserved.
//

import UIKit

protocol batchqty{
    func bqtytapped(at index: IndexPath)
}

class BATCHCELL: UITableViewCell {

    var index: IndexPath!
    var delegate: batchqty!
    
    @IBOutlet var batchlbl: UILabel!
    @IBOutlet var bqtylbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let qtytap = UITapGestureRecognizer(target: self, action: #selector(self.qtytap))
        self.bqtylbl.addGestureRecognizer(qtytap)
    }
    
    @objc func qtytap(){
        self.delegate.bqtytapped(at: index)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
