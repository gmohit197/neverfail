//
//  LOGINVC.swift
//  Ripple CSR
//
//  Created by aayush shukla on 21/02/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import MaterialComponents
import SkyFloatingLabelTextField
import LocalAuthentication
import SQLite3

class LOGINVC: BASEACTIVITY {
    
    @IBOutlet var password: MDCTextField!
    var iconClick = true
    @IBOutlet var username: MDCTextField!
    var i = 0
    @IBOutlet var mainview: UIView!
    var usernamecontroller: MDCTextInputControllerOutlined?
    var passwordcontroller: MDCTextInputControllerOutlined?
    var adapter = [DELIVERYADAPTER]()
    
    @IBOutlet var versionlbl: UILabel!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var connectionlbl: UILabel!
    var appversion = ""
    
    var image: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "bg")
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        appversion = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)!
        if (CONSTANT.IS_DEBUG){
            self.versionlbl.text = "Neverfail Delivery App Debug-v\(appversion)"
        }else{
            self.versionlbl.text = "Neverfail Delivery App v\(appversion)"
        }
        
//        view.insertSubview(self.image, at: 0)
/*        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: view.topAnchor),
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            image.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    */
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func VD(){
        self.view.isUserInteractionEnabled = true
        if (UserDefaults.standard.string(forKey: "logincall") == self.getdate(format: "yyyy-MM-dd")){
            self.ismaster = true
        }else{
            self.ismaster = false
        }
        self.i = -1;
        print("\n\n get token called from 'VD' - \(self.getdate(format: "HH:mm:ss.SSS"))")
        self.gettoken()
    }
    
    override func INVD(){
        self.showToast(message: "Invalid Credentials")
        self.hideindicator()
    }
    
    override func ERR(){
        self.showToast(message: "Server not reachable")
        self.hideindicator()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernamecontroller = MDCTextInputControllerOutlined(textInput: username)
        
        usernamecontroller?.normalColor = UIColor.white
        usernamecontroller?.activeColor = UIColor.white
        usernamecontroller?.inlinePlaceholderColor = UIColor.white
        usernamecontroller?.floatingPlaceholderActiveColor = UIColor.white
        usernamecontroller?.floatingPlaceholderNormalColor = UIColor.white
        username.textColor = UIColor.white
        
        passwordcontroller = MDCTextInputControllerOutlined(textInput: password)
        
        passwordcontroller?.normalColor = UIColor.white
        passwordcontroller?.activeColor = UIColor.white
        passwordcontroller?.inlinePlaceholderColor = UIColor.white
        passwordcontroller?.floatingPlaceholderActiveColor = UIColor.white
        passwordcontroller?.floatingPlaceholderNormalColor = UIColor.white
        password.textColor = UIColor.white
        
        Databaseconnection.createdatabase()
        
        username.clearButton.isEnabled = false
        username.clearButton.isHidden = true
        
        password.clearButton.isEnabled = false
        password.clearButton.isHidden = true
        
        username.sizeToFit()
        password.sizeToFit()
        
        if (CONSTANT.RESOURCE.contains("https://apimtst.ccamatil.com/p/neverfail2")){
            self.connectionlbl.isHidden = false
            self.connectionlbl.text = "UAT 2"
            
        }else if (CONSTANT.RESOURCE.contains("https://apimtst.ccamatil.com/p/neverfail")){
            self.connectionlbl.isHidden = false
            self.connectionlbl.text = "UAT 1"
            
        }else if (CONSTANT.RESOURCE.contains("https://apim.ccamatil.com/p/neverfail")){
            self.connectionlbl.isHidden = false
            self.connectionlbl.text = ""
        }else  {
            self.connectionlbl.isHidden = false
            self.connectionlbl.text = "DEV"
        }
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "eyewhite.png"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(password.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.refresh), for: .touchUpInside)
        password.rightView = button
        password.rightViewMode = .always
        
        print("login screen")
     
        //        MARK:- COMMENT HERE
