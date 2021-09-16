//
//  complianceCELL.swift
//  Ripple CSR
//
//  Created by Acxiom Consulting on 10/06/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import SQLite3
import Darwin
import EasyTipView

class complianceCELL: UITableViewCell {
  
    @IBOutlet var tooglebtn: UISwitch!
    @IBOutlet var title: UILabel!
    @IBOutlet var infobtn: UIButton!
    
    var delegate: ToogleBtnClicked!
    var indexPath:IndexPath!
    var preferences = EasyTipView.Preferences()
    var view: EasyTipView!
    var info: String!
    var uid : String!
    
    @IBAction func info(_ sender: UIButton) {
        view = EasyTipView(text: self.info, preferences: preferences)
             if (self.infobtn.isSelected == false){
                 view.show(forView: sender, withinSuperview: (self.infobtn.superview?.superview?.superview?.superview?.superview?.superview)!)
                 self.infobtn.isSelected = !self.infobtn.isSelected
                DispatchQueue.main.asyncAfter(deadline: .now() + CONSTANT.gettexttime(text: self.info)) {
                      self.view.dismiss()
                         self.infobtn.isSelected = !self.infobtn.isSelected
                 }
             }
    }
    
    func configurepopover(){
        preferences.drawing.font = UIFont(name: "Futura-Medium", size: 13)!
        preferences.drawing.foregroundColor = UIColor.black
        preferences.drawing.borderWidth = 1.5
        preferences.drawing.borderColor = UIColor.black
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.right
        preferences.drawing.backgroundColor = UIColor.init(hex: "#e5e5eaff")!

        preferences.animating.showInitialAlpha = 0
        preferences.animating.showDuration = 0.4
        preferences.animating.dismissDuration = 0.4
        
         EasyTipView.globalPreferences = preferences
    }
    
    @IBAction func tooglebtn(_ sender: UISwitch) {
    print("toogle state - \(sender.isOn)")
        let CREATE_TABLE_CUSTOMER_DETAIL = "update Compliance set toogle = '\(sender.isOn)',remarks = '' where uid = '\(uid!)'"
        
          if sqlite3_exec(Databaseconnection.dbs, CREATE_TABLE_CUSTOMER_DETAIL, nil, nil, nil) != SQLITE_OK{
            print("Error update Compliance - Tooglebtn value")
            return
          }
        self.delegate.ToogleTapped(at: indexPath)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configurepopover()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

