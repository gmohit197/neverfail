//
//  PreStartCheckList_first.swift
//  Ripple CSR
//
//  Created by Acxiom Consulting on 08/06/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import SQLite3
import Darwin
import EasyTipView

protocol ToogleBtnClicked{
    func ToogleTapped(at index:IndexPath)
}

class PreStartCheckList_first: UITableViewCell {

    
    @IBOutlet var desclbl: UILabel!
    @IBOutlet var infobtn: UIButton!
    @IBOutlet var tooglebtn: UISwitch!
    
    var delegate:ToogleBtnClicked!
    var indexPath:IndexPath!
    var preferences = EasyTipView.Preferences()
    var view: EasyTipView!
    var desc : String!
    var uid : String!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configurepopover()
    }

    @IBAction func info(_ sender: UIButton) {

        view = EasyTipView(text: desc, preferences: preferences)
        if (self.infobtn.isSelected == false){
            view.show(forView: sender, withinSuperview: (self.infobtn.superview?.superview?.superview?.superview?.superview?.superview)!)
            self.infobtn.isSelected = !self.infobtn.isSelected
            DispatchQueue.main.asyncAfter(deadline: .now() + CONSTANT.gettexttime(text: self.desc)) {
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
    
    @IBAction func toogle(_ sender: UISwitch) {
        print("toogle state - \(sender.isOn)")
        let query = "update PreStartChecklist set toogle = '\(sender.isOn)',remarks = '' where uid = '\(uid!)'"
        
          if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error update PreStartChecklist - Tooglebtn value")
            return
          }
        self.delegate.ToogleTapped(at: indexPath)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
