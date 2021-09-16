//
//  BASEACTIVITY.swift
//  Ripple CSR
//
//  Created by aayush shukla on 21/02/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialSnackbar
import FloatingSearchTextLabelField
import MaterialComponents
import SQLite3
import Foundation

enum NoDelReason : String {
    //    0        open
    //    1        reschedule
    //    2        skip
    //    3        delivered
    //    4        cancelOrder
    case open = "0"
    case reschedule = "1"
    case skip = "2"
    case delivered = "3"
    case cancelOrder = "4"
}

enum JPEGQuality: CGFloat {
    case lowest  = 0
    case low     = 0.25
    case medium  = 0.5
    case high    = 0.75
    case highest = 1
}

public class BASEACTIVITY: ExecuteApi {
    
    let DoneToolBar = UIToolbar().ToolbarPiker(mySelect: #selector(keyboarddone))
        
    public func push(storybId: String, vcId: String, vc: BASEACTIVITY ){
            let storyboard = UIStoryboard(name: storybId, bundle: nil)
            let registrationVC = storyboard.instantiateViewController(withIdentifier: vcId) as! UINavigationController
            navigationController?.pushViewController(registrationVC.topViewController!, animated: true)
        }
    
    public func clearsequence(){
        let adapter = [DELIVERYADAPTER]()
        let placesData = try! JSONEncoder().encode(adapter)
        UserDefaults.standard.set(placesData, forKey: "items")
    }
    
    @objc func keyboarddone(){
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
        view.endEditing(true)
    }
    
    var bgimage: UIImageView = {
           let imageView = UIImageView(frame: .zero)
           imageView.image = UIImage(named: "innerbg")
           imageView.contentMode = .scaleToFill
           imageView.translatesAutoresizingMaskIntoConstraints = false
           return imageView
       }()
    
    public func showToast(message : String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Dismiss", style: .destructive) { action in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
   public func findDateDiff(time1Str: String, time2Str: String) -> String {
        let timeformatter = DateFormatter()
    timeformatter.dateFormat = "hh:mm:ss a"

        guard let time1 = timeformatter.date(from: time1Str),
            let time2 = timeformatter.date(from: time2Str) else { return "" }

        //You can directly use from here if you have two dates

//        let interval = time2.timeIntervalSince(time1)
//        let hour = interval / 3600;
//        let minute = interval.truncatingRemainder(dividingBy: 3600) / 60
//        let intervalInt = Int(interval)
//        var diff = ""
//        if (Int(hour) == 0){
//            diff = "\(Int(minute)) mins."
//        }else if (Int(minute) == 0){
//            diff = "\(Int(hour)) hrs."
//        }else{
////            diff = "\(intervalInt < 0 ? "-" : "+") \(Int(hour)) hrs. \(Int(minute)) mins."
//            diff = "\(Int(hour)) hrs. \(Int(minute)) mins."
//        }
//        return diff
    let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([Calendar.Component.second], from: time1, to: time2)

        let seconds = dateComponents.second
        let (h,m,s) = self.secondsToHoursMinutesSeconds(seconds: Int(seconds!))
            
    if (h == 0){
        return "\(m) Min. \(s) Sec."
    }else{
        return "\(h) Hr. \(m) Min. \(s) Sec."
    }
    
    }
    
    public func getduration(time1Str: String, time2Str: String) -> Int {
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "hh:mm:ss a"

        guard let time1 = timeformatter.date(from: time1Str),
            let time2 = timeformatter.date(from: time2Str) else { return -1 }

        //You can directly use from here if you have two dates

        let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([Calendar.Component.second], from: time1, to: time2)

            let seconds = dateComponents.second
            return Int(seconds!)
    }
    
    public func showmsg(msg: String){
        let mymessage = MDCSnackbarMessage()
        mymessage.text = msg
        mymessage.duration=TimeInterval(exactly: 2.5)!
        MDCSnackbarManager.messageTextColor = .black
        MDCSnackbarManager.snackbarMessageViewBackgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        MDCSnackbarManager.show(mymessage)
    }
    
    public func imagetobase(image: UIImage)-> String {
        let imageData:NSData = image.pngData()! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        
        return strBase64
    }
    
    public func deleteDatabase() -> Bool
       {
        var flag = false
               let filemManager = FileManager.default
               do {
                   let fileURL = try!

                   FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("NeverFailDB.sqlite")
                   try filemManager.removeItem(at: fileURL as URL)
                flag = true
                   print("Database Deleted!")
               } catch {
                   print("Error on Delete Database!!!")
               }
        return flag
    }
    
    public func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    public func setnav(title: String){
         if self.navigationController != nil {
            AppDelegate.controller = self.navigationController
         }else if AppDelegate.controller == nil {
            return
        }
        
        
        let navView = UIView()
        
        // Create the label
        let label = UILabel()
        if (title != ""){
            label.text = title
            AppDelegate.titletext = title
        }else if (AppDelegate.titletext != ""){
            label.text = AppDelegate.titletext
        }else{
            return
        }
        
        label.sizeToFit()
        label.center = navView.center
        label.textAlignment = NSTextAlignment.center
        
        label.font = UIFont.boldSystemFont(ofSize: 15)

        // Create the image view
        let image = UIImageView()
        
        if AppDelegate.ntwrk == 1 {
        image.image = UIImage(named: "online.png")
        }else{
        image.image = UIImage(named: "offline.png")
        }
        
        // To maintain the image's aspect ratio:
        let imageAspect = image.image!.size.width/image.image!.size.height
        // Setting the image frame so that it's immediately before the text:
        image.frame = CGRect(x: (label.frame.origin.x-label.frame.size.height/1.3)*imageAspect, y: label.frame.origin.y/2, width: label.frame.size.height*0.6*imageAspect, height: label.frame.size.height*0.6)
        image.contentMode = UIView.ContentMode.scaleAspectFit

        // Add both the label and image view to the navView
        navView.addSubview(label)
        navView.addSubview(image)

        // Set the navigation bar's navigation item's titleView to the navView
        if navigationItem.title == nil{
//                    if let topVC = UIApplication.getTopViewController() {
//            //           topVC.view.addSubview(forgotPwdView)
//                        topVC.navigationItem.titleView = navView
//                    }
            AppDelegate.navitem?.titleView = navView
            
        }else{
           navigationItem.titleView = navView
            AppDelegate.navitem = navigationItem
        }

        // Set the navView's frame to fit within the titleView
        navView.sizeToFit()
    }
    
    func customizesearchfields(withname searchfield:FloatingSearchTextField){
              searchfield.inputAccessoryView=self.DoneToolBar
           searchfield.theme = FloatingSearchTextFieldTheme.lightTheme()
              searchfield.theme.font = UIFont.systemFont(ofSize: 12)
              searchfield.theme.bgColor = UIColor.white.withAlphaComponent(1)
              searchfield.theme.borderColor = UIColor.lightGray.withAlphaComponent(1)
              searchfield.theme.separatorColor = UIColor.lightGray.withAlphaComponent(1)
              searchfield.theme.cellHeight = 30
              searchfield.theme.placeholderColor = UIColor.gray
              searchfield.theme.subtitleFontColor=UIColor.white
              searchfield.startVisible=true
          }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 50
            }
        }
    }
    
    public func initialiseBarBtn(image :UIImage, title :String, target: Any?, action: Selector?) -> UIBarButtonItem {
        
        var barbtn : UIBarButtonItem
        let button = UIButton(type: .custom)
        
        button.setImage(image, for: .normal)
        button.setTitle(title, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)

        if let target = target, let action = action {
            button.addTarget(target, action: action, for: .touchUpInside)
        }
        barbtn = UIBarButtonItem(customView: button)
        return barbtn
    }
    
    public func gettextwithimage(image: String,mobileLabel: UILabel,text: String,textalignment: NSTextAlignment){
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: "\(image)")
        // Set bound to reposition
        let imageOffsetY: CGFloat = -5.0
        imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        // Create string with attachment
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        // Initialize mutable string
        let completeText = NSMutableAttributedString(string: "")
        // Add image to mutable string
        completeText.append(attachmentString)
        // Add your text to mutable string
        let textAfterIcon = NSAttributedString(string: "  \(text)")
        completeText.append(textAfterIcon)
        mobileLabel.textAlignment = textalignment
        mobileLabel.attributedText = completeText
    }
    
    public func setbg(){
//        view.insertSubview(self.bgimage, at: 0)
//        NSLayoutConstraint.activate([
//            bgimage.topAnchor.constraint(equalTo: view.topAnchor),
//            bgimage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            bgimage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            bgimage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
    }
    
    func gotohome(){
        let rootVC = UIStoryboard(name: "RESQUENCING", bundle: nil).instantiateInitialViewController()
        UIApplication.shared.windows.first?.rootViewController = rootVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func convertDateFormater(date: String,input: String,output: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = input
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = output
        return  dateFormatter.string(from: date!)
    }
    
    func getitemidfromname(itemname: String)-> String{
        var stmt1:OpaquePointer?
        var itemid = ""
        let query = "select itemcode from itemmaster where itemname  ='\(itemname)'"
                          
                 if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
                     let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                     print("error preparing get: \(errmsg)")
                     return ""
                 }
        //Custorder(custid text,userid text, itemid text, qty text, date text, price text, totvalue text, status text,post text)
                 if(sqlite3_step(stmt1) == SQLITE_ROW){
                    itemid = String(cString: sqlite3_column_text(stmt1, 0))
                 }
        return itemid
    }
    
    func logout(){
        self.showIndicator("Logging out...", vc: self)
        UserDefaults.standard.set("", forKey: "predate")
        UserDefaults.standard.set("", forKey: "trkdate")
        UserDefaults.standard.set("", forKey: "comdate")
        UserDefaults.standard.set("", forKey: "userid")
        UserDefaults.standard.set("", forKey: "uname")
        UserDefaults.standard.set("", forKey: "brdate")
        UserDefaults.standard.set("", forKey: "logincall")
        UserDefaults.standard.set("", forKey: "syncdate")
        
        self.clearsequence()
        
        self.deleteDatabase()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.hideindicator()
            let rootVC = UIStoryboard(name: "LOGIN", bundle: nil).instantiateInitialViewController()
            UIApplication.shared.windows.first?.rootViewController = rootVC
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
        
    }
    
    
    func getbarbutton()-> UIBarButtonItem{
        let button = UIButton.init(type: .custom)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        let buttonView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
        let imageView = UIImageView(frame: CGRect(x: 46, y: 2, width: 27, height: 26))
        let img = UIImage(named: "back_arrow")
        var image = img!.rotate(radians: .pi)
        image  = image?.imageWithColor(color: UIColor.systemBlue)
        imageView.image = image
        let label = UILabel(frame: CGRect(x: 7, y: 0, width: 45, height: 30))
        label.text = "Next"
        label.textColor = UIColor.systemBlue
        label.textAlignment = .center
        button.frame = buttonView.frame
        buttonView.addSubview(button)
        buttonView.addSubview(label)
        buttonView.addSubview(imageView)
        button.tintColor = UIColor.systemBlue
        let barButton = UIBarButtonItem.init(customView: buttonView)
        return barButton
    }
    
    func getbackbarbutton()-> UIBarButtonItem{
        let button = UIButton.init(type: .custom)
        button.addTarget(self, action: #selector(backbuttonPressed), for: .touchUpInside)
        let buttonView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
        let imageView = UIImageView(frame: CGRect(x: -12, y: 2, width: 27, height: 26))
        var img = UIImage(named: "back_arrow")
//        var image = img!.rotate(radians: .pi)
        img  = img?.imageWithColor(color: UIColor.systemBlue)
        imageView.image = img
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 45, height: 30))
        label.text = "Back"
        label.textColor = UIColor.systemBlue
        label.textAlignment = .center
        button.frame = buttonView.frame
        buttonView.addSubview(button)
        buttonView.addSubview(label)
        buttonView.addSubview(imageView)
        button.tintColor = UIColor.systemBlue
        let barButton = UIBarButtonItem.init(customView: buttonView)
        return barButton
    }
    
    @objc func buttonPressed(){
        
    }
    
    @objc func backbuttonPressed(){
        
    }
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    
        var activityIndicator = UIActivityIndicatorView()
        var strLabel = UILabel()
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        
    func showIndicator(_ title: String,vc: UIViewController) {
        self.navigationController?.view.isUserInteractionEnabled = false
        self.view.isUserInteractionEnabled = false
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
            strLabel.removeFromSuperview()
            activityIndicator.removeFromSuperview()
            effectView.removeFromSuperview()
            strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 180, height: 46))
            strLabel.text = title
            strLabel.font = .systemFont(ofSize: 15, weight: .medium)
        strLabel.textColor = UIColor.white
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: vc.view.frame.midY - strLabel.frame.height/2 , width: 180, height: 46)
            effectView.layer.cornerRadius = 15
            effectView.layer.masksToBounds = true
        activityIndicator = UIActivityIndicatorView(style: .white)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
            activityIndicator.startAnimating()
            effectView.contentView.addSubview(activityIndicator)
            effectView.contentView.addSubview(strLabel)
            vc.view.addSubview(effectView)
        }
    
    public func hideindicator(){
        if (activityIndicator.isAnimating){
            self.activityIndicator.stopAnimating()
            self.effectView.removeFromSuperview()
            self.navigationController?.view.isUserInteractionEnabled = true
            self.view.isUserInteractionEnabled = true
            self.navigationController?.navigationBar.isUserInteractionEnabled = true
        }
        
    }
    
    public func getuid()-> String{
        let uid = self.getdate(format: "yyyy-MM-dd HH:mm:ss.SSS")
        let lotid = uid.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: ":", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: " ", with: "")
        return lotid
    }
    
    public func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 60) % 60)
    }
    
    public func getdate (format: String) -> String {
        let date = Date()
        var currdate : String = ""
        do{
            let formatter = DateFormatter()
            formatter.dateFormat = format
            currdate = formatter.string(from: date)
        }catch{
            print("unsupported Date Format...")
        }       
        
        return currdate
    }
    