//        self.username.text = "aubedika@ccamatil.com"
//        self.password.text = "Karan260794.."
//                self.username.text = "aukumarvi@ccamatil.com"
//                self.password.text = "Inagentleway@95."
    }
    
    override func gotpre(){
        self.hideindicator()
        self.push(storybId: "PRESTARTCHECKLIST", vcId: "PRESTARTFIRSTNC", vc: self)
    }
    
    override func notpre(){
        self.showToast(message: "Unable to get Prestart data")
        self.hideindicator()
    }
    
    override func pskip(){
        if (AppDelegate.ntwrk > 0){
            self.i = 2
            print("\n\n get token called from 'pskip' - \(self.getdate(format: "HH:mm:ss.SSS"))")
            self.gettoken()
        }else{
            self.showToast(message: "Internet connection required.")
        }
        UserDefaults.standard.set(self.getdate(format: "yyyy-MM-dd"), forKey: "predate")
    }
    
    override func cskip(){
        self.hideindicator()
        
//                        let rootVC = UIStoryboard(name: "TRUCKLOAD", bundle: nil).instantiateInitialViewController()
//                        UIApplication.shared.windows.first?.rootViewController = rootVC
//                        UIApplication.shared.windows.first?.makeKeyAndVisible()
//                        self.push(storybId: "TRUCKLOAD", vcId: "TRUCKLOADFIRSTNC", vc: self)
        CONSTANT.apicall = 0
        CONSTANT.failapi = 0
        self.gotohome()
        UserDefaults.standard.set(self.getdate(format: "yyyy-MM-dd"), forKey: "comdate")
        UserDefaults.standard.set(self.getdate(format: "yyyy-MM-dd"), forKey: "trkdate")
    }
    
    override func gotcom(){
        print("\n*** goto compliance called ***\n")
        self.view.isUserInteractionEnabled = true
        self.hideindicator()
        let rootVC = UIStoryboard(name: "COMPLIANCE", bundle: nil).instantiateInitialViewController()
        UIApplication.shared.windows.first?.rootViewController = rootVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        UserDefaults.standard.set(self.getdate(format: "yyyy-MM-dd"), forKey: "predate")
    }
    
    override func notcom(){
        self.view.isUserInteractionEnabled = true
        self.hideindicator()
        self.showToast(message: "Unable to get Compliance data")
    }
    
    override func errcom(){
        self.showToast(message: "Error in Compliance Passport API")
        self.hideindicator()
    }
    
    override func errpre(){
        self.showToast(message: "Error in Pre-Start API")
        self.hideindicator()
    }
    
    override func gotname(){
        self.logintonext()
    }
    
    override func nameerr(){
        self.hideindicator()
        self.loginbtn.isUserInteractionEnabled = true
        self.showToast(message: "Unable to get user details due to API error")
    }
    
    var api = 0
    var mname = ""
    
    override func apicall() {
        self.api += 1
        if (self.api == CONSTANT.apicall){
            if (CONSTANT.failapi > 0){
                if (CONSTANT.mastername.count > 0){
                    self.mname = CONSTANT.mastername[0]
                    if (CONSTANT.mastername.count > 1){
                        for i in 1..<CONSTANT.mastername.count {
                            self.mname = self.mname + " ," + CONSTANT.mastername[i]
                        }
                    }
                }
                self.showToast(message: "Following Master(s) not downloaded - \(self.mname)")
                self.hideindicator()
            }else{
                self.ismaster = true
                UserDefaults.standard.setValue(self.getdate(format: "yyyy-MM-dd"), forKey: "logincall")
                self.api = -1
                print("\n\n get token called from 'apicall' - \(self.getdate(format: "HH:mm:ss.SSS"))")
                self.gettoken()
            }
        }
    }
    
    override func notname(){
        self.showToast(message: "The Driver does not exist in Driver Master. Please contact administrator")
        self.hideindicator()
    }
    
    @IBOutlet var loginbtn: UIButton!
    
    @IBAction func refresh(_ sender: Any) {
        if(iconClick == true) {
            password.isSecureTextEntry = false
        } else {
            password.isSecureTextEntry = true
        }
        
        iconClick = !iconClick
    }
    @IBAction func login(_ sender: Any) {
        
        print("Login clicked")
        self.validateuser()
    }
    
    func validateuser(){
        let user = self.username.text!
        let pass = self.password.text!
        
        if (user.count == 0 || user == " "){
            self.showToast(message: "Enter Username to continue")
        }else if (pass.count == 0 || pass == " "){
            self.showToast(message: "Enter Password to continue")
        }else{
            if (AppDelegate.ntwrk > 0){
                self.showIndicator("Loading...", vc: self)
                self.validateuser(username: user, password: pass)
                self.view.isUserInteractionEnabled = false
            }else{
                self.showToast(message: "Enable Internet connection to continue")
            }
        }
        
    }
    
    var ismaster = false
    
    override func callback() {
        print("\n\n callback called - \(self.getdate(format: "HH:mm:ss.SSS"))")
        if (ismaster){
            if (i == 0){
                self.getcondition(type: "1")
            }else if (i > 0){
                self.getcondition(type: "2")
            }else if (i < 0){
                self.getuserdetail(userid: self.username.text!)
                //            self.getcasetype()
            }
        }else{
            if (UserDefaults.standard.string(forKey: "userid") != self.username.text!){
                self.clearsequence()
                if (self.deleteDatabase()){
                    Databaseconnection.createdatabase()
                }
            }
            self.showIndicator("Syncing...", vc: self)
            CONSTANT.apicall = 0
            CONSTANT.failapi = 0
            self.api = 0
            CONSTANT.mastername.removeAll()
            self.gettaxgroup()
            self.gettaxmaster()
            self.getautocharge()
            self.getitemmaster()
//            self.getbatchmaster()
//            self.getserialmaster()
            self.getpricemaster()
            self.getdiscountmaster()
            //New Added
            self.getrevenueschedule()
            self.getreasonmaster()
            self.getTruckMaster()
            self.getlineodduty()
            self.getsubsegment()
        }
    }
    override func failcall() {
        self.view.isUserInteractionEnabled = true
        self.showToast(message: "Authentication failed!!!")
        self.hideindicator()
    }
    func logintonext(){
        
        if (UserDefaults.standard.string(forKey: "userid") != self.username.text!){
            UserDefaults.standard.set("", forKey: "predate")
            UserDefaults.standard.set("", forKey: "trkdate")
            UserDefaults.standard.set("", forKey: "comdate")
            UserDefaults.standard.set("", forKey: "brdate")
            UserDefaults.standard.set("", forKey: "syncdate")
            UserDefaults.standard.set("", forKey: "pincode")
            UserDefaults.standard.set("", forKey: "loadnum")
            UserDefaults.standard.set("", forKey: "logincall")
            
        }
        UserDefaults.standard.setValue(self.username.text!, forKey: "userid")
        UserDefaults.standard.setValue(self.password.text!, forKey: "pwd")
        
        if (UserDefaults.standard.string(forKey: "predate") == nil || UserDefaults.standard.string(forKey: "predate") != self.getdate(format: "yyyy-MM-dd")){
            UserDefaults.standard.set("", forKey: "pincode")
            if (AppDelegate.ntwrk > 0){
                self.i = 0
                print("\n\n get token called from 'predate' - \(self.getdate(format: "HH:mm:ss.SSS"))")
                self.gettoken()
                self.deletetable(tbl: "batchserial")
                self.deletetable(tbl: "checkinitems")
            }else{
                self.showToast(message: "No Internet connection")
                self.hideindicator()
            }
        }else if (UserDefaults.standard.string(forKey: "comdate") == nil || UserDefaults.standard.string(forKey: "comdate") != self.getdate(format: "yyyy-MM-dd")){
            UserDefaults.standard.set("", forKey: "pincode")
            if (AppDelegate.ntwrk > 0){
                self.i = 2;
                print("\n\n get token called from 'comdate' - \(self.getdate(format: "HH:mm:ss.SSS"))")
                self.gettoken()
                //                self.getcrmtoken()
                
            }else{
                self.hideindicator()
                self.showToast(message: "No Internet connection")
            }
            //            self.getcondition(type: "2")
        }else if(UserDefaults.standard.string(forKey: "trkdate") == nil || UserDefaults.standard.string(forKey: "trkdate") != self.getdate(format: "yyyy-MM-dd")){
            self.hideindicator()
            let rootVC = UIStoryboard(name: "TRUCKLOAD", bundle: nil).instantiateInitialViewController()
            UIApplication.shared.windows.first?.rootViewController = rootVC
            UIApplication.shared.windows.first?.makeKeyAndVisible()
            
        }else if (checkbreak()){
            self.hideindicator()
            let sb = UIStoryboard(name: "BREAK", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "BVC") as! BREAKVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                self.hideindicator()
                CONSTANT.apicall = 0
                CONSTANT.failapi = 0
                self.gotohome()
            }
        }
    }
    
    func checkbreak() -> Bool{
        var stmt1:OpaquePointer?
        
        let query = "select * from Break where date = '\(self.getdate(format: "yyyy-MM-dd"))' and state  = '0'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return false
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            // lock screen
            let starttime = String(cString: sqlite3_column_text(stmt1, 3))
            let dur = self.getduration(time1Str: starttime, time2Str: self.getdate(format: "hh:mm:ss a"))
            if ( dur < 15*60){
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    func authenticateUser() {
        let context = LAContext()
        var error: NSError?
        context.localizedFallbackTitle = ""
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        print("authentication success...")
                        self.logintonext()
                    } else {
                        print("authentication failed...")
                        let ac = UIAlertController(title: "Authentication failed", message: "Sorry!", preferredStyle: .alert)
                        let okaction = UIAlertAction(title: "Ok", style: .default) { _ in
                            ac.dismiss(animated: true, completion: nil)
                        }
                        ac.addAction(okaction)
                        self.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Touch ID not available", message: "Your device is not configured for Touch ID.", preferredStyle: .alert)
            let okaction = UIAlertAction(title: "Ok", style: .default) { _ in
                ac.dismiss(animated: true, completion: nil)
                self.logintonext()
            }
            ac.addAction(okaction)
            present(ac, animated: true)
        }
    }
    
}
