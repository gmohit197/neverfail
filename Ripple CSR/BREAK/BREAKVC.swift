//
//  BREAKVC.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 07/09/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import SQLite3
import SwiftEventBus

class BREAKVC: BASEACTIVITY,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView.tag == 1){
            return reqbreakadapter.count
        }else {
            return breakadapter.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView.tag == 1){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "reqcell", for: indexPath) as! BREAKTBLCELL
            
            let list : BREAKADAPTER
            list = reqbreakadapter[indexPath.row]
            
            cell.periodlbl.text = list.firstsku
            cell.maxtimelbl.text = list.secomdsku
            cell.restreqlbl.text = list.thirdsku
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tcell", for: indexPath) as! TBREAKCELL
            
            let list : BREAKADAPTER
            list = breakadapter[indexPath.row]
            
            cell.snolbl.text = list.firstsku + "\(indexPath.row + 1)"
            cell.maxtimelbl.text = list.secomdsku
            cell.breaktime.text = list.thirdsku
            
            return cell
        }
    }
    
    var reqbreakadapter = [BREAKADAPTER]()
    var breakadapter = [BREAKADAPTER]()
    var flag = false
    var api = -1;
    var index = 1*60
    var time = 0
    var dur: Int!
    var starttime = ""
    @IBOutlet var breakcard: CardView!
//    @IBOutlet var changedrivercard: CardView!
    @IBOutlet var reqbreaktbl: UITableView!
    @IBOutlet var breaktbl: UITableView!
    @IBOutlet var breakcardlbl: UILabel!
    @IBOutlet var breakcardimg: UIImageView!
    @IBOutlet var mainview: UIView!
    @IBOutlet var timertxt: UILabel!
    @IBAction func endbreak(_ sender: UIButton) {
        self.ctime?.invalidate()
        self.ctime = nil
        self.cflag = false
        self.mainview.isHidden = true
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        self.timer?.invalidate()
        self.timer = nil
        self.flag = true
        startbreak()
    }
    
    @IBAction func donebtn(sender: UIBarButtonItem){
        self.gotohome()
    }
    
    @IBOutlet var ebtn: UIButton!
    var timer: Timer?
    var ctime: Timer?
    var cflag: Bool!
    
    override func viewWillAppear(_ animated: Bool) {
        self.setnav(title: self.navigationItem.title!)
        self.cflag = true
        self.breakcardlbl.text = "---"
        self.navigationItem.leftBarButtonItem = self.getbackbarbutton()
        initdata()
    }
    
    override func backbuttonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func initdata(){
        self.mainview.isHidden = true
        if (UserDefaults.standard.string(forKey: "brdate") == nil || UserDefaults.standard.string(forKey: "brdate") != self.getdate(format: "yyyy-MM-dd") || UserDefaults.standard.string(forKey: "brdate") == ""){
            if (AppDelegate.ntwrk > 0){
                api = 1
                self.showIndicator("Loading...", vc: self)
                self.gettoken()
            }else{
                self.showToast(message: "Internet connection required to continue")
            }
        }else if (AppDelegate.ntwrk > 0){
            if (self.getpstart()){
                self.api = 3
                self.gettoken()
                self.showIndicator("Syncing...", vc: self)
            }else{
                self.api = 1
                self.showIndicator("Syncing...", vc: self)
                self.gettoken()
                self.setcard()
                self.setbrktbl()
            }
        }else{
            setreqtbl()
            setcard()
            setbrktbl()
        }
    }
//    MARK:- CALLBACK
    override func callback() {
        if (api == 1){
            getbreaks()
        }else if (api == 2){
            getbreakhistory(date: self.getdate(format: "yyyy-MM-dd"))
        }else if (api == 3){
            poststartbreak()
        }else if(api == 4){
            postendbreak()
        }
    }
    
    func setcard(){
        var stmt1:OpaquePointer?
                 
        let query = "select * from Break where date = '\(self.getdate(format: "yyyy-MM-dd"))' and state  = '0'"
                          
                 if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
                     let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                     print("error preparing get: \(errmsg)")
                     return
                 }

                 if(sqlite3_step(stmt1) == SQLITE_ROW){
                    self.breakcardlbl.text = "End Break"
                    self.breakcardimg.setImage(UIImage(named: "break_end")!)
                    self.starttime = String(cString: sqlite3_column_text(stmt1, 3))
                    self.dur = self.getduration(time1Str: starttime, time2Str: self.getdate(format: "hh:mm:ss a"))
                    print("\n starttime ===> \(starttime) \t time2Str ===> \(self.getdate(format: "hh:mm:ss a"))")
                    print("\n index ===> \(index) \t dur ===> \(dur!)")
//                    if (self.dur! <= 15 ){
//                        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
                        DispatchQueue.global(qos: .userInitiated).async {
                        DispatchQueue.main.async {
                            self.index = ((15*60) - self.dur!)
                            print("\n index ===> \(self.index)")
                            if (self.cflag){
                                if (self.ctime == nil){
                                self.ctime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.startcountdown), userInfo: nil, repeats: true)
                            }
                                self.mainview.isHidden = false
                                self.mainview.isUserInteractionEnabled = true
                                self.cflag = false
                                self.navigationController?.navigationBar.isUserInteractionEnabled = false

                            }
                        }
                        }
                        