//    Wednesday, Sep 12, 2018           --> EEEE, MMM d, yyyy
//    09/12/2018                        --> MM/dd/yyyy
//    09-12-2018 14:11                  --> MM-dd-yyyy HH:mm
//    Sep 12, 2:11 PM                   --> MMM d, h:mm a
//    September 2018                    --> MMMM yyyy
//    Sep 12, 2018                      --> MMM d, yyyy
//    Wed, 12 Sep 2018 14:11:54 +0000   --> E, d MMM yyyy HH:mm:ss Z
//    2018-09-12T14:11:54+0000          --> yyyy-MM-dd'T'HH:mm:ssZ
//    12.09.18                          --> dd.MM.yy
//    10:41:02.112                      --> HH:mm:ss.SSS
    
}

//MARK:- extensions

extension UIApplication {

    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

extension UIBarButtonItem {
    convenience init(image :UIImage, title :String, target: Any?, action: Selector?) {
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.setTitle(title, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)

        if let target = target, let action = action {
            button.addTarget(target, action: action, for: .touchUpInside)
        }
        self.init(customView: button)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
    
    func imageWithColor(color: UIColor) -> UIImage? {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension UIToolbar {
    
    func ToolbarPiker(mySelect : Selector) -> UIToolbar {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: mySelect)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
        
    }
    func minussign(mySelect : Selector,minus: Selector,controller: UIViewController) -> UIToolbar {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: mySelect)
        var minusButton = UIBarButtonItem(title: "Minus (-)", style: UIBarButtonItem.Style.plain, target: self, action: minus)
        var spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ minusButton , spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        
        return toolBar
        
    }
    
}
extension UIStackView {
        
