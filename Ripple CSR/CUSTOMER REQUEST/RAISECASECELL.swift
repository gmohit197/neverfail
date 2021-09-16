//
//  RAISECASECELL.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 13/08/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import Darwin
import EasyTipView
//01147613036 - B.A.F.
class RAISECASECELL: UITableViewCell {

    @IBOutlet var ftext: UILabel!
    @IBOutlet var stext: UILabel!
    @IBOutlet var ftype: UILabel!
    @IBOutlet var fdate: UILabel!
    @IBOutlet var stype: UILabel!
    @IBOutlet var sdate: UILabel!
    @IBOutlet var infobtn: UIButton!
    
    var preferences = EasyTipView.Preferences()
    var view: EasyTipView!
    var state : String!
    var desc: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configurepopover()
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
    
    @IBAction func info(_ sender: UIButton) {

        view = EasyTipView(text: self.desc, preferences: preferences)
        if (self.infobtn.isSelected == false){
            view.show(forView: sender, withinSuperview: (self.infobtn.superview?.superview?.superview?.superview?.superview?.superview)!)
            self.infobtn.isSelected = !self.infobtn.isSelected
            DispatchQueue.main.asyncAfter(deadline: .now() + CONSTANT.gettexttime(text: self.desc)) {
                 self.view.dismiss()
                    self.infobtn.isSelected = !self.infobtn.isSelected
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