//                        self.navigationController?.view.isUserInteractionEnabled = false
                        self.navigationController?.navigationBar.isUserInteractionEnabled = false
//                    }
                    flag = true
                 }else{
                    self.breakcardlbl.text = "Start Break"
                    self.breakcardimg.setImage(UIImage(named: "start_break")!)
                    self.navigationController?.navigationBar.isUserInteractionEnabled = true
                    flag = false
                    self.mainview.isHidden = true
                    self.ctime?.invalidate()
        }
    }

    @objc func runTimedCode(){
        time = time + 1
        let (h,m,s) = self.secondsToHoursMinutesSeconds(seconds: time)
        print("\n * -> \(m) mins \(s) secs")
        if (h > 0){
            self.timertxt.text = "\(h) hrs. \(m) mins. \(s) secs."
        }else{
            self.timertxt.text = "\(m) mins. \(s) secs."
        }
    }
    
    @objc func startcountdown () {
        
        if index >= 0
        {
            let (h,m,s) = self.secondsToHoursMinutesSeconds(seconds: index)
            print("\n * -> \(m) mins \(s) secs")
            self.timertxt.text = "\(m) mins. \(s) secs."
            index = index - 1
            let dur = self.getduration(time1Str: self.starttime, time2Str: self.getdate(format: "hh:mm:ss a"))
            if (dur < 15*60){                 //    set time for button enablement
                self.ebtn.isEnabled = false
            }else{
                self.ebtn.isEnabled = true
            }
        }
        else if index < 0 {
            self.timertxt.text = "0 mins. 0 secs."
            self.ebtn.isEnabled = true
            self.ctime?.invalidate()
            self.navigationController?.navigationBar.isUserInteractionEnabled = false
            self.cflag = false
            self.starttimer()
        }
    }
    
    func starttimer(){
        self.time = self.getduration(time1Str: starttime, time2Str: self.getdate(format: "hh:mm:ss a"))
        DispatchQueue.global(qos: .userInitiated).async {
        DispatchQueue.main.async {
            print("\n time ===> \(self.time)")
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.runTimedCode), userInfo: nil, repeats: true)
                self.mainview.isHidden = false
                self.mainview.isUserInteractionEnabled = true
            self.navigationController?.navigationBar.isUserInteractionEnabled = false

            }
        }
    }
    
    func setreqtbl(){
        self.reqbreakadapter.removeAll()
        var stmt1:OpaquePointer?
        let query = "select * from GetBreak order by uid"
                          
                 if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
                     let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                     print("error preparing get: \(errmsg)")
                     return
                 }

                 while(sqlite3_step(stmt1) == SQLITE_ROW){
                    let frst = String(cString: sqlite3_column_text(stmt1, 1))
                    let scnd = String(cString: sqlite3_column_text(stmt1, 2))
                    let thrd = String(cString: sqlite3_column_text(stmt1, 3))

                    self.reqbreakadapter.append(BREAKADAPTER(firsttxt: frst, secondtxt: scnd, thirdtxt: thrd))
        }
        self.reqbreaktbl.reloadData()
    }
    
    func setbrktbl(){
        var stmt1:OpaquePointer?
        self.breakadapter.removeAll()
        let query = "select case when endtime = '' then starttime || ' to -' else starttime || ' to ' || endtime end as breakperiod, case when breaktime = '' then '-' else breaktime end as brtime from Break where date = '\(self.getdate(format: "yyyy-MM-dd"))'"
                          
                 if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
                     let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                     print("error preparing get: \(errmsg)")
                     return
                 }

                 while(sqlite3_step(stmt1) == SQLITE_ROW){
                    let fromto = String(cString: sqlite3_column_text(stmt1, 0))
                    let brtime = String(cString: sqlite3_column_text(stmt1, 1))
                    
                    self.breakadapter.append(BREAKADAPTER(firsttxt: "Break ", secondtxt: fromto, thirdtxt: brtime))
        }
        self.breaktbl.reloadData()
    }
    
    @objc func startapp(){
        self.cflag = true
        self.ctime?.invalidate()
        self.ctime = nil
        self.initdata()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reqbreaktbl.delegate = self
        self.breaktbl.delegate = self
        self.reqbreaktbl.dataSource = self
        self.breaktbl.dataSource = self
        
        let tapcard = UITapGestureRecognizer(target: self, action: #selector(self.startbreak))
        self.breakcard.addGestureRecognizer(tapcard)

        NotificationCenter.default.addObserver(self, selector: #selector(self.startapp), name: UIApplication.didBecomeActiveNotification, object: nil)
        
//        print("time diff : 4:00 pm - \(self.getdate(format: "hh:mm a")) = \(self.findDateDiff(time1Str: "4:00 PM", time2Str: self.getdate(format: "hh:mm a")))")
//        MARK:- EVENTBUS
        SwiftEventBus.onMainThread(self, name: "gotbreak") { (result) in
            self.setreqtbl()
            self.api = 2
            self.gettoken()
            UserDefaults.standard.setValue(self.getdate(format: "yyyy-MM-dd"), forKey: "brdate")
        }
        SwiftEventBus.onMainThread(self, name: "notbreak") { (result) in
            self.hideindicator()
            self.showToast(message: "No data recieved")
            self.breakcard.isUserInteractionEnabled = false
        }
        SwiftEventBus.onMainThread(self, name: "cerr") { (result) in
            self.hideindicator()
            self.showToast(message: "Server not reachable")
            self.breakcard.isUserInteractionEnabled = true
        }
        SwiftEventBus.onMainThread(self, name: "gotbh") { (result) in
            self.hideindicator()
            self.setcard()
            self.setbrktbl()
            self.breakcard.isUserInteractionEnabled = true
        }
        SwiftEventBus.onMainThread(self, name: "notbh") { (result) in
            self.hideindicator()
            self.showToast(message: "Break history not recieved.")
            self.setcard()
            self.breakcard.isUserInteractionEnabled = false
        }
    }
    
    override func sbgot() {
        if (self.getpend()){
            self.api = 4
            self.gettoken()
        }else{
            self.api = 1
            self.gettoken()
            self.setcard()
            self.setbrktbl()
            self.breakcard.isUserInteractionEnabled = true
        }
    }
    
    override func sbnot() {
        self.hideindicator()
        self.showToast(message: "Start Break not uploaded.")
        self.setcard()
        self.breakcard.isUserInteractionEnabled = false
    }
    
    override func ebgot() {
        self.api = 1
        self.gettoken()
        self.setcard()
        self.setbrktbl()
        self.breakcard.isUserInteractionEnabled = true
    }
    
    override func ebnot() {
        self.hideindicator()
        self.showToast(message: "End Break not uploaded.")
        self.setcard()
        self.breakcard.isUserInteractionEnabled = false
    }
    
    @objc func startbreak(){
        
            if (!flag){
                let alert = UIAlertController(title: "Alert", message: "Are you sure you want to start break. You will be locked out for 15 mins.", preferredStyle: .alert)
                
                let yes = UIAlertAction(title: "Yes", style: .default) { (result) in
                    self.insertbreak(drid: UserDefaults.standard.string(forKey: "userid")!, date: self.getdate(format: "yyyy-MM-dd"), brid: self.getdate(format: "yyyy-MM-dd HH:mm:ss.SSS"), starttime: self.getdate(format: "hh:mm:ss a"), endtime: "", breaktime: "")
                    self.cflag = true
                    if (AppDelegate.ntwrk > 0){
                        alert.dismiss(animated: true, completion: nil)
                        self.showIndicator("Syncing...", vc: self)
                        self.api = 3
                        self.gettoken()
                    }else{
                        alert.dismiss(animated: true, completion: nil)
                    }
                    
                }
                
                let no = UIAlertAction(title: "No", style: .destructive) { (result) in
                    alert.dismiss(animated: true, completion: nil)
                }
                alert.addAction(yes)
                alert.addAction(no)
                self.present(alert, animated: true, completion: nil)
            }else{
                let brtime = self.findDateDiff(time1Str: self.starttime, time2Str: self.getdate(format: "hh:mm:ss a"))
                let dur = self.getduration(time1Str: self.starttime, time2Str: self.getdate(format: "hh:mm:ss a"))
                
                self.updatebreak(date: self.getdate(format: "yyyy-MM-dd"), endtime: self.getdate(format: "hh:mm:ss a"), breaktime: brtime, duration: "\(dur)")
                if (AppDelegate.ntwrk > 0){
                    self.showIndicator("Syncing...", vc: self)
                    api = 4
                    self.gettoken()
                }
            }
            self.setcard()
            self.setbrktbl()
    }
    
    @objc func changedriver(){
        self.push(storybId: "BREAK", vcId: "CDNC", vc: self)
    }
    
    
}