        func addBorder(color: UIColor, backgroundColor: UIColor, thickness: CGFloat) {
            let insetView = UIView(frame: bounds)
            insetView.backgroundColor = backgroundColor
            insetView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            insetView.layer.masksToBounds = false
            insetView.layer.borderColor = UIColor.darkGray.cgColor
            insetView.layer.borderWidth = thickness
            
            insertSubview(insetView, at: 0)
                    
        }
    }
  extension UILabel {
    
    func addBorder(color: UIColor, thickness: CGFloat) {
        let insetView = UIView(frame: bounds)
        insetView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        insetView.layer.masksToBounds = false
        insetView.layer.borderColor = UIColor.darkGray.cgColor
        insetView.layer.borderWidth = thickness
//        insetView.layer.border
        
        insertSubview(insetView, at: 0)
                
    }
}
extension MDCTextInputControllerOutlined {
    
    func setfordark(field: MDCTextField,controller: UIViewController){
        if #available(iOS 12.0, *) {
            if controller.traitCollection.userInterfaceStyle == .dark {
                field.textColor = UIColor.white
                self.normalColor = UIColor.white
                self.disabledColor = UIColor.white
                self.inlinePlaceholderColor = UIColor.white
                self.floatingPlaceholderActiveColor = UIColor.white
                self.floatingPlaceholderNormalColor = UIColor.white
                self.activeColor = UIColor.white
                field.placeholderLabel.textColor = UIColor.white
            }else{
                field.textColor = UIColor.black
                self.normalColor = UIColor.black
                self.disabledColor = UIColor.black
                self.inlinePlaceholderColor = UIColor.lightGray
                self.floatingPlaceholderActiveColor = UIColor.systemBlue
                self.floatingPlaceholderNormalColor = UIColor.black
                self.activeColor = UIColor.systemBlue
                field.placeholderLabel.textColor = UIColor.lightGray
            }
        }
    }
}

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}
extension UITableViewCell {
    func enable(on: Bool) {
        
        for view in contentView.subviews {
            view.alpha = on ? 1 : 0.5
        }
    }
}
extension UIView {
    func enableview(on: Bool) {
        self.isUserInteractionEnabled = on
        self.isUserInteractionEnabled = on
        self.alpha = on ? 1 : 0.5
    }
}

