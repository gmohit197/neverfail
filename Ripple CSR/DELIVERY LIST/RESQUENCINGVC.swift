//
//  RESQUENCINGVC.swift
//  Ripple CSR
//
//  Created by aayush shukla on 21/02/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import ChameleonFramework
import SWRevealViewController
import MapKit
import CoreLocation
import SQLite3

enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"
    
    var errorDescription: String? {
        rawValue
    }
}

protocol ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}

class RESQUENCINGVC: BASEACTIVITY,UITableViewDataSource,UITableViewDelegate,EditClicked, UIGestureRecognizerDelegate,MKMapViewDelegate, CLLocationManagerDelegate {
    
    func Editaction(custid: String,custname: String,custadd : String) {
        print("custid=======> \(custid)")
        let custinfo = self.storyboard?.instantiateViewController(withIdentifier: "CUSTINFOVC") as! CUSTOMERINFOVC
        CUSTORDERVC.custid = custid
        AppDelegate.custid = custid
        AppDelegate.isorder = false
        self.navigationController?.pushViewController(custinfo, animated: true)
    }
    
    var listitem = [DELIVERYADAPTER]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listitem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "sequencecell") as! sequencecell
        
        let list: DELIVERYADAPTER
        
        list = listitem[indexPath.row]
        
        cell.name.text = list.name
        cell.streetadd.text = list.stradd
        cell.stateadd.text = list.stateadd 
        cell.custid = list.custid
        cell.custname = list.name
        cell.cityadd.text = list.city
        cell.custadd = list.stradd! + "," + list.stateadd!
        cell.delegate = self
        
        let id = self.getlastactivityid(orderid: list.custid!)
        
        if (id == NoDelReason.reschedule.rawValue || id == NoDelReason.delivered.rawValue || id == NoDelReason.skip.rawValue) {
            cell.enable(on: false)
        }else{
            cell.enable(on: true)
        }
        
        if list.status! == "b" {
            cell.statusbar.backgroundColor=UIColor.systemBlue
        }
        else if list.status! == "o"{
            cell.statusbar.backgroundColor=UIColor.systemOrange
        }
        else{
            cell.statusbar.backgroundColor=UIColor.systemGreen
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let items = self.listitem[sourceIndexPath.row]
        self.listitem.remove(at: sourceIndexPath.row)
        self.listitem.insert(items, at: destinationIndexPath.row)
        
        let placesData = try! JSONEncoder().encode(self.listitem)
        UserDefaults.standard.set(placesData, forKey: "items")
        
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    private var myReorderImage : UIImage? = nil;
    var adapter = [DELIVERYADAPTER]()
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        for subViewA in cell.subviews {
            if (subViewA.classForCoder.description() == "UITableViewCellReorderControl") {
                for subViewB in subViewA.subviews {
                    if (subViewB.isKind(of: UIImageView.classForCoder())) {
                        let imageView = subViewB as! UIImageView;
                        if (myReorderImage == nil) {
                            let myImage = imageView.image;
                            myReorderImage = myImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate);
                        }
                        imageView.image = myReorderImage;
                        imageView.tintColor = UIColor.lightGray;
                        break;
                    }
                }
                break;
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.sequencetable.reloadData()
    }
    @IBOutlet var sequencetable: UITableView!
    
    @IBOutlet var mapview: MKMapView!
    @IBOutlet var menubutton: UIBarButtonItem!
    @IBOutlet var viewtype: UISegmentedControl!
    
    var api = 0
    
    lazy var overlayView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.6)
        return view
    }()
    @IBAction func viewtypesegment(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 1 {
            setmap()
            self.mapview.isHidden = false
        }else if sender.selectedSegmentIndex == 0 {
            self.mapview.isHidden = true
        }
    }
    
    @IBAction func menubtn(_ sender: UIBarButtonItem) {
        print("menu toggle...")
        self.revealViewController()?.revealToggle(animated: true)
    }
    var isorderby = false
    override func viewWillAppear(_ animated: Bool) {
        self.setnav(title: self.navigationItem.title!)
        if (UserDefaults.standard.string(forKey: "syncdate") == nil || UserDefaults.standard.string(forKey: "syncdate") != self.getdate(format: "yyyy-MM-dd")){
            self.isorderby = true
            if (AppDelegate.ntwrk > 0){
                self.showIndicator("Syncing...", vc: self)
                self.call = 4
                self.clearsequence()
                self.doclearorders()
                self.gettoken()
                
            }
        }else{
            initinvtbl()
            setlist()
            self.insertts_fromload()
        }
    }
    
    func doclearorders(){
        self.deleteposttable(tbl: "custorderheader")
        self.deleteposttable(tbl: "custorderline")
        self.deleteposttable(tbl: "CustItemCharge")
        self.deleteposttable(tbl: "CustItemTax")
        self.deletesbatchtbl(type: "custorder")
        self.deletetable(tbl: "images")
        self.deletetable(tbl: "nodelreason")
    }
    
    override func crmcallback() {
        refreshControl.endRefreshing()
        self.showIndicator("Syncing...", vc: self)
        self.postlead(token: self.accessToken)
    }
    
    override func lead() {
        self.postleadnote()
    }
    
    override func note() {
        if (CONSTANT.leadname.count > 0 || CONSTANT.notename.count > 0){
            self.hideindicator()
            self.showToast(message: "Data sync failed - Lead not uploaded successfully")
            //            self.call = 1
            //            self.gettoken()
        }else{
            self.call = 1
            self.gettoken()
        }
    }
    
    override func callback() {
        CONSTANT.apicall = 0
        CONSTANT.failapi = 0
        self.api = 0
        AppDelegate.loaderr = ""
        AppDelegate.ordererr = ""
        
        if (call == 1){
            self.postnewcust()
        }else if (call == 2){
            self.postcustorder()
        }else if (call == 3){
            self.poststartbreak()
        }else if (call == 4){
            refreshControl.endRefreshing()
            self.showIndicator("Syncing...", vc: self)
            self.downloadall()
        }
    }
    
    var call = 0
    
    override func cust(){
        if (CONSTANT.custname.count > 0){
            self.hideindicator()
            self.showToast(message: "Data sync failed - Customer creation failed")
            //            self.call = 2
            //            self.gettoken()
        }else{
            self.call = 2
            self.gettoken()
        }
    }
    
    override func sbgot() {
        self.postendbreak()
    }
    
    override func sbnot() {
        self.hideindicator()
        self.showToast(message: "Data sync failed - Start break not posted.")
    }
    
    override func ebgot() {
        self.call = 4
        self.gettoken()
    }
    
    override func ebnot() {
        self.hideindicator()
        self.showToast(message: "Data sync failed - End break not posted.")
    }
    
    override func ordererr() {
        self.hideindicator()
        self.showToast(message: "Data sync failed - Customer order not posted.")
    }
    
    override func ordernot() {
        self.hideindicator()
        self.showToast(message: "Data sync failed - Customer order not posted.")
    }
    
    override func orderdone() {
        self.call = 3
        self.gettoken()
    }
    
    func downloadall(){
        CONSTANT.mastername.removeAll()
        CONSTANT.apicall = 0
        CONSTANT.failapi = 0
        AppDelegate.loaderr = ""
        AppDelegate.ordererr = ""
        print("\n DOWNLOAD ALL ---------------------------> \n ")
        
        self.getloaddetails_sync()
        self.gettaxgroup()
        self.gettaxmaster()
        self.getautocharge()
        self.getitemmaster()
//        self.getbatchmaster()
//        self.getserialmaster()
        self.getpricemaster()
        self.getdiscountmaster()
        //New Added
        self.getrevenueschedule()
        self.getreasonmaster()
        self.getTruckMaster()
        self.getunloaddetails()
        self.getTransferDeltais()
        self.getlineodduty()
        self.getsubsegment()
    }
    
    override func apicall() {
        self.api += 1
        var mname = ""
        print("api --> \(api) | CONSTANT.apicall --> \(CONSTANT.apicall)")
        if (self.api == CONSTANT.apicall){
            if (CONSTANT.failapi > 0){
                print("api num --> \(self.api)")
                if (AppDelegate.loaderr.count > 0){
                    self.showToast(message: AppDelegate.loaderr)
                }else if(AppDelegate.ordererr.count > 0){
                    self.showToast(message: AppDelegate.ordererr)
                }else{
                    if (CONSTANT.mastername.count > 0){
                        mname = CONSTANT.mastername[0]
                        if (CONSTANT.mastername.count > 1){
                            for i in 1..<CONSTANT.mastername.count {
                                mname = mname + " ," + CONSTANT.mastername[i]
                            }
                        }
                    }
                    self.showToast(message: "Following Master(s) not downloaded - \(mname)")
                }
            }else{
                self.showToast(message: "Data synced successfully")
            }
            self.deletetable(tbl: "TruckStock")
            self.insertts_fromload()
            self.hideindicator()
            UserDefaults.standard.set(self.getdate(format: "yyyy-MM-dd"), forKey: "syncdate")
            initinvtbl()
            setlist()
        }
    }
    
    override func failcall() {
        self.hideindicator()
        refreshControl.endRefreshing()
        self.showToast(message: "Authentication Failure")
    }
    
    func setupView(){
        // MARK:- setup view for swipe reveal
        view.addSubview(overlayView)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                overlayView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        } else {
            // Fallback on earlier versions
        }
        
        overlayView.alpha = 0
    }
    
    func setupswreveal(){
        // MARK:- setup swipe reveal
        
        if self.revealViewController() != nil {
            menubutton.target = self.revealViewController()
            menubutton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.revealViewController()?.rearViewRevealWidth = UIScreen.main.bounds.width * (8/10)
    }
    
    var locationManager: CLLocationManager!
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sequencetable.dataSource=self
        sequencetable.delegate=self
        sequencetable.isEditing=true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapEdit))
        sequencetable.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
        
        setupView()
        setupswreveal()
        self.revealViewController()?.delegate = self
        
        self.mapview.isHidden = true
        
        //        MARK:- PULL to REFRESH
        refreshControl.attributedTitle = NSAttributedString(string: "Syncing...")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            sequencetable.refreshControl = refreshControl
        } else {
            sequencetable.addSubview(refreshControl) // not required when using UITableViewController
        }
        
    }
    
    
    
    @objc func refresh(_ sender: AnyObject) {
        // Code to refresh table view
        if (AppDelegate.ntwrk > 0){
            //            self.showIndicator("Syncing...", vc: self)
//            self.getcrmtoken()
            self.isorderby = false
            self.call = 4
            self.gettoken()
        }else{
            refreshControl.endRefreshing()
            showToast(message: "Internet connection required to refresh data.")
        }
    }
    
    func setlist(){
        var stmt1:OpaquePointer?
        self.adapter.removeAll()
        
        var query = ""
        
        if (isorderby){
            query = "select custordernum, custname,ifnull(custstreet,'-'),ifnull(custcity,'-'),ifnull(custstate,'-'),status,lastactivityid, lati ,longi from CustorderHeader order by cast(callday3 as int) --where shipdate = '\(self.getdate(format: "yyyy-MM-dd"))'"
        }else{
            query = "select custordernum, custname,ifnull(custstreet,'-'),ifnull(custcity,'-'),ifnull(custstate,'-'),status,lastactivityid, lati ,longi from CustorderHeader --where shipdate = '\(self.getdate(format: "yyyy-MM-dd"))'"
        }
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        self.points.removeAll()
        custname.removeAll()
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let id = String(cString: sqlite3_column_text(stmt1, 0))
            let name = String(cString: sqlite3_column_text(stmt1, 1))
            let stradd = String(cString: sqlite3_column_text(stmt1, 2))
            let stateadd = String(cString: sqlite3_column_text(stmt1, 4))
            let city = String(cString: sqlite3_column_text(stmt1, 3))
            let stat = String(cString: sqlite3_column_text(stmt1, 5))
            let lastid = String(cString: sqlite3_column_text(stmt1, 6))
            let lat = sqlite3_column_double(stmt1, 7)
            let longi = sqlite3_column_double(stmt1, 8)
            
            if (lat != 0.0 && longi != 0.0){
                let point1 = CLLocationCoordinate2DMake(lat, longi);
                self.points.append(point1)
                custname.append(name)
            }
            
            self.adapter.append(DELIVERYADAPTER(custid: id, name: name, stradd: stradd, stateadd: stateadd, status: stat,city: city,lastactivityid: lastid))
        }
        if (self.points.count > 0){
            self.setmap()
        }
        let placeData = UserDefaults.standard.data(forKey: "items")
        if (placeData == nil){
            let placesData = try! JSONEncoder().encode(self.adapter)
            //            UserDefaults.standardUserDefaults().setObject(placesData, forKey: "items")
            print("\n array created")
            UserDefaults.standard.set(placesData, forKey: "items")
            listitem = self.adapter
        }else{
            let placeArray = try! JSONDecoder().decode([DELIVERYADAPTER].self, from: placeData!)
            if (placeArray.isEmpty){
                let placesData = try! JSONEncoder().encode(self.adapter)
                //            UserDefaults.standardUserDefaults().setObject(placesData, forKey: "items")
                print("\n array created")
                UserDefaults.standard.set(placesData, forKey: "items")
                listitem = self.adapter
            }else{
                listitem = placeArray
                let count = listitem.count
                if (count < self.adapter.count){
                    let index = count
                    for i in index..<self.adapter.count{
                        let items: DELIVERYADAPTER
                        items = self.adapter[i]
                        //                        self.listitem.insert(items, at: i)
                        self.listitem.append(items)
                    }
                    let placesData = try! JSONEncoder().encode(self.listitem)
                    UserDefaults.standard.set(placesData, forKey: "items")
                }
            }
        }
        
        self.sequencetable.reloadData()
    }
   
    
    // MARK:- maps work
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            //            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            //            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            //            self.mapview.setRegion(region, animated: true)
            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
            
            locationManager.stopUpdatingLocation()
        }
    }
    
    func setmap(){
        self.mapview.delegate = self
        locationManager = CLLocationManager()
        //        locationManager.requestAlway`sAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        if (self.points.count > 0){
            createpolyline()
        }
    }
    var points: [CLLocationCoordinate2D]! = []
    var custname: [String]! = []
    
    struct Location {
        let title: String
        let latitude: Double
        let longitude: Double
    }
    var center: CLLocationCoordinate2D!
    func createpolyline(){
        
        let mid = self.points.count/2
        let cent = self.points[mid]
        
        center = cent
        var i: Int! = 0
        var locations = [Location]()
        while(i<points.count){
            locations.append(Location(title: self.custname[i], latitude: points[i].latitude, longitude: points[i].longitude))
            i = i+1;
        }

        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.title = location.title
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            mapview.addAnnotation(annotation)
        }
        i=0
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        self.mapview.setRegion(region, animated: true)
        //        while (i < (points.count-1)){
        //            print("\(i!)")
        //            self.setpath(lat1: points[i!].latitude, longi1: points[i!].longitude, lat2: points[i!+1].latitude, longi2: points[i!+1].longitude)
        //       let center = CLLocationCoordinate2D(latitude: points[4].latitude, longitude: points[4].longitude)
        //            i = i+1;
        //        }
    }
    //MARK:- set path on map here
    func setpath(lat1 : Double, longi1: Double,lat2 : Double, longi2: Double){
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: lat1, longitude: longi1), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: lat2, longitude: longi2), addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            for route in unwrappedResponse.routes {
                self.mapview.addOverlay(route.polyline)
                self.mapview.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    func initinvtbl(){
        self.deletetable(tbl: "Invoice")
        
        self.insertinvoice(date: self.getdate(format: "dd/MM/yy"), invoiceid: "Inv 20213344", amount: "20", status: "0")
        self.insertinvoice(date: self.getdate(format: "dd/MM/yy"), invoiceid: "Inv 20213351", amount: "55", status: "0")
        self.insertinvoice(date: "16/03/20", invoiceid: "Inv 20213362", amount: "40", status: "0")
        self.insertinvoice(date: "26/03/20", invoiceid: "Inv 20213382", amount: "120", status: "0")
        self.insertinvoice(date: "07/04/20", invoiceid: "Inv 20213392", amount: "150", status: "0")
        self.insertinvoice(date: "14/04/20", invoiceid: "Inv 20213401", amount: "60", status: "0")
        self.insertinvoice(date: "23/05/20", invoiceid: "Inv 20213431", amount: "35", status: "0")
    }
    
    @objc func tapEdit(recognizer: UITapGestureRecognizer)  {
        if recognizer.state == UIGestureRecognizer.State.ended {
            let tapLocation = recognizer.location(in: self.sequencetable)
            if let tapIndexPath = self.sequencetable.indexPathForRow(at: tapLocation) {
                if let tappedCell = self.sequencetable.cellForRow(at: tapIndexPath) as? sequencecell {
                    print("cell tapped ====> \(tappedCell.name.text)")
                    let id = self.getlastactivityid(orderid: tappedCell.custid!)
                    let storyboard = UIStoryboard(name: "RESQUENCING", bundle: nil)
                    let registrationVC = storyboard.instantiateViewController(withIdentifier: "CUSTORDERVC") as! CUSTORDERVC
                    registrationVC.navigationItem.title = "Customer Order"
                    CUSTORDERVC.custid = tappedCell.custid
                    AppDelegate.custid = tappedCell.custid
                    AppDelegate.isorder = false
                    self.navigationController?.pushViewController(registrationVC, animated: true)
                }
            }
        }
    }
    
}

// MARK:- setup view for swipe reveal delegates
extension RESQUENCINGVC: SWRevealViewControllerDelegate{
    
    //varying alpha of overlayView with progress of panGesture to reveal or hide menu view
    func revealController(_ revealController: SWRevealViewController!, panGestureMovedToLocation location: CGFloat, progress: CGFloat) {
        overlayView.alpha = progress
    }
    
    //animating alpha in case user just taps hamburger menu which directly change FrontViewPosition
    func revealController(_ revealController: SWRevealViewController!, animateTo position: FrontViewPosition) {
        
        //menu view is hidden
        if position == FrontViewPosition.left{
            overlayView.alpha = 0
        }
        
        //menu view is revealed
        if position == FrontViewPosition.right{
            overlayView.alpha = 1
        }
    }
}
extension UserDefaults: ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}
